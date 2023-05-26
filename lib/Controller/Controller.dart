import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:global_configs/global_configs.dart';
import 'package:hive/hive.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/ItemModel.dart';
import 'package:ledger_book/Model/RecordModel.dart';

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

    int? currentExportType =
        await _appDataBox.get(AppDefine.CurrentExportTypeKey);
    AppData()._exportType = ExportType.values[currentExportType ?? 0];

    String? currentTheme = await _appDataBox.get(AppDefine.CurrentThemeKey);
    currentTheme ??= Localization()._listTheme[0];
    await changeTheme(Localization()._listTheme.indexOf(currentTheme));

    String? currentLocale = await _appDataBox.get(AppDefine.CurrentLocaleKey);
    await changeLocale(
        Localization()._listSupportLocale.indexOf(currentLocale ?? ''));

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
    if (!Localization()
        ._listSupportLocale
        .contains(Localization()._currentLocale)) {
      if (Localization()._listSupportLocale.isEmpty) {
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

  Future<void> changeExportType(ExportType newType) async {
    if (newType != AppData()._exportType) {
      AppData()._exportType = newType;
      await _appDataBox.put(AppDefine.CurrentExportTypeKey, newType.index);
    }
  }

  Future<void> openProfile(String? profile) async {
    await _box?.close();

    profile ??= AppDefine.DefaultProfileName;
    await _appDataBox.put(AppDefine.CurrentProfileKey, profile);
    _box = await Hive.openBox(profile);

    AppData()._currentProfile = profile;
    AppData()._listRecord = _getListRecord();
    AppData()._itemIndex = null;
    AppData()._recordIndex = null;

    int colorIndex = await _box!.get(AppDefine.CurrentColorKey) ??
        Colors.primaries.indexOf(AppDefine.DefaultColor);
    await changeThemeColor(colorIndex);
  }

  Future<bool> importProfile(String profileString) async {
    Map<String, dynamic> jsonData = json.decode(profileString);
    bool success = await addProfile(jsonData['profile']);
    if (success) {
      List<RecordModel> newListRecord = [];
      for (var recordData in jsonData['listRecord']) {
        var record = RecordModel.fromJson((recordData));
        newListRecord.add(record);
      }
      Box newProfile = await Hive.openBox(jsonData['profile']);
      await newProfile.put(AppDefine.ListRecordKey, newListRecord);
      await newProfile.close();
    }
    return success;
  }

  Future<bool> addProfile(String profile, {bool open = false}) async {
    bool result = AppData()._addProfile(profile);
    if (result) {
      await _appDataBox.put(AppDefine.ListProfileKey, AppData()._listProfile);
      if (open) await openProfile(profile);
    }
    return result;
  }

  Future<bool> editProfile(int index, String newProfile) async {
    String oldProfile = '';
    if (AppData()._checkProfileIndexValid(index)) {
      oldProfile = AppData()._listProfile[index];
    }
    if (!AppData()._editProfile(index, newProfile)) return false;

    // copy old box to new box
    late Box boxOldProfile;
    if (oldProfile == AppData()._currentProfile) {
      boxOldProfile = _box!;
      _box = null;
    } else {
      boxOldProfile = await Hive.openBox(oldProfile);
    }

    Box boxNewProfile = await Hive.openBox(newProfile);
    await boxNewProfile.put(
        AppDefine.ListRecordKey,
        List<RecordModel>.of((boxOldProfile.get(AppDefine.ListRecordKey) ?? [])
            .cast<RecordModel>()));

    // close new box
    if (oldProfile == AppData()._currentProfile) {
      AppData()._currentProfile = newProfile;
      _box = boxNewProfile;
    } else {
      await boxNewProfile.close();
    }

    // delete old box
    await boxOldProfile.deleteFromDisk();

    await _appDataBox.put(AppDefine.ListProfileKey, AppData()._listProfile);
    return true;
  }

  Future<bool> removeCurrentProfile() async {
    return removeProfile(AppData()._currentProfile);
  }

  Future<bool> removeProfile(String profile) async {
    if (profile == AppDefine.DefaultProfileName) {
      Box deleteBox = await Hive.openBox(profile);
      await deleteBox.deleteFromDisk();

      if (profile == AppData()._currentProfile) {
        await openProfile(null);
      }
      return true;
    } else {
      bool result = AppData()._removeProfile(profile);
      if (result) {
        Box deleteBox = await Hive.openBox(profile);
        await deleteBox.deleteFromDisk();

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
  }

  Future<void> sortProfile(
      int Function(RecordModel, RecordModel) compare) async {
    AppData()._sortProfile(compare);
    await _save();
  }

  Future<void> importListRecordToCurrentProfile(String listRecord) async {
    List<dynamic> data = json.decode(listRecord);
    for (var jsonData in data) {
      var record = RecordModel.fromJson((jsonData));
      AppData()._listRecord.add(record);
    }
    await _save();
  }

  bool setCurrentRecord(int index) {
    if (AppData()._checkRecordIndexValid(index)) {
      AppData()._recordIndex = index;
      AppData()._itemIndex = null;
      return true;
    }
    return false;
  }

  void setCurrentRecordCategory(RecordCategory category) {
    AppData()._currentCategory = category;
  }

  Future<void> addRecord(RecordModel record) async {
    AppData()._listRecord.add(record);
    await _save();
  }

  Future<bool> editRecord(RecordModel record) async {
    bool result = AppData()._editRecord(record);
    if (result) await _save();
    return result;
  }

  Future<bool> deleteRecord(int index) async {
    bool result = AppData()._deleteRecord(index);
    if (result) await _save();
    return result;
  }

  Future<bool> deleteCurrentRecord() async {
    bool result = AppData()._deleteCurrentRecord();
    if (result) await _save();
    return result;
  }

  Future<bool> sortRecord(int index, RecordCategory category,
      int Function(ItemModel, ItemModel) compare) async {
    bool result = AppData()._sortRecord(index, category, compare);
    if (result) await _save();
    return result;
  }

  Future<bool> sortCurrentRecord(
      int Function(ItemModel, ItemModel) compare) async {
    bool result = AppData()._sortCurrentRecord(compare);
    if (result) await _save();
    return result;
  }

  Future<bool> importListItemToCurrentRecord(String listItem) async {
    var backup = AppData()._listRecord;
    Map<String, dynamic> jsonData = json.decode(listItem);
    bool success = false;
    jsonData.forEach((categoryString, record) {
      RecordCategory category = RecordCategory.values.byName(categoryString);
      for (var item in record) {
        success = AppData()._addItem(category, ItemModel.fromJson(item));
        if (!success) break;
      }
    });
    if (success) {
      await _save();
    } else {
      AppData()._listRecord = backup;
    }
    return success;
  }

  bool setCurrentItem(int index) {
    if (AppData()._checkItemIndexValid(AppData()._currentCategory, index)) {
      AppData()._itemIndex = index;
      return true;
    }
    return false;
  }

  Future<bool> addItem(RecordCategory category, ItemModel item) async {
    bool result = AppData()._addItem(category, item);
    if (result) await _save();
    return true;
  }

  Future<bool> addItemToCurrentCategory(ItemModel item) async {
    bool result = AppData()._addItemToCurrentCategory(item);
    if (result) await _save();
    return true;
  }

  Future<bool> editItem(RecordCategory category, int? index, ItemModel item,
      {RecordCategory? toCategory}) async {
    bool result =
        AppData()._editItem(category, index, item, toCategory: toCategory);
    if (result) await _save();
    return result;
  }

  Future<bool> editCurrentItem(ItemModel item,
      {RecordCategory? toCategory}) async {
    bool result = AppData()._editCurrentItem(item, toCategory: toCategory);
    if (result) await _save();
    return result;
  }

  Future<bool> deleteItem(RecordCategory category, int? index) async {
    bool result = AppData()._deleteItem(category, index);
    if (result) await _save();
    return result;
  }

  Future<bool> deleteCurrentItem() async {
    bool result = AppData()._deleteCurrentItem();
    if (result) await _save();
    return result;
  }

  // private method
  Future<bool> _save() async {
    if (_box == null) return false;
    await _box!.put(AppDefine.ListRecordKey, AppData()._listRecord);
    return true;
  }

  List<RecordModel> _getListRecord() {
    if (_box == null) return [];
    return List<RecordModel>.of(
        (_box!.get(AppDefine.ListRecordKey) ?? []).cast<RecordModel>());
  }

  List<String> _getListProfile() {
    return List<String>.of(_appDataBox.get(AppDefine.ListProfileKey) ?? [])
        .cast<String>();
  }
}
