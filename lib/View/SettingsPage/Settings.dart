import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Utils.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/View/Common/CommonMaterial.dart';
import 'package:ledger_book/View/Common/CommonText.dart';
import 'package:ledger_book/View/Common/CommonTile.dart';
import 'package:ledger_book/View/Common/SimpleDialog.dart';

class Settings extends StatefulWidget {
  final VoidCallback? setState;

  const Settings({super.key, required this.setState});

  @override
  State<StatefulWidget> createState() => _Settings();
}

class _Settings extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: AppBarTitleText(LocalizationString.Settings)),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  border: Border(bottom: DarkBorderSide(width: 3))),
              child: Column(
                children: [
                  BasicIcon(Icons.account_circle, size: 100),
                  TitleText(AppData().currentProfile),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  BasicTile(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    borderLine: BasicBorderSide(width: 2),
                    child: TitleText(LocalizationString.Profile_Title),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: AppData().listProfile.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TileButton(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 15),
                          child: BasicText(AppData().listProfile[index]),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              TextEditingController textController =
                                  TextEditingController();
                              textController.text =
                                  AppData().listProfile[index];
                              return BasicDialog(
                                title:
                                    TitleText(LocalizationString.Edit_Profile),
                                content: Row(
                                  children: [
                                    BasicText(
                                        '${LocalizationString.Profile_Title}: '),
                                    Expanded(
                                      child: TextField(
                                        controller: textController,
                                        style: const BasicTextStyle(),
                                      ),
                                    ),
                                  ],
                                ),
                                successWidget:
                                    BasicText(LocalizationString.Save),
                                onSuccess: () {
                                  if (AppData().listProfile[index] !=
                                      textController.text) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BasicDialog(
                                          title: TitleText(
                                              '${LocalizationString.Confirm_Edit_Profile} ${AppData().listProfile[index]} ${LocalizationString.To} ${textController.text}'),
                                          successWidget: BasicText(
                                              LocalizationString.Confirm),
                                          onSuccess: () async {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            await Controller().editProfile(
                                                index, textController.text);
                                            setState(() {});
                                          },
                                          onCancel: () =>
                                              Navigator.pop(context),
                                        );
                                      },
                                    );
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                onCancel: () => Navigator.pop(context),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  BasicTile(
                    padding: const EdgeInsets.only(top: 40, bottom: 5),
                    borderLine: BasicBorderSide(width: 2),
                    child: TitleText(LocalizationString.Import_Export),
                  ),
                  TileButton(
                    height: 40,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: BasicText(LocalizationString.Import_Profile)),
                    onPressed: () {
                      final textController = TextEditingController();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return BasicDialog(
                            title: TitleText(LocalizationString.Import_Profile),
                            content: TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder()),
                              controller: textController,
                              maxLines: 10,
                            ),
                            successWidget: BasicText(LocalizationString.Import),
                            onSuccess: () async {
                              Navigator.pop(context);
                              Controller()
                                  .importProfile(textController.text)
                                  .then(
                                (value) {
                                  textController.clear();
                                  setState(() {});
                                  Utils.showToast(context,
                                      LocalizationString.Import_Successfully);
                                },
                                onError: (e) {
                                  textController.clear();
                                  setState(() {});
                                  Utils.showToast(context,
                                      '${LocalizationString.Import_Error}: $e');
                                },
                              );
                            },
                            onCancel: () => Navigator.pop(context),
                          );
                        },
                      );
                    },
                  ),
                  BasicTile(
                    padding: const EdgeInsets.only(top: 40, bottom: 5),
                    borderLine: BasicBorderSide(width: 2),
                    child: TitleText(LocalizationString.Settings),
                  ),
                  TileButton(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(child: BasicText(LocalizationString.Language)),
                        BasicText(Localization().currentLocale),
                      ],
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  Localization().listSupportLocale.length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  value: index,
                                  groupValue: Localization()
                                      .listSupportLocale
                                      .indexOf(Localization().currentLocale),
                                  onChanged: (index) async {
                                    Navigator.pop(context);
                                    await Controller()
                                        .changeLocale(index ??= 0);
                                    setState(() => {});
                                  },
                                  title: BasicText(
                                      Localization().listSupportLocale[index]),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  TileButton(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(child: BasicText(LocalizationString.Theme)),
                        BasicText(Localization().currentTheme),
                      ],
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: Localization().listTheme.length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  value: index,
                                  groupValue: Localization()
                                      .listTheme
                                      .indexOf(Localization().currentTheme),
                                  onChanged: (index) async {
                                    Navigator.pop(context);
                                    await Controller().changeTheme(index ?? 0);
                                    setState(() => {});
                                  },
                                  title: BasicText(
                                      Localization().listTheme[index]),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  TileButton(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(child: BasicText(LocalizationString.Color)),
                        Icon(
                          Icons.circle,
                          color: Localization().themeColor,
                        ),
                      ],
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: Colors.primaries.length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  value: index,
                                  groupValue: Colors.primaries
                                      .indexOf(Localization().themeColor),
                                  onChanged: (index) async {
                                    Navigator.pop(context);
                                    await Controller()
                                        .changeThemeColor(index ?? 0);
                                    setState(() {});
                                    widget.setState?.call();
                                  },
                                  title: Icon(
                                    Icons.circle,
                                    color: Colors.primaries[index],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
