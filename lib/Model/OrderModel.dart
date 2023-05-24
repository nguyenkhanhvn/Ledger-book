import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:ledger_book/Common/Utils.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'ItemModel.dart';

part 'OrderModel.g.dart';

@HiveType(typeId: 1)
class OrderModel {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime? _startDate;

  @HiveField(2)
  DateTime? _endDate;

  @HiveField(3)
  List<ItemModel> _listItem = [];

  OrderModel({this.title = ''});

  factory OrderModel.clone(OrderModel origin) {
    OrderModel model = OrderModel(title: origin.title);
    model._startDate = origin._startDate;
    model._endDate = origin._endDate;
    for (ItemModel item in origin._listItem) {
      model._listItem.add(ItemModel.clone(item));
    }
    return model;
  }

  factory OrderModel.fromJson(Map<String, dynamic> jsonData) {
    OrderModel model = OrderModel(title: jsonData['title']);
    for (var item in jsonData['listItem']) {
      model._listItem.add(ItemModel.fromJson(item));
    }
    model.reloadDateTime();
    return model;
  }

  factory OrderModel.fromJsonString(String jsonString) {
    Map<String, dynamic> jsonData = json.decode(jsonString);
    return OrderModel.fromJson(jsonData);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> jsonListItem = [];
    for (var item in _listItem) {
      jsonListItem.add(item.toJson());
    }
    return {'title': title, 'listItem': jsonListItem};
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  DateTime? get startDate => _startDate;

  DateTime? get endDate => _endDate;

  List<ItemModel> get listItem => List.of(_listItem);

  String get dateTimeShortString =>
      '${Utils.formatShortDateTime(_startDate)} ${LocalizationString.To} ${Utils.formatShortDateTime(_endDate)}';

  String get dateTimeString =>
      '${Utils.formatDateTime(_startDate)} ${LocalizationString.To} ${Utils.formatDateTime(_endDate)}';

  set listItem(List<ItemModel> newListItem) {
    _listItem.clear();
    for (var item in newListItem) {
      _listItem.add(item);
    }
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
