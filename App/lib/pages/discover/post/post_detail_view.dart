import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freud/models/article/comment.dart';
import 'package:freud/widgets/empty_tips.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import '../../../widgets/component/image_view.dart';
import 'post_detail_controller.dart';

class PostDetailPage extends GetView<PostDetailController> {
  const PostDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => PostDetailController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: RefreshLoadmore(
              onLoad: () async {
                await controller.loadMore();
              },
              controller: controller.refreshController,
              child: CustomScrollView(
                slivers: [
                  // 帖子详情
                  SliverToBoxAdapter(
                    child: _PostDetailView(controller: controller),
                  ),
                  // 评论
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConst.PAGE_PADDING,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 6,
                          ),
                          bottom: BorderSide(color: Color(0xffF7F7F7)),
                        ),
                        color: Colors.white,
                      ),
                      child: Obx(() {
                        return Row(
                          children: [
                            const Text('评论'),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                controller.commentSort.value = 'hot';
                                controller.reloadBySort();
                              },
                              child: Text(
                                '热门',
                                style: TextStyle(
                                  color: controller.commentSort == 'hot'
                                      ? Colors.black
                                      : Color(0xffA6A6A6),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                              height: 14,
                              child: VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.commentSort.value = 'new';
                                controller.reloadBySort();
                              },
                              child: Text(
                                '最新',
                                style: TextStyle(
                                  color: controller.commentSort == 'new'
                                      ? Colors.black
                                      : Color(0xffA6A6A6),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  Obx(() {
                    if (controller.listData.isEmpty) {
                      return SliverToBoxAdapter(
                        child: SizedBox(
                          height: 300,
                          child: Center(
                            child: controller.isLoading.value
                                ? CircularProgressIndicator()
                                : EmptyTips(title: '暂无评论'),
                          ),
                        ),
                      );
                    }
                    return SliverList.separated(
                      itemCount: controller.listData.length,
                      separatorBuilder: (_, index) {
                        return Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(top: 10),
                          child: Divider(
                            thickness: 1,
                            color: Color(0xffF7F7F7),
                          ),
                        );
                      },
                      itemBuilder: (_, index) {
                        return _CommentItem(
                          comment: controller.listData[index],
                          controller: controller,
                        );
                      },
                    );
                  }),
                  // 结尾标记
                  Obx(() {
                    if (controller.listData.isNotEmpty &&
                        controller.isNoMore.value) {
                      return SliverToBoxAdapter(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          alignment: Alignment.center,
                          child: Text(
                            '已加载全部评论',
                            style: TextStyle(color: Color(0xffD1D1D1)),
                          ),
                        ),
                      );
                    }
                    return SliverToBoxAdapter();
                  }),
                ],
              ),
            ),
          ),
          _ReplyContainer(controller: controller),
        ],
      ),
    );
  }
}

class _PostDetailView extends StatelessWidget {
  final PostDetailController controller;

  const _PostDetailView({required this.controller});

  final TextStyle _tipTextStyle = const TextStyle(
    fontSize: 14,
    color: Color(0xffA6A6A6),
  );

