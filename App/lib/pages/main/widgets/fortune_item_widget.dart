import 'package:flutter/material.dart';
import 'package:freud/widgets/component/icon_widget.dart';

class FortuneItemWidget extends StatelessWidget {
  final String? title;
  final Widget? titleLeading;
  final String? subTitle;
  final Widget? subTrailing;
  final String? content;
  final Function()? onTap;
  final Function()? onTapComment;
  final BorderRadiusGeometry? borderRadius;
  final Widget? titleTag;
  final int? contentLines;

  const FortuneItemWidget({
    super.key,
    this.title,
    this.titleLeading,
    this.subTitle,
    this.subTrailing,
    this.content,
    this.onTap,
    this.onTapComment,
    this.borderRadius,
    this.titleTag,
    this.contentLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            spacing: 5,
            children: [
              if (titleLeading != null) titleLeading!,
              Text(
                title ?? '',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              if (titleTag != null) titleTag!,
            ],
          ),
          if ((subTitle != null && subTitle!.isNotEmpty) || subTrailing != null)
            Row(
              spacing: 5,
              children: [
                Expanded(
                  child: Text(
                    subTitle ?? '',
                    style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
                  ),
                ),
                if (subTrailing != null) subTrailing!,
              ],
            ),
          Divider(color: Color(0xffF5F7F9), height: 5),
          GestureDetector(
            onTap: onTap,
            child: Text(
              content ?? '',
              style: TextStyle(fontSize: 12),
              maxLines: contentLines,
              overflow: contentLines == null
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: onTapComment,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF5F7F9),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  IconWidget(icon: 'icon_fire2.png', size: 16),
                  Expanded(
                    child: Text('火热讨论区', style: TextStyle(fontSize: 12)),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Color(0xff696969),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
