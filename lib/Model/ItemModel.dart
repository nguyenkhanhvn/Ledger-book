import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:ledger_book/Common/Utils.dart';
import 'SubItemModel.dart';

part 'ItemModel.g.dart';

@HiveType(typeId: 2)
class ItemModel {
  @HiveField(1)
  SubItemModel data;

  @HiveField(2)
  DateTime dateTime;

  ItemModel({SubItemModel? data, DateTime? dateTime})
      : data = data ?? SubItemModel(),
        dateTime = dateTime ?? DateTime.now();

  factory ItemModel.clone(ItemModel origin) {
    ItemModel model = ItemModel(
        data: SubItemModel.clone(origin.data), dateTime: origin.dateTime);
    return model;
  }

  factory ItemModel.fromJson(Map<String, dynamic> jsonData) {
    return ItemModel(
        data: SubItemModel.fromJson(jsonData['data']),
        dateTime: DateTime.parse(jsonData['dateTime']));
  }

  factory ItemModel.fromJsonString(String jsonString) {
    Map<String, dynamic> jsonData = json.decode(jsonString);
    return ItemModel.fromJson(jsonData);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'dateTime': Utils.basicFormatDateTime(dateTime)
    };
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  String get title => data.title;

  int get price => data.price;

  int get totalPrice => data.totalPrice;

  List<SubItemModel> get listSubItem => data.listSubItem;

  String get dateTimeShortString => Utils.formatShortDateTime(dateTime);

  String get dateTimeString => Utils.formatDateTime(dateTime);

  void addSubItem(SubItemModel subItem) {
    data.addSubItem(SubItemModel.clone(subItem));
  }

  bool editSubItem(int index, SubItemModel subItem) {
    return data.editSubItem(index, subItem);
  }

  bool removeSubItem(int index) {
    return data.removeSubItem(index);
  }
}
