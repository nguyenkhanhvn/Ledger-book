part of 'Controller.dart';

class AppData {
  static final AppData _instance = AppData._internal();

  factory AppData() {
    return _instance;
  }

  AppData._internal();

  String _currentProfile = '';
  List<String> _listProfile = [];
  List<OrderModel> _listOrder = [];

  int? _orderIndex;
  int? _itemIndex;

  String get currentProfile {
    if (_currentProfile == AppDefine.DefaultProfileName) {
      return Localization().defaultProfileName;
    }
    return _currentProfile;
  }

  List<String> get listProfile => List.of(_listProfile);

  OrderModel? get currentOrder {
    if (_checkOrderIndexValid(_orderIndex)) {
      return OrderModel.clone(_listOrder[_orderIndex!]);
    }
    return null;
  }

  ItemModel? get currentItem {
    if (_checkItemIndexValid(_itemIndex)) {
      return ItemModel.clone(_listOrder[_orderIndex!].listItem[_itemIndex!]);
    }
    return null;
  }

  List<OrderModel> get listOrder {
    List<OrderModel> returnList = [];
    for (OrderModel order in _listOrder) {
      returnList.add(OrderModel.clone(order));
    }
    return returnList;
  }

  int get totalPrice {
    int totalPrice = 0;
    for (var order in _listOrder) {
      totalPrice += order.totalPrice;
    }
    return totalPrice;
  }

  bool _checkProfileIndexValid(int? index) {
    return index != null && index >= 0 && index < _listProfile.length;
  }

  bool _addProfile(String profile) {
    if (profile.isEmpty && _listProfile.contains(profile)) return false;
    _listProfile.add(profile);
    return true;
  }

  bool _editProfile(int index, String profile) {
    if (!_checkProfileIndexValid(index)) return false;
    _listProfile[index] = profile;
    return true;
  }

  bool _removeCurrentProfile() {
    return _listProfile.remove(_currentProfile);
  }

  bool _removeProfile(String profile) {
    return _listProfile.remove(profile);
  }

  void _sortProfile(int Function(OrderModel, OrderModel) compare) {
    _listOrder.sort(compare);
  }

  bool _checkOrderIndexValid(int? index) {
    return index != null && index >= 0 && index < _listOrder.length;
  }

  bool _checkItemIndexValid(int? index) {
    return _checkOrderIndexValid(_orderIndex) &&
        index != null &&
        index >= 0 &&
        index < _listOrder[_orderIndex!].listItem.length;
  }

  bool _editOrder(OrderModel order) {
    if (!_checkOrderIndexValid(_orderIndex)) return false;
    _listOrder[_orderIndex!] = order;
    return true;
  }

  bool _deleteCurrentOrder() {
    if (!_checkOrderIndexValid(_orderIndex)) return false;
    _listOrder.removeAt(_orderIndex!);
    _orderIndex = null;
    return true;
  }

  bool _deleteOrder(int index) {
    if (!_checkOrderIndexValid(index)) return false;
    _listOrder.removeAt(index);
    if (_orderIndex != null && index <= _orderIndex!) {
      _orderIndex = _orderIndex! - 1;
    }
    return true;
  }

  bool _sortCurrentOrder(int Function(ItemModel, ItemModel) compare) {
    if (!_checkOrderIndexValid(_orderIndex)) return false;
    List<ItemModel> newItemList = _listOrder[_orderIndex!].listItem;
    newItemList.sort(compare);
    _listOrder[_orderIndex!].listItem = newItemList;
    return true;
  }

  bool _sortOrder(int index, int Function(ItemModel, ItemModel) compare) {
    if (!_checkOrderIndexValid(index)) return false;
    List<ItemModel> newItemList = _listOrder[index].listItem;
    newItemList.sort(compare);
    _listOrder[index].listItem = newItemList;
    return true;
  }

  bool _addItem(ItemModel item) {
    if (!_checkOrderIndexValid(_orderIndex)) return false;
    _listOrder[_orderIndex!].addItem(ItemModel.clone(item));
    return true;
  }

  bool _editItem(ItemModel item) {
    if (!_checkItemIndexValid(_itemIndex)) return false;
    _listOrder[_orderIndex!].editItem(_itemIndex!, ItemModel.clone(item));
    return true;
  }

  bool _deleteCurrentItem() {
    if (!_checkItemIndexValid(_itemIndex)) return false;
    _listOrder[_orderIndex!].removeItem(_itemIndex!);
    _itemIndex = null;
    return true;
  }

  bool _deleteItem(int index) {
    if (!_checkItemIndexValid(index)) return false;
    _listOrder[_orderIndex!].removeItem(index);
    if (_itemIndex != null && index <= _itemIndex!) {
      _itemIndex = _itemIndex! - 1;
    }
    return true;
  }
}
