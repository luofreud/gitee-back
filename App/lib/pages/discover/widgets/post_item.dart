import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:get/get.dart';

import '../../../models/article/post.dart';
import '../../../widgets/animation/liveing_animation.dart';

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({super.key, required this.post});

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

  @override
  Widget build(BuildContext context) {
    List<String> imgList = _parseImgs(post.imgs);
    String displayImg = imgList.isNotEmpty ? imgList.first : '';

    List<Widget> _liveWidges = [];
    if (post.teachroom != null) {
      _liveWidges = [
        GestureDetector(
          onTap: () {
            Get.toNamed(
              AppRoutes.LIVE_ROOM,
              arguments: {'roomId': post.teachroom?.id?.toString()},
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(100),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Text(
              '点击进入直播间',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
        Positioned(
          left: 10,
          bottom: 10,
          right: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              _LiveingWidget(),
              Text(
                '@${post.teachroom?.teacher?.name}',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              Text(
                post.teachroom?.title ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
      ];
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.POST_DETAIL, arguments: post.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            if (displayImg.isNotEmpty)
              Stack(
                alignment: Alignment.center,
                children: [
                  ImageView.network(
                    displayImg,
                    width: double.infinity,
                    height: 226,
                    isPreview: false,
                    fit: BoxFit.cover,
                  ),
                  if (post.teachroom != null) ..._liveWidges,
                ],
              ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Color(0xff383838)),
                  ),
                  Row(
                    spacing: 3,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 8,
                        foregroundImage: post.user?.headimg != null
                            ? NetworkImage(post.user!.headimg!)
                            : null,
                      ),
                      Expanded(
                        child: Text(
                          post.user?.nickname ??
                              (post.isanonymous == 1 ? '匿名' : ''),
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xffA6A6A6),
                          ),
                        ),
                      ),
                      Image.asset('assets/icons/icon_zan2.png', width: 16),
                      Text(
                        '${post.likecount ?? 0}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xffA6A6A6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveingWidget extends StatelessWidget {
  const _LiveingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: LinearGradient(
          colors: [Color(0xffC43BFF), Color(0xffFF4040)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        spacing: 3,
        children: [
          Transform.translate(
            offset: Offset(0, -3),
            child: LiveingAnimationWidget(),
          ),
          Text('正在直播', style: TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }
}
