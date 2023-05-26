import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Common/Utils.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/View/Common/BasicPopupMenu.dart';
import 'package:ledger_book/View/Common/MyFlutterIcons.dart';
import 'package:ledger_book/View/Model/CheckboxModel.dart';
import 'package:ledger_book/Model/RecordModel.dart';
import 'package:ledger_book/View/Common/CommonListview.dart';
import 'package:ledger_book/View/Common/CommonMaterial.dart';
import 'package:ledger_book/View/Common/CommonText.dart';
import 'package:ledger_book/View/Common/Footer.dart';
import 'package:ledger_book/View/Common/SimpleDialog.dart';
import 'package:ledger_book/View/HomePage/CheckboxRecordTile.dart';
import 'package:ledger_book/View/HomePage/Drawer.dart';
import 'package:ledger_book/View/HomePage/RecordEdit.dart';
import 'package:ledger_book/View/Model/PopupMenuModel.dart';

import 'RecordTile.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? callback;

  const HomePage({super.key, this.callback});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool editMode = false;
  final List<CheckboxModel<RecordModel>> listModel = [];

  void _initListModel({List<int> checkedList = const []}) {
    listModel.clear();
    for (int i = 0; i < AppData().listRecord.length; i++) {
      listModel.add(CheckboxModel<RecordModel>(
          model: AppData().listRecord[i], checked: checkedList.contains(i)));
    }
  }

  void _switchMode(bool mode, {List<int> checkedList = const []}) {
    setState(() {
      _initListModel(checkedList: checkedList);
      editMode = mode;
    });
  }

  @override
  void initState() {
    super.initState();

    _initListModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          children: [
            AppBarTitleText(LocalizationString.App_Title),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: BasicText(AppData().currentProfile),
            )
          ],
        ),
        centerTitle: true,
        leading:
            editMode ? BackButton(onPressed: () => _switchMode(false)) : null,
        actions: editMode
            ? [
                BaseIconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BasicDialog(
                        title: TitleText(
                            LocalizationString.Confirm_Delete_Records),
                        successWidget: BasicText(LocalizationString.Confirm),
                        onSuccess: () async {
                          Navigator.pop(context);
                          for (int i = listModel.length - 1; i >= 0; i--) {
                            if (listModel[i].checked) {
                              await Controller().deleteRecord(i);
                            }
                          }
                          _switchMode(false);
                        },
                        onCancel: () => Navigator.pop(context),
                      );
                    },
                  ),
                ),
                BaseIconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _switchMode(false);
                  },
                ),
              ]
            : [
                BaseIconButton(
                  width: 36,
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final textController = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BasicDialog(
                          title: TitleText(LocalizationString.Add_Record),
                          content: RecordEdit(textController: textController),
                          successWidget: BasicText(LocalizationString.Add),
                          onSuccess: () async {
                            Navigator.pop(context);
                            await Controller().addRecord(
                              RecordModel(title: textController.text),
                            );
                            textController.clear();
                            _switchMode(false);
                          },
                          onCancel: () => Navigator.pop(context),
                        );
                      },
                    );
                  },
                ),
                BaseIconButton(
                  width: 36,
                  icon: const Icon(Icons.edit_note),
                  onPressed: () => _switchMode(true),
                ),
                BaseIconButton(
                  width: 36,
                  icon: const Icon(Icons.delete),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BasicDialog(
                        title: TitleText(
                            '${LocalizationString.Confirm_Delete_Profile} ${AppData().currentProfile}'),
                        successWidget: BasicText(LocalizationString.Confirm),
                        onSuccess: () async {
                          Navigator.pop(context);
                          await Controller().removeCurrentProfile();
                          _switchMode(false);
                        },
                        onCancel: () => Navigator.pop(context),
                      );
                    },
                  ),
                ),
                BasicPopupMenu(
                  icon: const Icon(Icons.more_vert),
                  listMenu: [
                    PopupMenuModel(
                      title: LocalizationString.Sort_By_Date_Ascending,
                      icon: MyFlutterIcons.sort_alt_up,
                      handle: () async {
                        await Controller().sortProfile((a, b) {
                          if (a.startDate == null) {
                            return -1;
                          } else if (b.startDate == null) {
                            return 1;
                          } else if (a.startDate!.isBefore(b.startDate!)) {
                            return -1;
                          } else if (a.startDate! == b.startDate!) {
                            return 0;
                          } else {
                            return 1;
                          }
                        });
                        setState(() {});
                      },
                    ),
                    PopupMenuModel(
                      title: LocalizationString.Sort_By_Date_Descending,
                      icon: MyFlutterIcons.sort_alt_down,
                      handle: () async {
                        await Controller().sortProfile((a, b) {
                          if (a.startDate == null) {
                            return 1;
                          } else if (b.startDate == null) {
                            return -1;
                          } else if (a.startDate!.isAfter(b.startDate!)) {
                            return -1;
                          } else if (a.startDate! == b.startDate!) {
                            return 0;
                          } else {
                            return 1;
                          }
                        });
                        setState(() {});
                      },
                    ),
                    PopupMenuModel(
                      title: LocalizationString.Sort_By_Price_Ascending,
                      icon: MyFlutterIcons.sort_number_up,
                      handle: () async {
                        await Controller().sortProfile((a, b) {
                          if (a.getTotalPrice(RecordCategory.expense) <
                              b.getTotalPrice(RecordCategory.expense)) {
                            return -1;
                          } else if (a.getTotalPrice(RecordCategory.expense) ==
                              b.getTotalPrice(RecordCategory.expense)) {
                            return 0;
                          }
                          return 1;
                        });
                        setState(() {});
                      },
                    ),
                    PopupMenuModel(
                      title: LocalizationString.Sort_By_Price_Descending,
                      icon: MyFlutterIcons.sort_number_down,
                      handle: () async {
                        await Controller().sortProfile((a, b) {
                          if (a.getTotalPrice(RecordCategory.expense) >
                              b.getTotalPrice(RecordCategory.expense)) {
                            return -1;
                          } else if (a.getTotalPrice(RecordCategory.expense) ==
                              b.getTotalPrice(RecordCategory.expense)) {
                            return 0;
                          }
                          return 1;
                        });
                        setState(() {});
                      },
                    ),
                    PopupMenuModel(
                      title: LocalizationString.Sort_By_Title_Ascending,
                      icon: MyFlutterIcons.sort_name_up,
                      handle: () async {
                        await Controller()
                            .sortProfile((a, b) => a.title.compareTo(b.title));
                        setState(() {});
                      },
                    ),
                    PopupMenuModel(
                      title: LocalizationString.Sort_By_Title_Descending,
                      icon: MyFlutterIcons.sort_name_down,
                      handle: () async {
                        await Controller()
                            .sortProfile((a, b) => b.title.compareTo(a.title));
                        setState(() {});
                      },
                    ),
                    PopupMenuModel(
                        title: LocalizationString.Import,
                        icon: MyFlutterIcons.file_import,
                        handle: () {
                          final textController = TextEditingController();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BasicDialog(
                                title:
                                    TitleText(LocalizationString.Import_Record),
                                content: TextFormField(
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder()),
                                  controller: textController,
                                  maxLines: 10,
                                ),
                                successWidget:
                                    BasicText(LocalizationString.Import),
                                onSuccess: () async {
                                  Navigator.pop(context);
                                  Controller()
                                      .importListRecordToCurrentProfile(
                                          textController.text)
                                      .then(
                                    (value) {
                                      textController.clear();
                                      _switchMode(false);
                                      Utils.showToast(
                                          context,
                                          LocalizationString
                                              .Import_Successfully);
                                    },
                                    onError: (e) {
                                      textController.clear();
                                      _switchMode(false);
                                      Utils.showToast(context,
                                          '${LocalizationString.Import_Error}: $e');
                                    },
                                  );
                                },
                                onCancel: () => Navigator.pop(context),
                              );
                            },
                          );
                        }),
                    PopupMenuModel(
                      title: LocalizationString.Export_Raw,
                      icon: MyFlutterIcons.file_export,
                      handle: () => Utils.copyToClipboard(Utils.exportProfile(
                              AppData().currentProfile, AppData().listRecord))
                          .then(
                        (value) => Utils.showToast(context,
                            LocalizationString.Copy_To_Clipboard_Successfully),
                        onError: (e) => Utils.showToast(context,
                            '${LocalizationString.Copy_To_Clipboard_Error}: $e'),
                      ),
                    ),
                    // PopupMenuModel(
                    //   title: LocalizationString.Export_Simplified,
                    //   icon: MyFlutterIcons.file_export,
                    //   handle: () => Utils.copyToClipboard(
                    //           Utils.exportProfileCustomString(
                    //               AppData().currentProfile,
                    //               AppData().listOrder))
                    //       .then(
                    //     (value) => Utils.showToast(context,
                    //         LocalizationString.Copy_To_Clipboard_Successfully),
                    //     onError: (e) => Utils.showToast(context,
                    //         '${LocalizationString.Copy_To_Clipboard_Error}: $e'),
                    //   ),
                    // ),
                    // PopupMenuModel(
                    //   title: LocalizationString.Export_Details,
                    //   icon: MyFlutterIcons.file_export,
                    //   handle: () => Utils.copyToClipboard(
                    //           Utils.exportProfileCustomString(
                    //               AppData().currentProfile, AppData().listOrder,
                    //               detail: true))
                    //       .then(
                    //     (value) => Utils.showToast(context,
                    //         LocalizationString.Copy_To_Clipboard_Successfully),
                    //     onError: (e) => Utils.showToast(context,
                    //         '${LocalizationString.Copy_To_Clipboard_Error}: $e'),
                    //   ),
                    // ),
                  ],
                ),
              ],
      ),
      drawer: Drawer(
        child: AppDrawer(
          callback: () {
            _switchMode(false);
            widget.callback?.call();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: editMode
                ? BaseListView(
                    itemCount: listModel.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxRecordTile(
                          model: listModel[index], setState: setState);
                    },
                  )
                : BaseListView(
                    itemCount: AppData().listRecord.length,
                    itemBuilder: (BuildContext context, int index) {
                      return RecordTile(
                        context,
                        index: index,
                        callback: () => _switchMode(false),
                        actionCallback: {
                          PageAction.delete: () async =>
                              await Controller().deleteCurrentRecord(),
                        },
                        onLongPress: () =>
                            _switchMode(true, checkedList: [index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
