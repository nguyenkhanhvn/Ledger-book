import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Common/Utils.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'ItemModel.dart';

part 'RecordModel.g.dart';

@HiveType(typeId: HiveTypeId.RecordModel)
class RecordModel {
  @HiveField(0)
  String title;

  @HiveField(1)
  Map<RecordCategory, _RecordData> _records = {};

  RecordModel({this.title = ''});

  static registerHiveAdapter() {
    Hive.registerAdapter(RecordCategoryAdapter());
    Hive.registerAdapter(RecordDataAdapter());
    Hive.registerAdapter(RecordModelAdapter());
  }

  factory RecordModel.clone(RecordModel origin) {
    RecordModel model = RecordModel(title: origin.title);
    origin._records.forEach((category, record) {
      model._records[category] = _RecordData.clone(record);
    });
    return model;
  }

  factory RecordModel.fromJson(Map<String, dynamic> jsonData) {
    RecordModel model = RecordModel(title: jsonData['title']);
    jsonData['records'].forEach((categoryString, record) {
      RecordCategory category = RecordCategory.values.byName(categoryString);
      model._records[category] = _RecordData();
      for (var item in record) {
        model._records[category]!._listItem.add(ItemModel.fromJson(item));
      }
      model._records[category]!.reloadDateTime();
    });
    return model;
  }

  factory RecordModel.fromJsonString(String jsonString) {
    Map<String, dynamic> jsonData = json.decode(jsonString);
    return RecordModel.fromJson(jsonData);
  }

  Map<String, dynamic> toJson() {
    Map<String, List<Map<String, dynamic>>> jsonRecords = {};
    _records.forEach((category, record) {
      jsonRecords[category.name] = record.toJson();
    });
    return {'title': title, 'records': jsonRecords};
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  DateTime? get startDate {
    DateTime? startDate;
    _records.forEach((category, record) {
      if (record.startDate != null) {
        if (startDate?.isAfter(record.startDate!) ?? true) {
          startDate = record.startDate;
        }
      }
    });
    return startDate;
  }

  DateTime? get endDate {
    DateTime? endDate;
    _records.forEach((category, record) {
      if (record.endDate != null) {
        if (endDate?.isBefore(record.endDate!) ?? true) {
          endDate = record.endDate;
        }
      }
    });
    return endDate;
  }

  DateTime? getRecordStartDate(RecordCategory category) =>
      _records[category]?.startDate;

  DateTime? getRecordEndDate(RecordCategory category) => _records[category]?.endDate;

  List<ItemModel> getListItem(RecordCategory category) =>
      _records[category]?.listItem ?? [];

  void setListItem(RecordCategory category, List<ItemModel> listItem) {
    if (!_records.containsKey(category)) {
      _records[category] = _RecordData();
    }
    _records[category]!.listItem = listItem;
  }

  int getTotalPrice(RecordCategory category) =>
      _records[category]?.totalPrice ?? 0;

  String getDateTimeShortString(RecordCategory category) =>
      '${Utils.formatShortDateTime(_records[category]?._startDate)} ${LocalizationString.To} ${Utils.formatShortDateTime(_records[category]?._endDate)}';

  String getDateTimeString(RecordCategory category) =>
      '${Utils.formatDateTime(_records[category]?._startDate)} ${LocalizationString.To} ${Utils.formatDateTime(_records[category]?._endDate)}';

  void addItem(RecordCategory category, ItemModel item) {
    if (!_records.containsKey(category)) {
      _records[category] = _RecordData();
    }
    _records[category]!.addItem(ItemModel.clone(item));
  }

  void editItem(RecordCategory category, int index, ItemModel item) {
    _records[category]?.editItem(index, ItemModel.clone(item));
  }

  bool removeItem(RecordCategory category, int index) {
    return _records[category]?.removeItem(index) ?? false;
  }
}

@HiveType(typeId: HiveTypeId.RecordCategory)
enum RecordCategory {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: HiveTypeId.RecordData)
class _RecordData {
  @HiveField(0)
  DateTime? _startDate;

  @HiveField(1)
  DateTime? _endDate;

  @HiveField(2)
  List<ItemModel> _listItem = [];

  _RecordData();

  factory _RecordData.clone(_RecordData origin) {
    _RecordData data = _RecordData();
    data._startDate = origin._startDate;
    data._endDate = origin._endDate;
    for (ItemModel item in origin._listItem) {
      data._listItem.add(ItemModel.clone(item));
    }
    return data;
  }

  factory _RecordData.fromJson(List<Map<String, dynamic>> jsonData) {
    _RecordData data = _RecordData();
    for (var item in jsonData) {
      data._listItem.add(ItemModel.fromJson(item));
    }
    data.reloadDateTime();
    return data;
  }

  factory _RecordData.fromJsonString(String jsonString) {
    List<Map<String, dynamic>> jsonData = json.decode(jsonString);
    return _RecordData.fromJson(jsonData);
  }

  List<Map<String, dynamic>> toJson() {
    List<Map<String, dynamic>> jsonListItem = [];
    for (var item in _listItem) {
      jsonListItem.add(item.toJson());
    }
    return jsonListItem;
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  DateTime? get startDate => _startDate;

  DateTime? get endDate => _endDate;

  List<ItemModel> get listItem => List.of(_listItem);

  set listItem(List<ItemModel> newListItem) {
    _listItem.clear();
    for (ItemModel item in newListItem) {
      _listItem.add(ItemModel.clone(item));
    }
    reloadDateTime();
  }

  int get totalPrice {
    int totalPrice = 0;
    for (ItemModel item in _listItem) {
      totalPrice += item.totalPrice;
    }
    return totalPrice;
  }

  void addItem(ItemModel item) {
    _listItem.add(item);
    if (_startDate == null || item.dateTime.isBefore(_startDate!)) {
      _startDate = item.dateTime;
    }
    if (_endDate == null || item.dateTime.isAfter(_endDate!)) {
      _endDate = item.dateTime;
    }
  }

  void editItem(int index, ItemModel item) {
    if (index < 0 || index >= _listItem.length) return;
    _listItem[index] = item;
    reloadDateTime();
  }

  bool removeItem(int index) {
    if (index < 0 || index >= _listItem.length) return false;
    _listItem.removeAt(index);
    reloadDateTime();
    return true;
  }

  void reloadDateTime() {
    if (_listItem.isEmpty) {
      _startDate = null;
      _endDate = null;
    } else {
      _startDate = _listItem[0].dateTime;
      _endDate = _listItem[0].dateTime;
      for (ItemModel item in _listItem) {
        if (item.dateTime.isBefore(_startDate!)) {
          _startDate = item.dateTime;
        } else if (item.dateTime.isAfter(_endDate!)) {
          _endDate = item.dateTime;
        }
      }
    }
  }
}
