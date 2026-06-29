import 'package:freud/api/api.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';

class TaskCenterController extends GetxController {
  // 连续签到天数
  final continuousDay = 0.obs;

  // 今日是否签到
  final todayCheck = false.obs;

  final dailyTask = [].obs;
  final newUserTask = [].obs;

  @override
  void onInit() {
    super.onInit();
    getCheckRecord();
  }

  getCheckRecord() async {
    var records = await CheckApi().checkRecord();
    if (records != null && records.isNotEmpty) {
      var dateList = records.map((item) {
        return DateTime.parse(item['qdtime']);
      }).toList();

      DateTime dateA = DateTime(
        dateList[0].year,
        dateList[0].month,
        dateList[0].day,
      );
      DateTime dateNow = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      if ((dateNow.difference(dateA)).inDays == 0) {
        todayCheck.value = true;
      }
      continuousDay.value = getMaxContinuousDays(dateList);
      print(continuousDay.value);
    }
  }

  getTaskList() async {
    final taskList = await CheckApi().taskList();
    if (taskList != null) {
      dailyTask.value = taskList['item1'] as List<dynamic>;
      newUserTask.value = taskList['item2'] as List<dynamic>;
    }
  }

  // 计算最大连续天数
  int getMaxContinuousDays(List<DateTime> dateList) {
    if (dateList.isEmpty) return 0;

    // 去重 + 排序
    Set<String> dateSet = dateList
        .map((d) => '${d.year}-${d.month}-${d.day}')
        .toSet();
    List<DateTime> sorted = dateSet.map((s) {
      List parts = s.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }).toList()..sort();

    int max = 0;
    int current = 0;

    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i].difference(sorted[i - 1]).inDays == 1) {
        current++;
        if (current > max) max = current;
      } else {
        current = 0;
      }
    }

    if (max == 0 &&
        DateTime.now().difference(sorted[sorted.length - 1]).inDays == 0) {
      max = 1;
    }
    return max;
  }

  Future<void> onCheck() async {
    final result = await CheckApi().checkSubmit();
    if (result) {
      todayCheck.value = true;
      getCheckRecord();
      Get.find<UserService>().getUserInfo();
      ToastUtil.success('签到成功');
    }
  }
}
