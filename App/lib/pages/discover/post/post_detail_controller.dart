import 'package:easy_refresh/easy_refresh.dart';
import 'package:freud/api/api.dart';
import 'package:freud/models/article/comment.dart';
import 'package:freud/models/article/post.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:get/get.dart';

import '../../../widgets/refresh_loadmore.dart';

class PostDetailController extends GetxController {
  /// 帖子ID
  int? postId;

  /// 评论排序：hot-热门, new-最新
  final commentSort = 'hot'.obs;

  /// 下拉刷新控制器
  late RefreshController refreshController;

  /// 是否正在加载评论
  final isLoading = false.obs;

  /// 是否没有更多评论
  final isNoMore = false.obs;

  /// 评论列表数据
  final listData = <Comment>[].obs;

  /// 当前分页页码
  int _page = 1;

  /// 回复缓存，key为父评论ID
  final repliesCache = <int, List<Comment>>{};

  /// 已展开回复的评论ID集合
  final expandedReplyIds = <int>{}.obs;

  /// 回复输入框文本
  final replyText = ''.obs;

  /// 当前帖子详情
  final Rx<Post?> post = Rx<Post?>(null);

  /// 点赞防重复点击
  final isLiking = false.obs;

  /// 收藏防重复点击
  final isCollecting = false.obs;

  /// 当前收藏记录的订阅ID（取消收藏时需要）
  int? subscribeId;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(
      controller: EasyRefreshController(controlFinishLoad: false),
    );
    postId = Get.arguments;
    if (postId != null) {
      _loadPost(postId!);
      _loadComments();
    }
  }

  /// 加载帖子详情
  _loadPost(int id) async {
    var result = await PostApi().postDetail(id);
    if (result != null) {
      post.value = result;
      if (result.iscollection == 1) {
        _fetchSubscribeId();
      }
    }
  }

  /// 查询当前帖子的收藏记录ID
  _fetchSubscribeId() async {
    var data = await UserApi().userSubPage(
      PageRequest(page: 1, pageSize: 1),
      corrid: postId,
      stype: 3,
    );
    if (data?.items != null && data!.items!.isNotEmpty) {
      subscribeId = data.items!.first.id;
    }
  }

  /// 加载评论列表
  _loadComments() async {
    if (postId == null) return;
    isLoading.value = true;
    var req = PageRequest(page: _page, pageSize: 10, descStr: 'desc');
    if (commentSort.value == 'hot') {
      req.field = 'likecount';
    }
    var data = await CommentApi().commentPage(
      req,
      filters: {'aid': postId, 'parentid': 0},
    );
    if (data != null && data.items != null) {
      if (_page == 1) {
        listData.clear();
      }
      listData.addAll(data.items!);
      if (data.hasNextPage == false) {
        isNoMore.value = true;
      }
    }
    isLoading.value = false;
  }

  /// 按排序方式重新加载评论
  void reloadBySort() {
    _page = 1;
    listData.clear();
    isNoMore.value = false;
    _loadComments();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  /// 加载更多评论
  loadMore() async {
    if (isLoading.value || isNoMore.value) return;
    _page++;
    await _loadComments();
    refreshController.finishLoad(
      isNoMore.value ? IndicatorResult.noMore : IndicatorResult.success,
      true,
    );
  }

  /// 点赞/取消点赞帖子
  likePost() async {
    if (isLiking.value) return;
    var current = post.value;
    if (current?.id == null) return;
    isLiking.value = true;
    var success = await PostApi().postLike(current!.id!);
    if (success) {
      post.update((val) {
        var wasLiked = val?.islike == 1;
        val?.islike = wasLiked ? 0 : 1;
        val?.likecount = (val?.likecount ?? 0) + (wasLiked ? -1 : 1);
      });
    }
    isLiking.value = false;
  }

  /// 收藏/取消收藏帖子
  toggleCollect() async {
    if (isCollecting.value) return;
    var current = post.value;
    if (current?.id == null) return;
    isCollecting.value = true;
    if (current!.iscollection == 1) {
      if (subscribeId == null) await _fetchSubscribeId();
      if (subscribeId == null) {
        isCollecting.value = false;
        return;
      }
      var success = await UserApi().userSubDel(subscribeId!);
      if (success) {
        post.update((val) {
          val?.iscollection = 0;
          val?.collectioncount = (val?.collectioncount ?? 1) - 1;
        });
        subscribeId = null;
      }
    } else {
      var success = await UserApi().userSubAdd({
        "corrid": current.id,
        "stype": 3,
      });
      if (success) {
        post.update((val) {
          val?.iscollection = 1;
          val?.collectioncount = (val?.collectioncount ?? 0) + 1;
        });
        _fetchSubscribeId();
      }
    }
    isCollecting.value = false;
  }

  /// 点赞/取消点赞评论
  likeComment(int id, int islike) async {
    var success = islike == 1
        ? await CommentApi().delLike(id)
        : await CommentApi().addLike(id);
    if (success) {
      var index = listData.indexWhere((c) => c.id == id);
      if (index != -1) {
        var c = listData[index];
        listData[index] = Comment(
          id: c.id,
          uid: c.uid,
          aid: c.aid,
          content: c.content,
          likecount: (c.likecount ?? 0) + (islike == 1 ? -1 : 1),
          islike: islike == 1 ? 0 : 1,
          parentid: c.parentid,
          replycount: c.replycount,
          state: c.state,
          createtime: c.createtime,
          xzuser: c.xzuser,
          replay: c.replay,
        );
        listData.refresh();
      }
    }
  }

  /// 展开/收起回复列表
  toggleReplies(int parentId) async {
    if (expandedReplyIds.contains(parentId)) {
      expandedReplyIds.remove(parentId);
      return;
    }
    if (repliesCache.containsKey(parentId)) {
      expandedReplyIds.add(parentId);
      return;
    }
    var data = await CommentApi().commentPage(
      PageRequest(page: 1, pageSize: 100),
      filters: {'aid': post.value?.id, 'parentid': parentId},
    );
    repliesCache[parentId] = data?.items ?? [];
    expandedReplyIds.add(parentId);
  }

  /// 发送评论
  sendReply() async {
    if (replyText.isEmpty) return;
    var text = replyText.value;
    replyText.value = '';
    await CommentApi().add(Comment(content: text, aid: post.value?.id));
    _page = 1;
    _loadComments();
    post.update((val) {
      val?.commentcount = (val?.commentcount ?? 0) + 1;
    });
  }
}
