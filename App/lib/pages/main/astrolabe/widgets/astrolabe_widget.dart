import 'package:flutter/material.dart';
import 'package:freud/pages/main/astrolabe/astrolabe_analysis_controller.dart';
import 'package:freud/pages/main/astrolabe/widgets/xingpan_svg.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:get/get.dart';

class AstrolabeWidget extends StatefulWidget {
  const AstrolabeWidget({super.key});

  @override
  State<AstrolabeWidget> createState() => _AstrolabeWidgetState();
}

class _AstrolabeWidgetState extends State<AstrolabeWidget> {
  late XingpanSvgController _svgCtrl;

  @override
  void initState() {
    super.initState();
    _svgCtrl = XingpanSvgController(mode: 'cn');
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buildButton({String? title, Widget? icon, VoidCallback? onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(0, 0),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xff878787),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        side: BorderSide.none,
      ),
      child: Row(
        spacing: 2,
        children: [if (icon != null) icon, Text('$title')],
      ),
    );
  }

  _buildStyleButton(context) {
    return _buildButton(
      title: '换肤',
      icon: IconWidget(icon: 'icon_skin.png', size: 16),
      onPressed: () {
        String tempStyle = _svgCtrl.mode;
        DialogUtil.showConfirmDialog(
          context: context,
          cancelShow: false,
          child: _DialogStyleContainer(
            style: tempStyle,
            onChange: (style) {
              tempStyle = style;
            },
          ),
          onConfirm: (context) {
            _svgCtrl.setMode(tempStyle);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AstrolabeAnalysisController>();
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Obx(() {
            final index = controller.currentChartType.value;
            var chartData = controller.chartData[index]?.value;
            return XingpanSvg(
              controller: _svgCtrl,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              svgString: chartData?["svg"] ?? "",
            );
          }),
        ),
        Positioned(left: 0, top: 0, child: _buildStyleButton(context)),
        Positioned(
          right: 0,
          top: 0,
          child: _buildButton(
            title: '参数',
            icon: IconWidget(icon: 'icon_list.png', size: 16),
            onPressed: () => Get.toNamed(AppRoutes.ASTROLABE_PARAMETER),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: _buildButton(
            title: '现代',
            icon: IconWidget(icon: 'icon_change2.png', size: 16),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: _buildButton(
            title: '设置',
            icon: IconWidget(icon: 'icon_setting2.png', size: 16),
            onPressed: () {
              Get.toNamed(AppRoutes.ASTROLABE_SETTING);
            },
          ),
        ),
      ],
    );
  }
}

class _DialogStyleContainer extends StatefulWidget {
  final String? style;
  final void Function(String style)? onChange;

  const _DialogStyleContainer({super.key, this.style, this.onChange});

  @override
  State<_DialogStyleContainer> createState() => _DialogStyleContainerState();
}

class _DialogStyleContainerState extends State<_DialogStyleContainer> {
  String style = 'cn';
  static const styleList = [
    {'name': '文字', 'value': 'cn'},
    {'name': '符号', 'value': 'en'},
  ];

  @override
  void initState() {
    super.initState();
    style = widget.style ?? 'cn';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text('样式'),
          Wrap(
            spacing: 10,
            children: styleList.map((e) {
              final value = e["value"]!;
              final isSelected = style == value;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    style = e["value"]!;
                  });
                  widget.onChange?.call(style);
                },
                child: Container(
                  height: 32,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? null
                        : Border.all(color: Color(0xff383838), width: 1),
                    color: isSelected ? null : Colors.white,
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [Color(0xff9255D9), Color(0xff325EE3)],
                          )
                        : null,
                  ),
                  child: Text(
                    e["name"]!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xff383838),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
