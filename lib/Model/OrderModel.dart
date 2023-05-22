import 'package:hive/hive.dart';
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

  DateTime? get startDate => _startDate;

  DateTime? get endDate => _endDate;

  List<ItemModel> get listItem => List.of(_listItem);

  set listItem(List<ItemModel> newListItem) {
    _listItem = newListItem;
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
