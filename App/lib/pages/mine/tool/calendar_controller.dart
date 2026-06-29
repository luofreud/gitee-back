import 'package:flutter/material.dart';
import 'package:freud/models/tool/astrocalendar.dart';
import 'package:get/get.dart';

import '../../../api/xingpan/xingpan_api.dart';

class CalendarController extends GetxController {
  late ScrollController scrollController;
  final selectDate = DateTime.now().obs;
  final calendarCollapse = false.obs;
  double maxScrollExtent = 0.0;
  final calendarData = <XzAstrocalendar>[].obs;
  final isLoading = false.obs;
  final monthSummary = <int, XzAstrocalendar>{}.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    fetchMonthSummary();
  }

  @override
  void onReady() {
    super.onReady();
    fetchCalendar();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  fetchCalendar() async {
    isLoading.value = true;
    calendarData.clear();

    final year = selectDate.value.year;
    final month = selectDate.value.month;

    var result = await XingpanApi().getCalendarByDay(
      year: year,
      month: month,
      day: selectDate.value.day,
    );
    if (result != null) calendarData.value = result;
    isLoading.value = false;
  }

  fetchMonthSummary() async {
    final year = selectDate.value.year;
    final month = selectDate.value.month;
    var result = await XingpanApi().getCalendarByMonth(
      year: year,
      month: month,
    );
    if (result != null) monthSummary.value = result;
  }

  void scrollToTopOrBottom() {
    if (scrollController.offset == 0 ||
        scrollController.offset == scrollController.position.maxScrollExtent) {
      calendarCollapse.value =
          scrollController.offset == scrollController.position.maxScrollExtent;
      return;
    }
    if ((scrollController.offset <
                (scrollController.position.maxScrollExtent - 50) &&
            calendarCollapse.value == false) ||
        scrollController.offset < 50) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      calendarCollapse.value = true;
    } else if ((scrollController.offset > 50 &&
            calendarCollapse.value == true) ||
        scrollController.offset >
            (scrollController.position.maxScrollExtent - 50)) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      calendarCollapse.value = false;
    }
  }
}
