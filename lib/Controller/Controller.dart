import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configs/global_configs.dart';
import 'package:hive/hive.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/ItemModel.dart';
import 'package:ledger_book/Model/OrderModel.dart';

part 'AppData.dart';

part 'Localization.dart';

class Controller {
  static final Controller _instance = Controller._internal();

  factory Controller() {
    return _instance;
  }

  Controller._internal();

  bool isInitialize = false;
  Box? _box;
  late Box _appDataBox;

  Future<bool> initialize() async {
    _appDataBox = await Hive.openBox(AppDefine.AppDataBox);

    Map<String, dynamic> localizationData =
        GlobalConfigs().get(AppDefine.AppLocalizationPath)!;
    if (localizationData.isEmpty) return false;

    Localization()._initLocalization(localizationData);
    if (Localization()._listTheme.isEmpty) return false;

    String? currentTheme = await _appDataBox.get(AppDefine.CurrentThemeKey);
    currentTheme ??= Localization()._listTheme[0];
    await changeTheme(Localization()._listTheme.indexOf(currentTheme));

    String? currentLocale = await _appDataBox.get(AppDefine.CurrentLocaleKey);
    await changeLocale(Localization()._listSupportLocale.indexOf(currentLocale??''));

    // Open Profile
    String? profile = await _appDataBox.get(AppDefine.CurrentProfileKey);
    AppData()._listProfile = _getListProfile();
    await openProfile(profile);

    isInitialize = true;
    return true;
  }

  Future<bool> changeThemeColor(int colorIndex) async {
    Localization()._themeColor = Colors.primaries[colorIndex];
    if (_box == null) return false;
    await _box!.put(AppDefine.CurrentColorKey, colorIndex);
    return true;
  }

  Future<bool> changeTheme(int index) async {
    bool result = Localization()._changeTheme(index);
    if (result) {
      await _appDataBox.put(
          AppDefine.CurrentThemeKey, Localization()._currentTheme);
    }
    if(!Localization()._listSupportLocale.contains(Localization()._currentLocale)) {
      if(Localization()._listSupportLocale.isEmpty) {
        Localization()._currentLocale = '';
      } else {
        Localization()._currentLocale = Localization()._listSupportLocale[0];
      }
    }
    return result;
  }

  Future<bool> changeLocale(int index) async {
    bool result = Localization()._changeLocal(index);
    if (result) {
      await _appDataBox.put(
          AppDefine.CurrentLocaleKey, Localization()._currentLocale);
    }
    return result;
  }

  Future<void> openProfile(String? profile) async {
    await _box?.close();

    profile ??= AppDefine.DefaultProfileName;
    await _appDataBox.put(AppDefine.CurrentProfileKey, profile);
    _box = await Hive.openBox(profile);

    AppData()._currentProfile = profile;
    AppData()._listOrder = _getListOrder();
    AppData()._itemIndex = null;
    AppData()._orderIndex = null;


    int colorIndex = await _box!.get(AppDefine.CurrentColorKey) ??
        Colors.primaries.indexOf(AppDefine.DefaultColor);
    await changeThemeColor(colorIndex);
  }

  Future<bool> addProfile(String profile) async {
    bool result = AppData()._addProfile(profile);
    if (result) {
      await _appDataBox.put(AppDefine.ListProfileKey, AppData()._listProfile);
    }
    await openProfile(profile);
    return result;
  }

  Future<bool> editProfile(int index, String profile) async {
    bool result = AppData()._editProfile(index, profile);
    if (result) {
      await _appDataBox.put(AppDefine.ListProfileKey, AppData()._listProfile);
    }
    await openProfile(profile);
    return result;
  }

  Future<bool> removeCurrentProfile() async {
    bool result = AppData()._removeCurrentProfile();
    await _appDataBox.put(AppDefine.ListProfileKey, AppData()._listProfile);
    if (AppData()._listProfile.isEmpty) {
      await openProfile(null);
    } else {
      await openProfile(AppData()._listProfile.first);
    }
    return result;
  }

