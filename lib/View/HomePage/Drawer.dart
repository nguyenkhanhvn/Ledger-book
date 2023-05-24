import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/View/Common/CommonMaterial.dart';
import 'package:ledger_book/View/Common/CommonText.dart';
import 'package:ledger_book/View/Common/SimpleDialog.dart';
import 'package:ledger_book/View/PageRouting.dart';
import 'package:ledger_book/View/SettingsPage/Settings.dart';

class AppDrawer extends StatefulWidget {
  final VoidCallback? callback;

  const AppDrawer({super.key, this.callback});

  @override
  State<StatefulWidget> createState() => _AppDrawer();
}

class _AppDrawer extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration:
                BoxDecoration(border: Border(bottom: DarkBorderSide(width: 3))),
            child: Column(
              children: [
                BasicIcon(Icons.account_circle, size: 100),
                TitleText(AppData().currentProfile),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: AppData().listProfile.length + 2,
              itemBuilder: (BuildContext context, int index) {
                if (index < AppData().listProfile.length) {
                  return TextButton(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 10),
                      child: BasicText(AppData().listProfile[index]),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      await Controller()
                          .openProfile(AppData().listProfile[index]);
                      widget.callback?.call();
                    },
                  );
                } else if (index == AppData().listProfile.length) {
                  return TextButton(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: BasicText(Localization().defaultProfileName),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      await Controller().openProfile(null);
                      widget.callback?.call();
                    },
                  );
                } else {
                  return Container(
                    decoration:
                        BoxDecoration(border: Border(top: LightBorderSide())),
                    child: TextButton(
                      child: Row(
                        children: [
                          Expanded(
                            child: BasicText(LocalizationString.Add_Profile),
                          ),
                          const Icon(Icons.add_circle_outline),
                        ],
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            TextEditingController textController =
                                TextEditingController();
                            return BasicDialog(
                              title: TitleText(LocalizationString.Add_Profile),
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
                              successWidget: BasicText(LocalizationString.Add),
                              onSuccess: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BasicDialog(
                                      title: TitleText(
                                          '${LocalizationString.Confirm_Add_Profile} ${textController.text}'),
                                      successWidget:
                                          BasicText(LocalizationString.Confirm),
                                      onSuccess: () async {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        await Controller()
                                            .addProfile(textController.text);
                                        widget.callback?.call();
                                      },
                                      onCancel: () => Navigator.pop(context),
                                    );
                                  },
                                );
                              },
                              onCancel: () => Navigator.pop(context),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
          TextButton(
            onPressed: () => PageRouting.routeWithCallback(
              context,
              builder: (context) => Settings(setState: widget.callback),
              callback: () {
                setState(() {});
                widget.callback?.call();
              },
            ),
            child: Row(
              children: [
                Expanded(
                  child: BasicText(LocalizationString.Settings),
                ),
                const Icon(Icons.settings),
              ],
            ),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Row(
              children: [
                Expanded(
                  child: BasicText(LocalizationString.Exit),
                ),
                const Icon(Icons.exit_to_app),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
