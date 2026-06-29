import 'package:freud/api/xingpan/xingpan_api.dart';
import 'package:get/get.dart';

class DiceDetailController extends GetxController {
  final loading = false.obs;
  final items = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    loading.value = true;
    try {
      final result = await XingpanApi().diceGenerate();
      if (result == null) return;
      final parse = (Map m, String type) {
        final id = m['id'] as int;
        final c = List<String>.from(m['content'] as List);
        return <String, dynamic>{
          'type': type,
          'id': id,
          'title': c[0],
          'desc': c.sublist(1),
        };
      };
      items.value = [
        parse(result['planet'], 'planet'),
        parse(result['house'], 'house'),
        parse(result['constellation'], 'constellation'),
      ];
    } finally {
      loading.value = false;
    }
  }
}
