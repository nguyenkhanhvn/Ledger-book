part of 'Controller.dart';

class Localization {
  static final Localization _instance = Localization._internal();

  factory Localization() {
    return _instance;
  }

  Localization._internal();

  Map<String, dynamic> _data = {};

  String _currentTheme = '';
  final List<String> _listTheme = [];
  MaterialColor _themeColor = Colors.brown;

  String _currentLocale = '';
  final List<String> _listSupportLocale = [];

  MaterialColor get themeColor => _themeColor;

  String get currentTheme =>
      _data[_currentTheme][_currentLocale]?[LocalizationKeyDefine.themeName] ??
      LocalizationString.Error_Theme;

  List<String> get listTheme {
    List<String> listData = [];
    for (String theme in _listTheme) {
      listData.add(_data[theme][_currentLocale]
              ?[LocalizationKeyDefine.themeName] ??
          LocalizationString.Error_Theme);
    }
    return listData;
  }

  String get defaultProfileName =>
      _data[_currentTheme][_currentLocale]
          ?[LocalizationKeyDefine.defaultProfile] ??
      LocalizationString.Error_Profile_Name;

  String get currentLocale =>
      _data[_currentTheme][_currentLocale]?[LocalizationKeyDefine.localeName] ??
      LocalizationString.Error_Locale;

  List<String> get listSupportLocale {
    List<String> listData = [];
    for (String locale in _listSupportLocale) {
      listData.add(_data[_currentTheme][locale]
              [LocalizationKeyDefine.localeName] ??
          LocalizationString.Error_Locale);
    }
    return listData;
  }

  Map<String, dynamic> get listString => Map.of(
      _data[_currentTheme][_currentLocale]?[LocalizationKeyDefine.data] ?? {});

  void _initLocalization(Map<String, dynamic> localizationData) {
    _data = Map.of(localizationData);

    _listTheme.clear();
    _listSupportLocale.clear();

    _data.forEach((key, value) {
      _listTheme.add(key);
    });
  }

  bool _changeTheme(int index) {
    if (index >= 0 && index < _listTheme.length) {
      _currentTheme = _listTheme[index];
      _listSupportLocale.clear();
      _data[_currentTheme].forEach((key, value) {
        _listSupportLocale.add(key);
      });
      return true;
    }
    return false;
  }

  bool _changeLocal(int index) {
    if (index >= 0 && index < _listSupportLocale.length) {
      _currentLocale = _listSupportLocale[index];
      return true;
    }
    return false;
  }
}
