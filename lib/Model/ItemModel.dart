import 'package:hive/hive.dart';
import 'SubItemModel.dart';

part 'ItemModel.g.dart';

@HiveType(typeId: 2)
class ItemModel {
  @HiveField(1)
  SubItemModel data;

  @HiveField(2)
  DateTime dateTime;

  ItemModel({required this.data, DateTime? dateTime}) : dateTime = dateTime??DateTime.now();

  factory ItemModel.clone(ItemModel origin) {
    ItemModel model = ItemModel(data: SubItemModel.clone(origin.data), dateTime: origin.dateTime);
    return model;
  }

  int get totalPrice => data.totalPrice;

}