  List<String> _parseImgs(String? imgs) {
    if (imgs == null || imgs.isEmpty) return [];
    try {
      var decoded = jsonDecode(imgs);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return imgs
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  List<String> _parseTags(String? tags) {
    if (tags == null || tags.isEmpty) return [];
    return tags
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var post = controller.post.value;
      if (post == null) {
        return SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      var imgList = _parseImgs(post.imgs);
      var tagList = _parseTags(post.tags);
      return Container(
        padding: const EdgeInsets.only(
          left: AppConst.PAGE_PADDING,
          right: AppConst.PAGE_PADDING,
          bottom: AppConst.PAGE_PADDING,
        ),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: post.user?.headimg != null
                    ? NetworkImage(post.user!.headimg!)
                    : null,
              ),
              title: Text(
                post.isanonymous == 1 ? '匿名' : (post.user?.nickname ?? ''),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              tileColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              subtitle: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffA1CAFF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    child: Text(
                      'Lv.${post.user?.level ?? 1}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              post.content ?? '',
              style: TextStyle(color: Color(0xff5E5E5E)),
            ),
            if (imgList.isNotEmpty)
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: imgList.length,
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (_, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: ImageView.network(
                      imgList[index],
                      urls: imgList,
                      showIndicator: true,
                      isPreview: true,
                    ),
                  );
                },
              ),
            Text(
              post.createtime ?? '',
              style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
            ),
            if (tagList.isNotEmpty)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: tagList.map((tag) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(0xffE3E9FF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    child: Text(
                      '# $tag',
                      style: TextStyle(fontSize: 12, color: Color(0xff6778B5)),
                    ),
                  );
                }).toList(),
              ),
            Row(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => controller.toggleCollect(),
                  child: Row(
                    children: [
                      Image.asset(
                        post.iscollection == 1
                            ? 'assets/icons/topic_icon_sc2.png'
                            : 'assets/icons/topic_icon_sc.png',
                        width: 22,
                        height: 22,
                      ),
                      Text(
                        '${post.collectioncount ?? 0}',
                        style: _tipTextStyle,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/topic_icon_pl.png',
                      width: 22,
                      height: 22,
                    ),
                    Text('${post.commentcount ?? 0}', style: _tipTextStyle),
                  ],
                ),

                GestureDetector(
                  onTap: () => controller.likePost(),
                  child: Row(
                    children: [
                      Image.asset(
                        post.islike == 1
                            ? 'assets/icons/topic_icon_zan2.png'
                            : 'assets/icons/topic_icon_zan.png',
                        width: 22,
                        height: 22,
                      ),
                      Text('${post.likecount ?? 0}', style: _tipTextStyle),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _CommentItem extends StatelessWidget {
  final Comment comment;
  final PostDetailController controller;

  const _CommentItem({
    super.key,
    required this.comment,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: comment.xzuser?.headimg != null
                  ? NetworkImage(comment.xzuser!.headimg!)
                  : AssetImage('assets/images/default_avatar.png'),
            ),
            title: Text(
              comment.xzuser?.nickname ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            tileColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppConst.PAGE_PADDING,
            ),
            subtitle: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffA1CAFF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                  child: Text(
                    'Lv.${comment.xzuser?.level ?? 1}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
            trailing: GestureDetector(
              onTap: () => controller.likeComment(comment.id!, comment.islike!),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 3,
                children: [
                  Image.asset(
                    comment.islike == 1
                        ? 'assets/icons/topic_icon_zan2.png'
                        : 'assets/icons/topic_icon_zan.png',
                    width: 20,
                    height: 20,
                  ),
                  Text(
                    '${comment.likecount ?? 0}',
                    style: TextStyle(fontSize: 16, color: Color(0xffA6A6A6)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 80,
              right: AppConst.PAGE_PADDING,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.content ?? '',
                  style: TextStyle(color: Color(0xff5E5E5E)),
                ),
                if ((comment.replycount ?? 0) > 0)
                  _CommentReply(comment: comment, controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentReply extends StatelessWidget {
  final Comment comment;
  final PostDetailController controller;

  const _CommentReply({
    super.key,
    required this.comment,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(
        color: Color(0xffF7FAFC),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: Obx(() {
        var replies = comment.replay ?? [];
        var isExpanded = controller.expandedReplyIds.contains(comment.id);
        var allReplies = isExpanded && comment.id != null
            ? (controller.repliesCache[comment.id!] ?? <Comment>[])
            : <Comment>[];
        var displayReplies = isExpanded ? allReplies : replies;

        if (displayReplies.isEmpty &&
            (comment.replycount == null || comment.replycount! <= 0)) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...displayReplies.map(
              (reply) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12, height: 1.4),
                    children: [
                      TextSpan(
                        text: '${reply.xzuser?.nickname ?? ''}：',
                        style: const TextStyle(color: Color(0xff2A82E4)),
                      ),
                      TextSpan(
                        text: reply.content ?? '',
                        style: const TextStyle(color: Color(0xff383838)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (comment.replycount != null && comment.replycount! > 0)
              const SizedBox(height: 5),
            if (comment.replycount != null && comment.replycount! > 0)
              GestureDetector(
                onTap: () => controller.toggleReplies(comment.id!),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isExpanded ? '收起回复' : '查看全部${comment.replycount}条回复',
                      style: const TextStyle(
                        color: Color(0xff808080),
                        fontSize: 12,
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: const Color(0xff808080),
                      size: 22,
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _ReplyContainer extends StatelessWidget {
  final PostDetailController controller;

  const _ReplyContainer({super.key, required this.controller});

  /// 输入框边框
  static const _textFieldBorder = OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
  );

  /// 发送按钮
  _sendButton(bool isModal, {BuildContext? context}) {
    return Obx(() {
      return GradientButton(
        onPressed: controller.replyText.isEmpty
            ? null
            : () async {
                await controller.sendReply();
                if (isModal) {
                  Navigator.of(context!).pop();
                }
              },
        radius: 5,
        isRadius: false,
        height: 32,
        padding: EdgeInsets.symmetric(horizontal: 30),
        gradient: LinearGradient(
          colors: [Color(0xff4D1FAE), Color(0xff0A2063)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        child: Text('发送'),
      );
    });
  }

  /// 显示输入框
  showTextField(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      barrierColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) {
        // 获取已经输入的文本值
        String defaultTextValue = controller.replyText.value;
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xffF7F7F7))),
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConst.PAGE_PADDING,
            vertical: 10,
          ),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '礼貌交流',
                    hintStyle: TextStyle(
                      color: Color(0xffA6A6A6),
                      fontSize: 14,
                    ),
                    border: _textFieldBorder,
                    focusedBorder: _textFieldBorder,
                    enabledBorder: _textFieldBorder,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: Color(0xffF7FAFC),
                  ),
                  controller: TextEditingController(text: defaultTextValue)
                    ..selection = TextSelection(
                      baseOffset: defaultTextValue.length,
                      extentOffset: defaultTextValue.length,
                    ),
                  autofocus: true,
                  onChanged: (value) {
                    controller.replyText.value = value;
                  },
                ),
              ),
              _sendButton(true, context: context),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xffF7F7F7))),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConst.PAGE_PADDING,
        vertical: 10,
      ),
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                showTextField(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 32,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Color(0xffF7FAFC),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Obx(() {
                  if (controller.replyText.value.isNotEmpty) {
                    return Text(controller.replyText.value);
                  }
                  return Text(
                    '礼貌交流~',
                    style: TextStyle(color: Color(0xffA6A6A6)),
                  );
                }),
              ),
            ),
          ),
          _sendButton(false),
        ],
      ),
    );
  }
}
