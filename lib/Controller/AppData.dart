part of 'Controller.dart';

class AppData {
  static final AppData _instance = AppData._internal();

  factory AppData() {
    return _instance;
  }

  AppData._internal();

  String _currentProfile = '';
  List<String> _listProfile = [];
  List<RecordModel> _listRecord = [];
  ExportType _exportType = ExportType.None;

  int? _recordIndex;
  RecordCategory _currentCategory = RecordCategory.expense;
  int? _itemIndex;

  String get currentProfile {
    if (_currentProfile == AppDefine.DefaultProfileName) {
      return Localization().defaultProfileName;
    }
    return _currentProfile;
  }

  List<String> get listProfile => List.of(_listProfile);

  ExportType get exportType => _exportType;

  RecordModel? get currentRecord {
    if (_checkRecordIndexValid(_recordIndex)) {
      return RecordModel.clone(_listRecord[_recordIndex!]);
    }
    return null;
  }

  RecordCategory get currentRecordCategory => _currentCategory;

  List<ItemModel> get currentListItem {
    if (_checkItemIndexValid(_currentCategory, _recordIndex)) {
      return _listRecord[_recordIndex!].getListItem(_currentCategory);
    }
    return [];
  }

  ItemModel? get currentItem {
    if (_checkItemIndexValid(_currentCategory, _itemIndex)) {
      return ItemModel.clone(_listRecord[_recordIndex!]
          .getListItem(_currentCategory)[_itemIndex!]);
    }
    return null;
  }

  List<RecordModel> get listRecord {
    List<RecordModel> returnList = [];
    for (RecordModel record in _listRecord) {
      returnList.add(RecordModel.clone(record));
    }
    return returnList;
  }

  bool _checkProfileIndexValid(int? index) {
    return index != null && index >= 0 && index < _listProfile.length;
  }

  bool _addProfile(String profile) {
    if (_listProfile.contains(profile)) return false;
    _listProfile.add(profile);
    return true;
  }

  bool _editProfile(int index, String profile) {
    if (!_checkProfileIndexValid(index) || _listProfile.contains(profile)) {
      return false;
    }
    _listProfile[index] = profile;
    return true;
  }

  bool _removeProfile(String profile) {
    return _listProfile.remove(profile);
  }

  void _sortProfile(int Function(RecordModel, RecordModel) compare) {
    _listRecord.sort(compare);
  }

  bool _checkRecordIndexValid(int? index) {
    return index != null && index >= 0 && index < _listRecord.length;
  }

  bool _checkItemIndexValid(RecordCategory category, int? index) {
    return _checkRecordIndexValid(_recordIndex) &&
        index != null &&
        index >= 0 &&
        index < _listRecord[_recordIndex!].getListItem(_currentCategory).length;
  }

  bool _editRecord(RecordModel record) {
    if (!_checkRecordIndexValid(_recordIndex)) return false;
    _listRecord[_recordIndex!] = record;
    return true;
  }

  bool _deleteRecord(int index) {
    if (!_checkRecordIndexValid(index)) return false;
    _listRecord.removeAt(index);
    if (_recordIndex != null && index <= _recordIndex!) {
      _recordIndex = _recordIndex! - 1;
    }
    return true;
  }

  bool _deleteCurrentRecord() {
    if (!_checkRecordIndexValid(_recordIndex)) return false;
    _listRecord.removeAt(_recordIndex!);
    _recordIndex = null;
    return true;
  }

  bool _sortRecord(int? index, RecordCategory category,
      int Function(ItemModel, ItemModel) compare) {
    if (!_checkRecordIndexValid(index)) return false;
    List<ItemModel> newItemList = _listRecord[index!].getListItem(category);
    if (newItemList.isNotEmpty) newItemList.sort(compare);
    _listRecord[index].setListItem(category, newItemList);
    return true;
  }

  bool _sortCurrentRecord(int Function(ItemModel, ItemModel) compare) {
    return _sortRecord(_recordIndex, _currentCategory, compare);
  }

  bool _addItem(RecordCategory category, ItemModel item) {
    if (!_checkRecordIndexValid(_recordIndex)) return false;
    _listRecord[_recordIndex!].addItem(category, ItemModel.clone(item));
    return true;
  }

  bool _addItemToCurrentCategory(ItemModel item) {
    if (!_checkRecordIndexValid(_recordIndex)) return false;
    _listRecord[_recordIndex!].addItem(_currentCategory, ItemModel.clone(item));
    return true;
  }

  bool _editItem(RecordCategory category, int? index, ItemModel item, {RecordCategory? toCategory}) {
    if (!_checkItemIndexValid(category, index)) return false;
    if(toCategory != null && toCategory != category) {
      if(!_deleteItem(category, index)) return false;
      if(_addItem(toCategory, item)) return false;
    } else {
      _listRecord[_recordIndex!]
          .editItem(category, index!, ItemModel.clone(item));
    }
    return true;
  }

  bool _editCurrentItem(ItemModel item, {RecordCategory? toCategory}) {
    return _editItem(_currentCategory, _itemIndex, item, toCategory: toCategory);
  }

  bool _deleteItem(RecordCategory category, int? index) {
    if (!_checkItemIndexValid(category, index)) return false;
    _listRecord[_recordIndex!].removeItem(category, index!);
    if (category == _currentCategory && _itemIndex != null) {
      if (index < _itemIndex!) {
        _itemIndex = _itemIndex! - 1;
      } else if (index == _itemIndex) {
        _itemIndex = null;
      }
    }
    return true;
  }

  bool _deleteCurrentItem() {
    return _deleteItem(_currentCategory, _itemIndex!);
  }
}
