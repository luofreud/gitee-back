import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/widgets/component/circle_checkbox.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

import '../../../widgets/empty_tips.dart';
import 'archive_select_controller.dart';

class ArchiveSelectPage extends GetView<ArchiveSelectController> {
  const ArchiveSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ArchiveSelectController());
    return GestureDetector(
      onTap: () => CommonUtil.hideKeyShowUnfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('选择档案'),
          backgroundColor: Colors.white,
          actions: [
            GestureDetector(
              onTap: () async {
                CommonUtil.hideKeyShowUnfocus();
                final result = await Get.toNamed(AppRoutes.TOOL_ARCHIVEADD);
                if (result == true) {
                  controller.listRefresh();
                }
              },
              child: const Text('添加档案'),
            ),
            const SizedBox(width: AppConst.PAGE_PADDING),
          ],
        ),
        body: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(AppConst.PAGE_PADDING),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: SearchBar(
                  hintText: '搜索档案',
                  hintStyle: WidgetStateProperty.all(
                    const TextStyle(fontSize: 14),
                  ),
                  leading: const Icon(
                    Icons.search,
                    color: Color(0xffC4C4C4),
                    size: 16,
                  ),
                  backgroundColor: WidgetStateProperty.all(
                    const Color(0xffF5F7F9),
                  ),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  scrollPadding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    maxHeight: 32,
                    minHeight: 32,
                  ),
                  elevation: WidgetStateProperty.all(0),
                  onSubmitted: (value) => controller.onSearchSubmitted(value),
                ),
              ),
              Expanded(
                child: RefreshLoadmore(
                  controller: controller.refreshController,
                  onRefresh: () async => controller.listRefresh(),
                  onLoad: () async => controller.loadMore(),
                  child: Obx(() {
                    if (controller.listData.isEmpty) {
                      return Center(
                        child: controller.isLoading.value
                            ? CircularProgressIndicator()
                            : EmptyTips(title: '暂无记录'),
                      );
                    }
                    return ListView.builder(
                      itemCount: controller.listData.length,
                      itemBuilder: (context, index) {
                        final archive = controller.listData[index];
                        return Obx(() {
                          final isSelected = controller.selectedIds.contains(archive.id);
                          return Material(
                            color: Colors.transparent,
                            child: ListTile(
                              leading: CircleCheckbox(
                                value: isSelected,
                                onChanged: (_) => controller.toggleSelection(archive),
                              ),
                              onTap: () => controller.toggleSelection(archive),
                              title: Row(
                                children: [
                                  Text(
                                    archive.name ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  _buildConstellationIcon(archive),
                                ],
                              ),
                              subtitle: Text(
                                archive.birthday ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitleTextStyle: const TextStyle(
                                fontSize: 12,
                                color: Color(0xffA6A6A6),
                              ),
                              trailing:
                                  archive.relation != null &&
                                      archive.relation!.isNotEmpty
                                  ? Text(
                                      '(${archive.relation})',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffA6A6A6),
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        });
                      },
                    );
                  }),
                ),
              ),
              if (controller.isMultiSelect)
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Obx(() => GradientButton(
                    onPressed: controller.selectedIds.length >= (controller.requiredCount ?? 1)
                        ? () => controller.confirmSelection()
                        : null,
                    height: 44,
                    width: double.infinity,
                    isRadius: false,
                    foregroundColor: const Color(0xffFFD0A1),
                    child: const Text('确定选择'),
                  )),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConstellationIcon(Archive archive) {
    if (archive.birthday == null || archive.birthday!.isEmpty) {
      return const SizedBox.shrink();
    }
    try {
      final birthday = DateTime.parse(archive.birthday!);
      final constellation = CommonUtil.getConstellationName(birthday);
      final icons = {
        '白羊座': 'constellation/icon_tag_by.png',
        '金牛座': 'constellation/icon_tag_jn.png',
        '双子座': 'constellation/icon_tag_sz.png',
        '巨蟹座': 'constellation/icon_tag_jx.png',
        '狮子座': 'constellation/icon_tag_shizi.png',
        '处女座': 'constellation/icon_tag_cn.png',
        '天秤座': 'constellation/icon_tag_tc.png',
        '天蝎座': 'constellation/icon_tag_tx.png',
        '射手座': 'constellation/icon_tag_ss.png',
        '摩羯座': 'constellation/icon_tag_mj.png',
        '水瓶座': 'constellation/icon_tag_sp.png',
        '双鱼座': 'constellation/icon_tag_sy.png',
      };
      if (icons.containsKey(constellation)) {
        return IconWidget(icon: icons[constellation]!, width: 58, height: 16);
      }
    } catch (_) {}
    return const SizedBox.shrink();
  }
}
