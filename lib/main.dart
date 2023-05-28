import 'package:flutter/material.dart';
import 'package:global_configs/global_configs.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/RecordModel.dart';
import 'package:ledger_book/Model/ItemModel.dart';
import 'package:ledger_book/Model/SubItemModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'View/HomePage/HomePage.dart';

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(SubItemModelAdapter());
  Hive.registerAdapter(ItemModelAdapter());
  RecordModel.registerHiveAdapter();
}

void main() async {
  List<int> l = [1,2];
  print(l.sublist(2));
  WidgetsFlutterBinding.ensureInitialized();

  await GlobalConfigs()
      .loadJsonFromdir(AppDefine.AppConfigAsset, path: AppDefine.AppConfigPath);
  await GlobalConfigs().loadJsonFromdir(AppDefine.AppLocalizationAsset,
      path: AppDefine.AppLocalizationPath);

  await initHive();

  if (!await Controller().initialize()) return;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: LocalizationString.App_Title,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        primarySwatch: Localization().themeColor,
      ),
      home: HomePage(callback: () => setState(() {})),
    );
  }
}