  Future<bool> removeProfile(String profile) async {
    bool result = AppData()._removeProfile(profile);
    if (result) {
      await _appDataBox.put(AppDefine.ListProfileKey, AppData()._listProfile);
      if (profile == AppData()._currentProfile) {
        if (AppData()._listProfile.isEmpty) {
          await openProfile(null);
        } else {
          await openProfile(AppData()._listProfile.first);
        }
      }
    }
    return result;
  }

  Future<void> sortProfile(int Function(OrderModel, OrderModel) compare) async {
    AppData()._sortProfile(compare);
    await _save();
  }

  Future<void> importListOrderToCurrentProfile(String listOrder) async {
    List<dynamic> data = json.decode(listOrder);
    for(var jsonData in data) {
      var order = OrderModel.fromJson((jsonData));
      AppData()._listOrder.add(order);
    }
    await _save();
  }

  bool setCurrentOrder(int index) {
    if (AppData()._checkOrderIndexValid(index)) {
      AppData()._orderIndex = index;
      AppData()._itemIndex = null;
      return true;
    }
    return false;
  }

  Future<void> addOrder(OrderModel order) async {
    AppData()._listOrder.add(order);
    await _save();
  }

  Future<bool> editOrder(OrderModel order) async {
    bool result = AppData()._editOrder(order);
    if (result) await _save();
    return result;
  }

  Future<bool> deleteCurrentOrder() async {
    bool result = AppData()._deleteCurrentOrder();
    if (result) await _save();
    return result;
  }

  Future<bool> deleteOrder(int index) async {
    bool result = AppData()._deleteOrder(index);
    if (result) await _save();
    return result;
  }

  Future<bool> sortCurrentOrder(int Function(ItemModel, ItemModel) compare) async {
    bool result = AppData()._sortCurrentOrder(compare);
    if (result) await _save();
    return result;
  }

  Future<bool> sortOrder(int index, int Function(ItemModel, ItemModel) compare) async {
    bool result = AppData()._sortOrder(index, compare);
    if (result) await _save();
    return result;
  }

  Future<bool> importListItemToCurrentOrder(String listItem) async {
    var backup = AppData()._listOrder;
    List<dynamic> data = json.decode(listItem);
    bool success = false;
    for(var jsonData in data) {
      var item = ItemModel.fromJson((jsonData));
      success = AppData()._addItem(item);
      if(!success) break;
    }
    if(success) {
      await _save();
    } else {
      AppData()._listOrder = backup;
    }
    return success;
  }

  bool setCurrentItem(int index) {
    if (AppData()._checkItemIndexValid(index)) {
      AppData()._itemIndex = index;
      return true;
    }
    return false;
  }

  Future<bool> addItem(ItemModel item) async {
    bool result = AppData()._addItem(item);
    if (result) await _save();
    return true;
  }

  Future<bool> editItem(ItemModel item) async {
    bool result = AppData()._editItem(item);
    if (result) await _save();
    return result;
  }

  Future<bool> deleteCurrentItem() async {
    bool result = AppData()._deleteCurrentItem();
    if (result) await _save();
    return result;
  }

  Future<bool> deleteItem(int index) async {
    bool result = AppData()._deleteItem(index);
    if (result) await _save();
    return result;
  }


  // private method
  Future<bool> _save() async {
    if (_box == null) return false;
    await _box!.put(AppDefine.ListOrderKey, AppData()._listOrder);
    return true;
  }

  List<OrderModel> _getListOrder() {
    if (_box == null) return [];
    return List<OrderModel>.of(
        (_box!.get(AppDefine.ListOrderKey) ?? []).cast<OrderModel>());
  }

  List<String> _getListProfile() {
    return List<String>.of(_appDataBox.get(AppDefine.ListProfileKey) ?? [])
        .cast<String>();
  }
}
