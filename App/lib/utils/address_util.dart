import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freud/utils/sqlite_util.dart';
import 'package:get/get.dart';

enum DataType { city, town }

class AddressUtil {
  static Future<List<String?>?> showDialog({
    required BuildContext context,
    String? title,
    int? maxLevel,
    List<String>? initData,
    DataType? dataType,
    Function? onSelected,
  }) {
    return showModalBottomSheet<List<String?>?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _AddressContainer(
          title: title,
          maxLevel: maxLevel,
          initData: initData,
          dataType: dataType,
          onSelected: onSelected,
        );
      },
    );
  }
}

class _AddressContainer extends StatefulWidget {
  final String? title;
  final int? maxLevel;
  final List<String>? initData;
  final DataType? dataType;
  final Function? onSelected;

  const _AddressContainer({
    super.key,
    this.title,
    this.maxLevel,
    this.initData,
    this.dataType,
    this.onSelected,
  });

  @override
  State<_AddressContainer> createState() => _AddressContainerState();
}

class _AddressContainerState extends State<_AddressContainer>
    with TickerProviderStateMixin {
  int maxLevel = 4;
  late TabController _tabController;
  late ScrollController _scrollController;

  //数据类型
  DataType dataType = DataType.city;

  // 当前层级
  int currentLavel = 1;

  // city 数据变量
  List<_CityItem> cityData = [];
  List<_CityItem> currentCityData = [];
  List<_CityItem?> selectCityData = [];

  /// 乡镇数据变量
  // 当前数据
  List<_AddressListItem> currentTownData = [];

  // 当前数据的拼音前缀
  List<String> currentPrefixList = [];

  // 已选数据
  List<_AddressEntity?> selectTownData = [];

  @override
  void initState() {
    dataType = widget.dataType ?? DataType.city;
    int max = dataType == DataType.city ? 3 : 4;
    maxLevel = widget.maxLevel?.clamp(2, max) ?? max;
    _tabController = TabController(length: 1, vsync: this);
    _scrollController = ScrollController();

    if (dataType == DataType.city) {
      selectCityData = List.generate(maxLevel, (index) => null);
      loadJsonFromAssets().then((data) {
        cityData = data;
        currentCityData = cityData;

        if (widget.initData != null &&
            widget.initData!.isNotEmpty &&
            (widget.initData!.where((p) => p.isNotEmpty)).isNotEmpty) {
          handleCityInitData(widget.initData!, 0);
        } else {
          setState(() {});
        }
      });
    } else {
      selectTownData = List.generate(maxLevel, (index) => null);
      getDbData(0).then((data) {
        currentTownData = data;
        if (widget.initData != null &&
            widget.initData!.isNotEmpty &&
            (widget.initData!.where((p) => p.isNotEmpty)).isNotEmpty) {
          handleTownInitData(widget.initData!, 0);
        } else {
          setState(() {});
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  ///=============city数据====================
  // 处理city初始化数据
  void handleCityInitData(List<String> data, int index) async {
    var findItem = currentCityData.firstWhereOrNull(
      (item) => item.name == data[index],
    );
    if (findItem != null) {
      await onSelectCityData(findItem, isBack: false);
      if (index < data.length - 1) {
        handleCityInitData(data, index + 1);
      }
    }
  }

  // 加载city的json数据
  Future<List<_CityItem>> loadJsonFromAssets() async {
    String jsonString = await rootBundle.loadString('assets/other/city.json');
    var jsonObj = jsonDecode(jsonString);
    return jsonObj.map<_CityItem>((item) => _CityItem.fromJson(item)).toList();
  }

  // 选择城市数据
  Future<void> onSelectCityData(
    _CityItem cityitem, {
    bool isBack = true,
  }) async {
    selectCityData[currentLavel - 1] = cityitem;
    selectCityData.fillRange(currentLavel, selectCityData.length, null);
    if (currentLavel < maxLevel) {
      //获取后面未选择的开始index，构建tab数量
      int lastIndex = selectCityData.indexWhere((item) => item == null);
      if (lastIndex >= 0) {
        _tabController.dispose();
        _tabController = TabController(
          length: lastIndex + 1,
          vsync: this,
          initialIndex: lastIndex,
        );
      }
      currentCityData = cityitem.sub ?? [];
      _scrollController.jumpTo(0);
      currentLavel++;
      setState(() {});
    } else {
      if (isBack) {
        widget.onSelected?.call(selectCityData);
        Navigator.of(
          context,
        ).pop(selectCityData.map((item) => item?.name ?? '').toList());
      }
    }
  }

  // 编译city数据item
  _buildCityItem(_CityItem item) {
    var selectedItem = selectCityData[currentLavel - 1];
    final selected = selectedItem != null && selectedItem.id == item.id;
    return ListTile(
      leading: selected
          ? Icon(Icons.check, size: 16, color: Colors.blue)
          : null,
      minLeadingWidth: 0,
      title: Transform.translate(
        offset: Offset(selected ? -10 : 0, 0),
        child: Text(
          item.name ?? '',
          style: TextStyle(color: selected ? Colors.blue : null),
        ),
      ),
      onTap: () {
        onSelectCityData(item);
      },
    );
  }

  ///=============town数据====================
  // 处理town初始化数据
  void handleTownInitData(List<String> data, int index) async {
    var findItem = currentTownData.firstWhereOrNull(
      (item) =>
          item.type == ListItemType.data && item.data?.name == data[index],
    );
    if (findItem != null) {
      await onSelectTownData(findItem.data!, isBack: false);
      if (index < data.length - 1) {
        handleTownInitData(data, index + 1);
      }
    }
  }

  // 加载数据库的乡镇数据
  Future<List<_AddressListItem>> getDbData(int id) async {
    var db = await SqliteUtil.instance.database;
    var data = await db.query(
      'regions',
      where: "parent_id = ?",
      whereArgs: [id],
      orderBy: 'pinyin_prefix ASC',
    );
    List<_AddressListItem> dataList = [];
    List<String> prefixList = [];
    for (var item in data) {
      final addressItem = _AddressEntity.fromJson(item);
      var lastItem = dataList.isNotEmpty ? dataList.last : null;
      if (lastItem != null && lastItem.type == ListItemType.data) {
        if (lastItem.data!.pinyinPrefix != addressItem.pinyinPrefix) {
          dataList.add(
            _AddressListItem(
              type: ListItemType.label,
              data: _AddressEntity(name: addressItem.pinyinPrefix),
            ),
          );
        }
      } else {
        dataList.add(
          _AddressListItem(
            type: ListItemType.label,
            data: _AddressEntity(name: addressItem.pinyinPrefix),
          ),
        );
      }
      dataList.add(
        _AddressListItem(type: ListItemType.data, data: addressItem),
      );

      //取出所有拼音前缀
      if (!prefixList.contains(addressItem.pinyinPrefix)) {
        prefixList.add(addressItem.pinyinPrefix ?? '#');
      }
    }
    currentPrefixList = prefixList;
    return dataList;
  }

  // 选择乡镇数据
  Future<void> onSelectTownData(
    _AddressEntity address, {
    bool isBack = true,
  }) async {
    selectTownData[currentLavel - 1] = address;
    selectTownData.fillRange(currentLavel, selectTownData.length, null);
    if (currentLavel < maxLevel) {
      //获取后面未选择的开始index，构建tab数量
      int lastIndex = selectTownData.indexWhere((item) => item == null);
      if (lastIndex >= 0) {
        _tabController.dispose();
        _tabController = TabController(
          length: lastIndex + 1,
          vsync: this,
          initialIndex: lastIndex,
        );
      }
      currentTownData = await getDbData(address.id!);
      _scrollController.jumpTo(0);
      currentLavel++;
      setState(() {});
    } else {
      if (isBack) {
        widget.onSelected?.call(selectTownData);
        Navigator.of(
          context,
        ).pop(selectTownData.map((item) => item?.name ?? '').toList());
      }
    }
  }

  // 编译tab
  Widget _buildTabBar() {
    dynamic selectData;
    if (dataType == DataType.city) {
      selectData = selectCityData;
    } else {
      selectData = selectTownData;
    }
    int lastIndex = selectData.indexWhere((item) => item == null);
    int tabCount = lastIndex >= 0 ? (lastIndex + 1) : selectData.length;
    return TabBar(
      tabs: List.generate(tabCount, (index) {
        String label = '请选择';
        if (index < selectData.length) {
          label = selectData[index]?.name ?? '请选择';
        }
        return Tab(child: Text(label));
      }).toList(),
      onTap: (index) async {
        currentLavel = index + 1;
        var data = index > 0 ? selectData[index - 1] : null;
        if (dataType == DataType.city) {
          currentCityData = data?.sub ?? cityData;
        } else {
          currentTownData = await getDbData(data?.id ?? 0);
        }
        setState(() {});
      },
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
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0Xff4D1FAE), width: 3),
        borderRadius: BorderRadius.circular(4),
        insets: EdgeInsets.all(5),
      ),
      controller: _tabController,
    );
  }

  // 编译town数据item
  _buildTownItem(_AddressListItem item) {
    if (item.type == ListItemType.label) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xffE0E0E0), width: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text(item.data?.name ?? ''),
      );
    } else {
      var selectedItem = selectTownData[currentLavel - 1];
      final selected = selectedItem != null && selectedItem.id == item.data?.id;
      return ListTile(
        leading: selected
            ? Icon(Icons.check, size: 16, color: Colors.blue)
            : null,
        minLeadingWidth: 0,
        title: Transform.translate(
          offset: Offset(selected ? -10 : 0, 0),
          child: Text(
            item.data?.name ?? '',
            style: TextStyle(color: selected ? Colors.blue : null),
          ),
        ),
        onTap: () {
          onSelectTownData(item.data!);
        },
      );
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.7;
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          const SizedBox(height: 5),
          Row(
            children: [
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  widget.title ?? '请选择地址',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close),
              ),
              const SizedBox(width: 15),
            ],
          ),
          _buildTabBar(),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: dataType == DataType.city
                      ? currentCityData.length
                      : currentTownData.length,
                  itemBuilder: (_, index) {
                    if (dataType == DataType.city) {
                      return _buildCityItem(currentCityData[index]);
                    } else {
                      return _buildTownItem(currentTownData[index]);
                    }
                  },
                ),
                // Positioned(
                //   right: 10,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.black.withAlpha(40),
                //       borderRadius: BorderRadius.circular(18),
                //     ),
                //     padding: const EdgeInsets.symmetric(vertical: 10),
                //     width: 32,
                //     child: Column(
                //       spacing: 1,
                //       children: currentPrefixList.map((item) {
                //         return GestureDetector(
                //           onTap: () {
                //             final index = currentPrefixList.indexOf(item);
                //             print(currentPrefixKeys[index]);
                //             final context =
                //                 currentPrefixKeys[index].currentContext;
                //             print(context);
                //             if (context == null) return;
                //             // 获取组件在屏幕中的位置
                //             RenderBox box =
                //                 context.findRenderObject() as RenderBox;
                //             double offset = box.localToGlobal(Offset.zero).dy;
                //
                //             _scrollController.jumpTo(offset);
                //           },
                //           child: Text('$item'),
                //         );
                //       }).toList(),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressEntity {
  final int? id;
  final int? parentId;
  final String? name;
  final String? pinyin;
  final String? pinyinPrefix;
  final int? level;

  const _AddressEntity({
    this.id,
    this.parentId,
    this.name,
    this.pinyin,
    this.pinyinPrefix,
    this.level,
  });

  factory _AddressEntity.fromJson(Map<String, dynamic> json) => _AddressEntity(
    id: json['id'] as int?,
    parentId: json['parent_id'] as int?,
    name: json['name'] as String?,
    pinyin: json['pinyin'] as String?,
    pinyinPrefix: json['pinyin_prefix'] as String?,
    level: json['level'] as int?,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': this.id,
    'parentId': this.parentId,
    'name': this.name,
    'pinyin': this.pinyin,
    'pinyinPrefix': this.pinyinPrefix,
    'level': this.level,
  };
}

enum ListItemType { label, data }

class _AddressListItem {
  final ListItemType? type;
  final _AddressEntity? data;

  _AddressListItem({this.type, this.data});
}

class _CityItem {
  final int id;
  final String name;
  final int level;
  final int parent;
  final String? long; // 经度 (JSON中是字符串或null)
  final String? lat; // 纬度 (JSON中是字符串或null)
  final String? tz; // 时区
  final List<_CityItem>? sub; // 下级地区

  _CityItem({
    required this.id,
    required this.name,
    required this.level,
    required this.parent,
    this.long,
    this.lat,
    this.tz,
    this.sub,
  });

  // 工厂构造函数：从 JSON 创建对象
  factory _CityItem.fromJson(Map<String, dynamic> json) {
    return _CityItem(
      id: json['id'] as int,
      name: json['name'] as String,
      level: json['level'] as int,
      parent: json['parent'] as int,
      long: json['long'] as String?,
      lat: json['lat'] as String?,
      tz: json['tz'] as String?,
      sub: json['sub'] == null
          ? null
          : (json['sub'] as List<dynamic>)
                .map((item) => _CityItem.fromJson(item as Map<String, dynamic>))
                .toList(),
    );
  }
}
