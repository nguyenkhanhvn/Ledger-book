import 'package:flutter/material.dart';

class HiveTypeId {
  static const int RecordModel = 1;
  static const int RecordCategory = 2;
  static const int RecordData = 3;
  static const int ItemModel = 4;
  static const int SubItemModel = 5;
}

enum ExportType {
  None,
  Custom,
}

enum PageAction {
  none,
  add,
  edit,
  delete,
  save,
}

enum MoreOption {
  none,
  sortByDateAscending,
  sortByDateDescending,
  sortByPriceAscending,
  sortByPriceDescending,
  sortByNameAscending,
  sortByNameDescending,
  import,
  exportRaw,
  exportSimplified,
  exportDetail,
}

class AppDefine {
  // App define
  static DateTime minDateTime = DateTime.utc(-271821,04,20);
  static DateTime maxDateTime = DateTime.utc(275760,09,13);

  // String
  static String get AppConfigAsset => 'assets/config.json';
  static String get AppConfigPath => 'config';
  static String get AppLocalizationAsset => 'assets/localization.json';
  static String get AppLocalizationPath => 'localization';
  static String get AppDataBox => 'app_data';
  static String get DefaultProfileName => 'default_profile';
  static String get CurrentProfileKey => 'currentProfile';
  static String get ListProfileKey => 'listProfile';
  static String get ListRecordKey => 'listRecord';
  static String get CurrentThemeKey => 'currentTheme';
  static String get CurrentLocaleKey => 'CurrentLocaleKey';
  static String get CurrentColorKey => 'currentColor';
  static String get CurrentExportTypeKey => 'currentExportType';

  // Color
  static MaterialColor get DefaultColor => Colors.brown;

  // Other
  static int get SeparatorLineLength => 16;
  static String get SeparatorLineCharacter => '-';
  static int get TabLength => 4;
  static String get TabCharacter => ' ';
}

class LocalizationKeyDefine {
  static String get themeName => 'themeName';
  static String get defaultProfile => 'defaultProfile';
  static String get localeName => 'localeName';
  static String get data => 'data';
}
