import 'package:freud/models/article/comment.dart';
import 'package:freud/models/base/base_response.dart';
import 'package:freud/models/base/page_request.dart';
import 'package:freud/models/base/page_response.dart';
import 'package:freud/utils/request_util.dart';

class CommentApi {
  /// 分页查询用户评论列表
  Future<PageData<Comment>?> commentPage(PageRequest req, {Map<String, dynamic>? filters}) async {
    var data = req.toJson();
    if (filters != null) data.addAll(filters);
    var res = await RequestUtil.getInstance().post(
      "/appXzArticlecomments/page",
      data: data,
    );

    if (res?.code != 200) return null;

    var resJson = PageResponse<Comment>.fromJson(
      res?.data,
      (data) => Comment.fromJson(data),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  /// 增加用户评论
  Future<bool> add(Comment comment) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzArticlecomments/add",
      data: comment.toJson(),
    );
    if (res?.code != 200) return false;
    return true;
  }

  /// 删除用户评论
  Future<bool> delete(int id) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzArticlecomments/delete",
      data: {"id": id},
    );
    if (res?.code != 200) return false;
    return true;
  }

  /// 点赞用户评论
  Future<bool> addLike(int id) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzArticlecomments/addLike",
      data: {"id": id},
    );
    if (res?.code != 200) return false;
    return true;
  }

  /// 取消评论点赞
  Future<bool> delLike(int id) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzArticlecomments/delLike",
      data: {"id": id},
    );
    if (res?.code != 200) return false;
    return true;
  }
}
