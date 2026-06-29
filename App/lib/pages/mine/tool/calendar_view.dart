import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/models/tool/astrocalendar.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:get/get.dart';

import 'calendar_controller.dart';

class CalendarPage extends GetView<CalendarController> {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CalendarController());
    return Scaffold(
      appBar: AppBar(title: const Text('星象日历'), backgroundColor: Colors.white),
      body: NotificationListener(
        onNotification: (notification) {
          // 监听滚动结束事件，用于判断是否需要折叠或展开日历
          if (notification is ScrollEndNotification) {
            controller.scrollToTopOrBottom();
          }
          if (controller.maxScrollExtent !=
                  controller.scrollController.position.maxScrollExtent &&
              controller.calendarCollapse.value) {
            controller.maxScrollExtent =
                controller.scrollController.position.maxScrollExtent;
            controller.scrollController.jumpTo(
              controller.scrollController.position.maxScrollExtent,
            );
          }
          return false;
        },
        child: NestedScrollView(
          controller: controller.scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: Obx(
                  () => _AstrologicalCalendar(
                    dateTime: controller.selectDate.value,
                    monthSummary: controller.monthSummary.value,
                    onChange: (dateTime) {
                      final currentDateTime = controller.selectDate.value;
                      if (currentDateTime.year != dateTime.year ||
                          currentDateTime.month != dateTime.month) {
                        controller.selectDate.value = dateTime;
                        controller.fetchMonthSummary();
                      }
                      controller.selectDate.value = dateTime;
                      controller.fetchCalendar();
                    },
                  ),
                ),
              ),
            ];
          },
          body: Builder(
            builder: (context) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConst.PAGE_PADDING,
                        vertical: 12,
                      ),
                      child: Obx(() {
                        return Text(
                          '${controller.selectDate.value.year}年${controller.selectDate.value.month}月${controller.selectDate.value.day}日 丨 今日星象',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }),
                    ),
                  ),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (controller.calendarData.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          alignment: Alignment.center,
                          child: Text(
                            '暂无星象',
                            style: TextStyle(
                              color: Color(0xffA6A6A6),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverList.separated(
                      itemCount: controller.calendarData.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(height: 10),
                      itemBuilder: (BuildContext context, int index) {
                        return _CalendarItem(
                          event: controller.calendarData[index],
                        );
                      },
                    );
                  }),
                  SliverToBoxAdapter(child: SizedBox(height: 15)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// 星象日历
class _AstrologicalCalendar extends StatefulWidget {
  final DateTime? dateTime;
  final Map<int, XzAstrocalendar>? monthSummary;
  final Function(DateTime)? onChange;
  final Function(DateTime)? onDayChange;
  final Function(DateTime)? onMonthChange;

  const _AstrologicalCalendar({
    super.key,
    this.dateTime,
    this.monthSummary,
    this.onChange,
    this.onDayChange,
    this.onMonthChange,
  });

  @override
  State<_AstrologicalCalendar> createState() => _AstrologicalCalendarState();
}

class _AstrologicalCalendarState extends State<_AstrologicalCalendar> {
  DateTime dateTime = DateTime.now();
  Map<int, XzAstrocalendar>? monthSummary;

  @override
  void initState() {
    super.initState();
    dateTime = widget.dateTime ?? DateTime.now();
    monthSummary = widget.monthSummary;
  }

  @override
  void didUpdateWidget(covariant _AstrologicalCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    monthSummary = widget.monthSummary;
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _CustomCalendarDelegate(
        dateTime: dateTime,
        selectedDay: dateTime.day,
        monthSummary: monthSummary,
        onTap: (day) {
          if (day != null) {
            setState(() {
              dateTime = DateTime(dateTime.year, dateTime.month, day);
            });
            widget.onDayChange?.call(dateTime);
            widget.onChange?.call(dateTime);
          }
        },
        onPrevMonth: () {
          setState(() {
            dateTime = DateTime(dateTime.year, dateTime.month - 1, 1);
          });
          widget.onMonthChange?.call(dateTime);
          widget.onChange?.call(dateTime);
        },
        onNextMonth: () {
          setState(() {
            dateTime = DateTime(dateTime.year, dateTime.month + 1, 1);
          });
          widget.onMonthChange?.call(dateTime);
          widget.onChange?.call(dateTime);
        },
        onDateTap: () async {
          var result = await DialogUtil.showDatePicker(
            context: context,
            initialDate: dateTime,
          );
          if (result is DateTime) {
            setState(() {
              dateTime = result;
            });
            widget.onChange?.call(dateTime);
          }
        },
      ),
      pinned: true,
    );
  }
}

/// 自定义委托实现日历顶部功能
/// 实现方式是使用stack布局，将日历使用Positioned定位到bottom=0，这样当顶部折叠的时候日历会自动呈现往上移动的效果
/// 然后使用ClipPath裁剪功能将溢出顶部区域的日历进行裁剪避免溢出提示错误，这样就呈现出了一种日历上滑折叠的效果，
/// 同时将选择天所在的行使用Positioned定位到top=0的位置，当上滑到选择所在行时显示这个吸顶的行，这样就呈现出了一种吸顶效果
class _CustomCalendarDelegate extends SliverPersistentHeaderDelegate {
  final DateTime dateTime;
  final int? selectedDay;
  final Map<int, XzAstrocalendar>? monthSummary;
  final Function(int? day)? onTap;
  final GestureTapCallback? onPrevMonth;
  final GestureTapCallback? onNextMonth;
  final GestureTapCallback? onDateTap;

  _CustomCalendarDelegate({
    required this.dateTime,
    this.selectedDay,
    this.monthSummary,
    this.onTap,
    this.onPrevMonth,
    this.onNextMonth,
    this.onDateTap,
  });

  ///顶部header高度
  static const double _headerHeight = 60.0;

  /// 星期布局高度
  static const double _weekHeight = 38.0;

  /// 每一行日期的高度
  static const double _dayColHeight = 50.0;

  static const double _footerHeight = 20.0;

  _buildHeader() {
    return Container(
      height: _headerHeight,
      decoration: BoxDecoration(color: Color(0xffF2F5FF)),
      padding: EdgeInsets.symmetric(horizontal: AppConst.PAGE_PADDING),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPrevMonth,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, size: 12),
                Text('上个月', style: TextStyle(height: 1)),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: onDateTap,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${dateTime.year}年${dateTime.month}月',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(-5, 0),
                      child: Icon(Icons.arrow_drop_down, size: 24),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onNextMonth,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Text('下个月', style: TextStyle(height: 1)),
                Transform.translate(
                  offset: Offset(3, 0),
                  child: Icon(Icons.arrow_forward_ios, size: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildWeek() {
    return Container(
      height: _weekHeight,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(child: Center(child: Text('一'))),
          Expanded(child: Center(child: Text('二'))),
          Expanded(child: Center(child: Text('三'))),
          Expanded(child: Center(child: Text('四'))),
          Expanded(child: Center(child: Text('五'))),
          Expanded(child: Center(child: Text('六'))),
          Expanded(child: Center(child: Text('日'))),
        ],
      ),
    );
  }

  int pinnedColIndex = 0;

  List<List<int?>> _monthDays(DateTime dateTime) {
    // 获取当月第一天
    final firstDay = DateTime(dateTime.year, dateTime.month, 1);
    // 当月总天数
    final totalDay = DateTime(dateTime.year, dateTime.month + 1, 0).day;
    //第一天从周几开始
    final int startIndex = firstDay.weekday - 1;
    final totalRows = ((startIndex + totalDay) / 7).ceil();
    // print(startIndex);
    // print(totalRows);
    //每一行创建一个list并填充7个null
    final List<List<int?>> result = List.generate(
      totalRows,
      (_) => List.filled(7, null),
    );
    for (int i = 0; i < totalDay; i++) {
      final cellIndex = i + startIndex;
      final rowIndex = cellIndex ~/ 7;
      final colIndex = cellIndex % 7;
      result[rowIndex][colIndex] = i + 1;
      if (i + 1 == selectedDay) {
        pinnedColIndex = rowIndex;
      }
    }
    return result;
  }

  Widget _buildColDays(List<int?> days, {double cellWidth = 40.0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        if (day == null) {
          return Container(
            width: cellWidth,
            height: _dayColHeight,
            color: Colors.white,
          );
        }
        final dayTextStyle = TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          height: 1,
        );
        // 默认
        final summary = monthSummary?[day];
        Widget dayWidget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$day', style: dayTextStyle),
            const SizedBox(height: 1),
            Text(
              summary?.titleShort ?? '',
              style: TextStyle(fontSize: 10, color: Color(0xff808080)),
            ),
            const SizedBox(height: 4),
            CircleAvatar(
              backgroundColor: summary == null
                  ? Colors.transparent
                  : Color(0xff2A82E4),
              radius: 2,
            ),
          ],
        );

        //今日
        if (day == DateTime.now().day &&
            DateTime.now().month == dateTime.month &&
            DateTime.now().year == dateTime.year) {
          dayWidget = Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                colors: [Color(0xff4C1FAD), Color(0xff0A2063)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: EdgeInsets.all(1),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: dayWidget,
            ),
          );
        }
        // 选中的日期
        if (day == selectedDay) {
          dayWidget = Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                colors: [Color(0xff4C1FAD), Color(0xff0A2063)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$day', style: dayTextStyle.copyWith(color: Colors.white)),
                const SizedBox(height: 1),
                Text(
                  summary?.titleShort ?? '',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
                const SizedBox(height: 4),
                CircleAvatar(
                  backgroundColor: summary == null
                      ? Colors.transparent
                      : Colors.white,
                  radius: 2,
                ),
              ],
            ),
          );
        }
        return GestureDetector(
          onTap: () {
            onTap?.call(day);
          },
          child: Container(
            width: cellWidth,
            height: _dayColHeight,
            decoration: BoxDecoration(color: Colors.white),
            child: dayWidget,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final currentHeight = maxExtent - shrinkOffset;
    final rows = _monthDays(this.dateTime);
    final cellWidth = MediaQuery.of(context).size.width / 7;
    bool isCollapse = shrinkOffset == maxExtent - minExtent;
    return SizedBox(
      height: currentHeight,
      child: ClipPath(
        child: Column(
          children: [
            _buildHeader(),
            _buildWeek(),
            Expanded(
              child: ClipPath(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          // final cellWidth = width / 7;
                          return Column(
                            children: rows
                                .map(
                                  (days) =>
                                      _buildColDays(days, cellWidth: cellWidth),
                                )
                                .toList(),
                          );
                        },
                      ),
                    ),
                    if (shrinkOffset > pinnedColIndex * _dayColHeight)
                      Positioned(
                        left: 0,
                        top: 0,
                        right: 0,
                        child: Column(
                          children: [
                            _buildColDays(
                              rows[pinnedColIndex],
                              cellWidth: cellWidth,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              height: 20,
              width: double.infinity,
              color: Colors.white,
              child: isCollapse
                  ? GestureDetector(
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xff696969),
                        size: 16,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent {
    final rowsNum = _monthDays(this.dateTime).length;
    return _headerHeight +
        _weekHeight +
        _dayColHeight * rowsNum +
        _footerHeight;
  }

  @override
  double get minExtent =>
      _headerHeight + _weekHeight + _dayColHeight + _footerHeight;

  @override
  bool shouldRebuild(covariant _CustomCalendarDelegate oldDelegate) {
    return oldDelegate.dateTime != dateTime ||
        oldDelegate.selectedDay != selectedDay ||
        oldDelegate.monthSummary != monthSummary;
  }
}

class _CalendarItem extends StatelessWidget {
  final XzAstrocalendar event;

  const _CalendarItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConst.PAGE_PADDING),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          if (event.time != null)
            Text(event.time!, style: TextStyle(color: Color(0xffA6A6A6))),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              if (event.title != null) Flexible(child: Text(event.title!)),
              if (event.titleShort != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: Color(0xff6679D9)),
                  ),
                  child: Text(
                    event.titleShort!,
                    style: TextStyle(color: Color(0xff6679D9), fontSize: 12),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
