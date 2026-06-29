import 'package:flutter/material.dart';
import 'package:freud/pages/counselor/report/widgets/chart_line.dart';
import 'package:get/get.dart';

import 'counselor_report_controller.dart';

class CounselorReportPage extends GetView<CounselorReportController> {
  const CounselorReportPage({super.key});

  _buildCard({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 10,
        children: [
          Row(
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
              Spacer(),
              _DateSelectWidget(
                onChanged: (value) {
                  print(value);
                },
              ),
            ],
          ),
          ...children,
        ],
      ),
    );
  }

  _buildTrafficCard() {
    return _buildCard(
      title: '流量数据',
      children: [
        Obx(() {
          return Row(
            spacing: 10,
            children: controller.trafficItems.asMap().entries.map((entrie) {
              final item = entrie.value;
              final isSelected = controller.trafficIndex.value == entrie.key;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.traficChange(entrie.key);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xffF7F7FF)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          spacing: 5,
                          children: [
                            Text(
                              '${item['title']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff4F4F4F),
                              ),
                            ),
                            Text(
                              '${item['value']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${double.parse(item['compare'].toString()) > 0 ? '+' : ''}${item['compare']}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color:
                                    double.parse(item['compare'].toString()) > 0
                                    ? Color(0xffF55656)
                                    : Color(0xff43CF7C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 0,
                          child: Container(
                            height: 3,
                            width: 24,
                            decoration: BoxDecoration(
                              color: Color(0xff6969FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }),
        const SizedBox(height: 10),
        SizedBox(height: 200, child: ChartLineWidget()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CounselorReportController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('数据中心'),
        backgroundColor: Colors.white,
        shape: const Border(
          bottom: BorderSide(color: Color(0xffF5F7F9), width: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            _buildTrafficCard(),
            _buildTrafficCard(),
            _buildTrafficCard(),
          ],
        ),
      ),
    );
  }
}

class _DateSelectWidget extends StatefulWidget {
  final int? initialValue;
  final ValueChanged<int>? onChanged;

  const _DateSelectWidget({super.key, this.initialValue, this.onChanged});

  @override
  State<_DateSelectWidget> createState() => _DateSelectWidgetState();
}

class _DateSelectWidgetState extends State<_DateSelectWidget> {
  bool _isOpen = false;
  int _index = 1;
  final List<int> _values = [1, 7, 30, 90, 0];
  final List<String> _labels = ['昨日', '近7天', '近30天', '近90天', '累计'];

  @override
  void initState() {
    super.initState();
    _index = _values.indexOf(widget.initialValue ?? 7);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      offset: const Offset(0, 30),
      color: Colors.white,
      shadowColor: Colors.black.withAlpha(50),
      initialValue: 7,
      borderRadius: BorderRadius.circular(10),
      onSelected: (index) {
        // 处理选择
        setState(() {
          _isOpen = false;
          _index = index;
        });
        widget.onChanged?.call(_values[index]);
      },
      onOpened: () {
        setState(() {
          _isOpen = true;
        });
      },
      onCanceled: () {
        setState(() {
          _isOpen = false;
        });
      },
      itemBuilder: (context) =>
          List.generate(_values.length, (index) => index).map((item) {
            return PopupMenuItem(value: item, child: Text('${_labels[item]}'));
          }).toList(),
      child: Row(
        children: [
          Text(_labels[_index]),
          Icon(
            _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Color(0xff4A4A4A),
          ),
        ],
      ),
    );
  }
}
