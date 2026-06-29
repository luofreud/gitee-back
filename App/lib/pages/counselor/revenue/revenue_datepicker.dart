import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freud/widgets/gradient_button.dart';

/// 日期选择器类型枚举
///
/// [month] 月份选择模式
/// [period] 时间段选择模式（开始日期 + 结束日期）
enum DatePickerType { month, period }

/// 收益页面专用的日期选择器组件
///
/// 支持两种选择模式：单月选择和时间段选择。
/// 提供自定义的日期范围限制、初始日期设置以及回调处理。
/// 采用 iOS 风格的滚轮选择器界面。
class RevenueDatePicker extends StatefulWidget {
  /// 可选的最小日期，默认为 1900 年 1 月 1 日
  final DateTime? firstDate;

  /// 可选的最大日期，默认为 2099 年 12 月 31 日
  final DateTime? lastDate;

  /// 初始选中的日期，默认为当前日期
  final DateTime? initialDate;

  /// 时间段的开始日期，默认为当前日期
  final DateTime? startDate;

  /// 时间段的结束日期，默认为当前日期
  final DateTime? endDate;

  /// 选择器类型，决定显示单月选择还是时间段选择
  final DatePickerType? type;

  /// 取消按钮点击回调函数
  final Function? onCancel;

  /// 确认按钮点击回调函数，返回选择的类型和日期列表
  final Function(DatePickerType, List<DateTime>)? onConfirm;

  const RevenueDatePicker({
    super.key,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.startDate,
    this.endDate,
    this.type,
    this.onCancel,
    this.onConfirm,
  });

  @override
  State<RevenueDatePicker> createState() => RevenueDatePickerState();
}

