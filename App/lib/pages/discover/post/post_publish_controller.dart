import 'package:flutter/material.dart';
import 'package:freud/api/api.dart';
import 'package:freud/models/article/article_plate.dart';
import 'package:freud/models/article/post.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/utils/sp_util.dart';
import 'package:freud/widgets/component/app_select_media.dart';
import 'package:get/get.dart';

class PostPublishController extends GetxController {
  late AppSelectMediaController selectMediaController;

  late TextEditingController titleController;
  late TextEditingController contentController;

  final _allowPublish = false.obs;

  bool get allowPublish => _allowPublish.value;

  List<String> imgs = [];

  ///话题
  final topicText = ''.obs;
  final Rx<int?> topicId = Rx<int?>(null);

  /// 板块列表
  RxList<ArticlePlate> topicList = <ArticlePlate>[].obs;
  RxList<ArticlePlate> plateList = <ArticlePlate>[].obs;

  /// 选中板块
  Rx<ArticlePlate?> selectedPlate = Rx<ArticlePlate?>(null);

  /// 匿名
  final anonymous = false.obs;

  bool isUploading = false;

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController();
    contentController = TextEditingController();
    titleController.addListener(_updatePublishable);
    contentController.addListener(_updatePublishable);
    selectMediaController = AppSelectMediaController();
    _loadPlates();
    var args = Get.arguments;
    if (args is Map) {
      topicText.value = args['topicTitle'] ?? '';
      topicId.value = args['topicId'];
    }
  }

  void _updatePublishable() {
    _allowPublish.value =
        titleController.text.isNotEmpty && contentController.text.isNotEmpty;
  }

  _loadPlates() async {
    var plates = await PostApi().getPlate(0);
    if (plates != null && plates.isNotEmpty) {
      plateList.assignAll(plates);
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    selectMediaController.dispose();
    super.onClose();
  }

  onUpload() async {
    if (isUploading) return;
    isUploading = true;
    CommonUtil.hideKeyShowUnfocus();
    selectMediaController.upload();
  }

  void fillDraft(Map<String, dynamic> draft) {
    titleController.text = draft['title'] ?? '';
    contentController.text = draft['content'] ?? '';
    imgs = List<String>.from(draft['imgs'] ?? []);
    topicText.value = draft['topic'] ?? '';
    anonymous.value = draft['anonymous'] ?? false;
    if (draft['plateid'] != null) {
      var plate = plateList.firstWhereOrNull((p) => p.id == draft['plateid']);
      if (plate != null) selectedPlate.value = plate;
    }
    _updatePublishable();
  }

  Future<void> saveDraft() async {
    if (titleController.text.isEmpty && contentController.text.isEmpty) return;
    var drafts = await SpUtil.getStorage('drafts') ?? [];
    if (drafts is! List) drafts = [];
    drafts.insert(0, {
      'title': titleController.text,
      'content': contentController.text,
      'imgs': imgs,
      'topic': topicText.value,
      'topicid': topicId.value,
      'plateid': selectedPlate.value?.id,
      'anonymous': anonymous.value,
      'createtime': DateTime.now().toIso8601String(),
    });
    await SpUtil.setStorage('drafts', drafts);
  }

  publish(context) async {
    if (!allowPublish) {
      return;
    }
    CommonUtil.hideKeyShowUnfocus();

    var result = await PostApi().postAdd(
      Post(
        title: titleController.text,
        content: contentController.text,
        imgs: imgs.join(','),
        videos: '',
        tags: topicText.value,
        topicid: topicId.value,
        atype: selectedPlate.value?.id,
        isanonymous: anonymous.value ? 1 : 0,
      ),
    );
    if (result) {
      await DialogUtil.showSuccess(context: context, title: '发布成功！');
      Get.back(closeOverlays: true, result: true);
    }
  }
}
