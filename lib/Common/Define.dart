import 'package:flutter/material.dart';

enum PageAction {
  none,
  add,
  edit,
  delete,
  save,
}

enum SortType {
  none,
  byDateAscending,
  byDateDescending,
  byPriceAscending,
  byPriceDescending,
  byNameAscending,
  byNameDescending,
}

class AppDefine {
  static String get AppConfigAsset => 'assets/config.json';
  static String get AppConfigPath => 'config';
  static String get AppLocalizationAsset => 'assets/localization.json';
  static String get AppLocalizationPath => 'localization';
  static String get AppDataBox => 'app_data';
  static String get DefaultProfileName => 'default_profile';
  static String get CurrentProfileKey => 'currentProfile';
  static String get ListProfileKey => 'listProfile';
  static String get ListOrderKey => 'order';
  static String get CurrentThemeKey => 'currentTheme';
  static String get CurrentLocaleKey => 'CurrentLocaleKey';
  static String get CurrentColorKey => 'currentColor';

  static MaterialColor get DefaultColor => Colors.brown;
}

class LocalizationKeyDefine {
  static String get themeName => 'themeName';
  static String get defaultProfile => 'defaultProfile';
  static String get localeName => 'localeName';
  static String get data => 'data';
}