class RevenueDatePickerState extends State<RevenueDatePicker>
    with TickerProviderStateMixin {
  List<int> years = [];
  List<int> months = [];
  List<int> days = [];
  DateTime _firstDate = DateTime.now();
  DateTime _lastDate = DateTime.now();
  DateTime _initialDate = DateTime.now();

  DateTime _periodCurrentDate = DateTime.now();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  late TabController _tabController;
  int _tabIndex = 0;

  int _activeDate = 0; //激活日期选择 0开始日期 1结束日期

  late FixedExtentScrollController _yearScrollController;
  late FixedExtentScrollController _monthScrollController;
  late FixedExtentScrollController _dayScrollController;

  /// 初始化状态和数据
  ///
  /// 根据传入的配置参数初始化日期选择器的各项数据：
  /// - 设置 Tab 控制器和初始选中的 Tab 索引
  /// - 初始化年、月数据列表
  /// - 设置日期范围边界和初始日期
  /// - 初始化三个滚轮控制器的初始位置
  @override
  void initState() {
    super.initState();

    _tabIndex = widget.type == DatePickerType.period ? 1 : 0;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _tabIndex,
    );
    _firstDate = widget.firstDate ?? DateTime(1900, 1, 1);
    _lastDate = widget.lastDate ?? DateTime(2099, 12, 31);
    years = List.generate(
      _lastDate.year - _firstDate.year + 1,
      (index) => _firstDate.year + index,
    );
    months = List.generate(12, (index) => index + 1);
    _initialDate = widget.initialDate ?? DateTime.now();

    _startDate = widget.startDate ?? DateTime.now();
    _endDate = widget.endDate ?? DateTime.now();
    _periodCurrentDate = _startDate;

    _yearScrollController = FixedExtentScrollController(
      initialItem: _periodCurrentDate.year - _firstDate.year,
    );
    _monthScrollController = FixedExtentScrollController(
      initialItem: _periodCurrentDate.month - 1,
    );
    _dayScrollController = FixedExtentScrollController(
      initialItem: _periodCurrentDate.day - 1,
    );
    _handleDay();
  }

  /// 释放资源
  ///
  /// 销毁 Tab 控制器和三个滚轮控制器，避免内存泄漏
  @override
  void dispose() {
    _tabController.dispose();
    _yearScrollController.dispose();
    _monthScrollController.dispose();
    _dayScrollController.dispose();
    super.dispose();
  }

  /// 构建月份选择器
  ///
  /// 创建包含年和月两个滚轮的选择器，用于单月选择模式
  ///
  /// Returns: 月份选择器 Widget
  _buildMonthPicker() {
    return SizedBox(
      height: 240,
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
                );
              },
              children: years.map((year) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Text('${year}年'),
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
                );
              },
              children: months.map((month) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Text('${month}月'),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 处理当月天数
  ///
  /// 根据当前选中的年月计算该月的总天数，并更新天数列表
  /// 用于日选择滚轮的数据源
  _handleDay() {
    final dayNum = DateTime(_initialDate.year, _initialDate.month + 1, 0).day;
    final _days = List.generate(dayNum, (index) => index + 1);
    setState(() {
      days = _days;
    });
  }

  /// 切换时间段选择时的日期表单
  ///
  /// 当用户点击开始或结束日期区域时，切换当前编辑的日期并更新滚轮位置
  ///
  /// [index] 当前激活的日期索引，0 表示开始日期，1 表示结束日期
  onPeriodDateFormChange(int index) {
    _activeDate = index;
    if (index == 0) {
      _periodCurrentDate = _startDate;
    } else {
      _periodCurrentDate = _endDate;
    }
    // 跳转到对应日期的位置
    _yearScrollController.jumpToItem(_periodCurrentDate.year - _firstDate.year);
    _monthScrollController.jumpToItem(_periodCurrentDate.month - 1);
    _dayScrollController.jumpToItem(_periodCurrentDate.day - 1);
    setState(() {});
  }

  /// 构建日期时间段选择器
  ///
  /// 创建包含开始日期、结束日期显示和三个滚轮（年、月、日）的选择器
  /// 支持切换编辑开始或结束日期，并实时更新显示
  ///
  /// Returns: 时间段选择器 Widget
  _buildDatePeriodPicker() {
    // 格式化日期显示字符串
    final startDateStr =
        '${_startDate.year}年${_startDate.month}月${_startDate.day}日';
    final endDateStr = '${_endDate.year}年${_endDate.month}月${_endDate.day}日';
    // 构建顶部日期显示表单
    final formWidget = Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            spacing: 10,
            children: [
              Text('开始日期', style: TextStyle(color: Color(0xff636363))),
              GestureDetector(
                onTap: () {
                  onPeriodDateFormChange(0);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _activeDate == 0
                        ? Color(0xffF2F4FF)
                        : Color(0xffF7F7F7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    '$startDateStr',
                    style: TextStyle(
                      fontSize: 15,
                      color: _activeDate == 0
                          ? Color(0xff8097FF)
                          : Color(0xff383838),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.only(bottom: 10), child: Text('至')),
        Expanded(
          child: Column(
            spacing: 10,
            children: [
              Text('结束日期', style: TextStyle(color: Color(0xff636363))),
              GestureDetector(
                onTap: () {
                  onPeriodDateFormChange(1);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _activeDate == 1
                        ? Color(0xffF2F4FF)
                        : Color(0xffF7F7F7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    '$endDateStr',
                    style: TextStyle(
                      fontSize: 15,
                      color: _activeDate == 1
                          ? Color(0xff8097FF)
                          : Color(0xff383838),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    // 构建底部三个滚轮选择器
    final pickerWidget = SizedBox(
      height: 240,
      child: Row(
        children: [
          Expanded(
            child: CupertinoPicker(
              itemExtent: 50,
              selectionOverlay: Container(),
              scrollController: _yearScrollController,
              onSelectedItemChanged: (index) {
                if (_activeDate == 0) {
                  _startDate = DateTime(
                    years[index],
                    _startDate.month,
                    _startDate.day,
                  );
                } else {
                  _endDate = DateTime(
                    years[index],
                    _endDate.month,
                    _endDate.day,
                  );
                }
                setState(() {});
                _handleDay();
              },
              children: years.map((year) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Text('${year}年'),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 50,
              selectionOverlay: Container(),
              scrollController: _monthScrollController,
              onSelectedItemChanged: (index) {
                if (_activeDate == 0) {
                  _startDate = DateTime(
                    _startDate.year,
                    months[index],
                    _startDate.day,
                  );
                } else {
                  _endDate = DateTime(
                    _endDate.year,
                    months[index],
                    _endDate.day,
                  );
                }
                setState(() {});
                _handleDay();
              },
              children: months.map((month) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Text('${month}月'),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 50,
              selectionOverlay: Container(),
              scrollController: _dayScrollController,
              onSelectedItemChanged: (index) {
                if (_activeDate == 0) {
                  _startDate = DateTime(
                    _startDate.year,
                    _startDate.month,
                    days[index],
                  );
                } else {
                  _endDate = DateTime(
                    _endDate.year,
                    _endDate.month,
                    days[index],
                  );
                }
                setState(() {});
              },
              children: days.map((day) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Text('${day}日'),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
    return Column(
      children: [const SizedBox(height: 10), formWidget, pickerWidget],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部操作栏（取消+确定，iOS原生布局）
          Row(
            children: [
              TabBar(
                isScrollable: true,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                dividerHeight: 0,
                tabAlignment: TabAlignment.start,
                unselectedLabelColor: Color(0xff7986B0),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                labelColor: Colors.black,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Color(0Xff4D1FAE), width: 3),
                  borderRadius: BorderRadius.circular(4),
                  insets: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
                controller: _tabController,
                onTap: (index) {
                  setState(() {
                    _tabIndex = index;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // 跳转到第二页（索引从0开始，所以是1）
                    onPeriodDateFormChange(0);
                  });
                  // setState(() {
                  //   _activeDate = 0;
                  // });
                },
                tabs: [
                  Tab(text: '选择月份'),
                  Tab(text: '选择时间段'),
                ],
              ),
            ],
          ),
          if (_tabIndex == 0) _buildMonthPicker(),
          if (_tabIndex == 1) _buildDatePeriodPicker(),
          Container(
            width: (MediaQuery.of(context).size.width * 0.8).clamp(200, 300),
            padding: EdgeInsets.only(bottom: 30),
            child: Row(
              spacing: 15,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onCancel?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide.none,
                      backgroundColor: Color(0xffF7F7F7),
                      foregroundColor: Color(0xff383838),
                    ),
                    child: Text('取消'),
                  ),
                ),
                Expanded(
                  child: GradientButton(
                    onPressed: () {
                      // 确认选择，关闭弹窗并保存日期
                      widget.onConfirm?.call(
                        _tabIndex == 1
                            ? DatePickerType.period
                            : DatePickerType.month,
                        _tabIndex == 1
                            ? [_startDate, _endDate]
                            : [_initialDate],
                      );
                    },
                    isRadius: false,
                    height: 44,
                    radius: 10,
                    foregroundColor: Color(0xffFFC300),
                    child: Text('确定'),
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
