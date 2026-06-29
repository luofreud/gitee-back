import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final bool? showTime;

  const DatePicker({
    super.key,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.showTime,
  });

  @override
  State<DatePicker> createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  List<int> years = [];
  List<int> months = [];
  List<int> days = [];
  DateTime _firstDate = DateTime.now();
  DateTime _lastDate = DateTime.now();
  DateTime _initialDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _firstDate = widget.firstDate ?? DateTime(1900, 1, 1);
    _lastDate = widget.lastDate ?? DateTime(2099, 12, 31);
    years = List.generate(
      _lastDate.year - _firstDate.year + 1,
      (index) => _firstDate.year + index,
    );
    months = List.generate(12, (index) => index + 1);
    _initialDate = widget.initialDate ?? DateTime.now();
    _handleDay();
  }

  _handleDay() {
    final dayNum = DateTime(_initialDate.year, _initialDate.month + 1, 0).day;
    final _days = List.generate(dayNum, (index) => index + 1);
    setState(() {
      days = _days;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: 15);
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      height: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部操作栏（取消+确定，iOS原生布局）
          Container(
            decoration: BoxDecoration(color: Color(0xffF7F7F7)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    elevation: 0,
                    overlayColor: Colors.transparent,
                  ),
                  onPressed: () {
                    // 取消选择，关闭弹窗
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '取消',
                    style: TextStyle(color: Color(0xff383838), fontSize: 16),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    elevation: 0,
                    overlayColor: Colors.transparent,
                  ),
                  onPressed: () {
                    // 确认选择，关闭弹窗并保存日期
                    Navigator.pop(context, _initialDate);
                  },
                  child: const Text(
                    '确定',
                    style: TextStyle(color: Color(0xff383838), fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 50,
                    selectionOverlay: Container(),
                    scrollController: FixedExtentScrollController(
                      initialItem: _initialDate.year - _firstDate.year,
                    ),
                    onSelectedItemChanged: (index) {
                      _initialDate = DateTime(
                        years[index],
                        _initialDate.month,
                        _initialDate.day,
                        _initialDate.hour,
                        _initialDate.minute,
                      );
                      _handleDay();
                    },
                    children: years.map((year) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Text('${year}年', style: textStyle),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 50,
                    selectionOverlay: Container(),
                    scrollController: FixedExtentScrollController(
                      initialItem: _initialDate.month - 1,
                    ),
                    onSelectedItemChanged: (index) {
                      _initialDate = DateTime(
                        _initialDate.year,
                        months[index],
                        _initialDate.day,
                        _initialDate.hour,
                        _initialDate.minute,
                      );
                      _handleDay();
                    },
                    children: months.map((month) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Text('${month}月', style: textStyle),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 50,
                    selectionOverlay: Container(),
                    scrollController: FixedExtentScrollController(
                      initialItem: _initialDate.day - 1,
                    ),
                    onSelectedItemChanged: (index) {
                      _initialDate = DateTime(
                        _initialDate.year,
                        _initialDate.month,
                        days[index],
                        _initialDate.hour,
                        _initialDate.minute,
                      );
                    },
                    children: days.map((day) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Text('${day}日', style: textStyle),
                      );
                    }).toList(),
                  ),
                ),
                if (widget.showTime == true)
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 50,
                      selectionOverlay: Container(),
                      scrollController: FixedExtentScrollController(
                        initialItem: _initialDate.hour,
                      ),
                      onSelectedItemChanged: (index) {
                        _initialDate = DateTime(
                          _initialDate.year,
                          _initialDate.month,
                          _initialDate.day,
                          index,
                          _initialDate.minute,
                        );
                      },
                      children: List.generate(24, (index) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: Text('${index}时', style: textStyle),
                        );
                      }).toList(),
                    ),
                  ),

                if (widget.showTime == true)
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 50,
                      selectionOverlay: Container(),
                      scrollController: FixedExtentScrollController(
                        initialItem: _initialDate.minute,
                      ),
                      onSelectedItemChanged: (index) {
                        _initialDate = DateTime(
                          _initialDate.year,
                          _initialDate.month,
                          _initialDate.day,
                          _initialDate.hour,
                          index,
                        );
                      },
                      children: List.generate(60, (index) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: Text('${index}分', style: textStyle),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
