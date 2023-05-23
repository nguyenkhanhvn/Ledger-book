import 'dart:collection';
import 'dart:convert';

import 'package:hive/hive.dart';

part 'SubItemModel.g.dart';

@HiveType(typeId: 3)
class SubItemModel {
  @HiveField(1)
  String title;

  @HiveField(2)
  int price;

  @HiveField(3)
  List<SubItemModel> _listSubItem = [];

  SubItemModel({this.title = '', this.price = 0});

  factory SubItemModel.clone(SubItemModel origin) {
    SubItemModel model = SubItemModel();
    model._deepCopy(origin, HashMap<SubItemModel, SubItemModel>());
    return model;
  }

  void deepCopy(SubItemModel origin) {
    _deepCopy(origin, HashMap<SubItemModel, SubItemModel>());
  }

  factory SubItemModel.fromJsonString(String jsonString) {
    Map<String, dynamic> jsonData = json.decode(jsonString);
    return SubItemModel.fromJson(jsonData);
  }

  factory SubItemModel.fromJson(Map<String, dynamic> jsonData) {
    SubItemModel model = SubItemModel(title: jsonData['title'], price: jsonData['price']);
    for(var subItem in jsonData['listSubItem']) {
      model._listSubItem.add(SubItemModel.clone(subItem));
    }
    return model;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> jsonListSubItem = [];
    for (var subItem in _listSubItem) {
      jsonListSubItem.add(subItem.toJson());
    }
    return {'title': title, 'price': price, 'listSubItem': jsonListSubItem};
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  List<SubItemModel> get listSubItem => List.of(_listSubItem);

  int get totalPrice {
    int totalPrice = price;
    for (SubItemModel subItem in _listSubItem) {
      totalPrice += subItem.totalPrice;
    }
    return totalPrice;
  }

  void addSubItem(SubItemModel subItem) {
    _listSubItem.add(SubItemModel.clone(subItem));
  }

  bool editSubItem(int index, SubItemModel subItem) {
    if (index < _listSubItem.length) {
      _listSubItem[index] = SubItemModel.clone(subItem);
      return true;
    }
    return false;
  }

  bool removeSubItem(int index) {
    if(index <0 || index >= _listSubItem.length) return false;
    _listSubItem.removeAt(index);
    return true;
  }

  void _deepCopy(
      SubItemModel subItem, HashMap<SubItemModel, SubItemModel> used) {
    title = subItem.title;
    price = subItem.price;

    for (SubItemModel item in subItem._listSubItem) {
      if (used.containsKey(item)) {
        _listSubItem.add(used[item]!);
      } else {
        SubItemModel newItem = SubItemModel();
        used.addAll({item: newItem});
        newItem._deepCopy(item, used);
        _listSubItem.add(newItem);
      }
    }
  }
}
