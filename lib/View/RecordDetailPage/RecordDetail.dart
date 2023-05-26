import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Common/Utils.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/View/Common/BaseTabBar.dart';
import 'package:ledger_book/View/Common/BasicPopupMenu.dart';
import 'package:ledger_book/View/Model/CheckboxModel.dart';
import 'package:ledger_book/Model/ItemModel.dart';
import 'package:ledger_book/Model/RecordModel.dart';
import 'package:ledger_book/View/Common/CommonMaterial.dart';
import 'package:ledger_book/View/Common/CommonText.dart';
import 'package:ledger_book/View/Common/Footer.dart';
import 'package:ledger_book/View/Common/SimpleDialog.dart';
import 'package:ledger_book/View/Common/MyFlutterIcons.dart';
import 'package:ledger_book/View/ItemDetailPage/ItemDetail.dart';
import 'package:ledger_book/View/Model/PopupMenuModel.dart';
import 'package:ledger_book/View/RecordDetailPage/RecordDetailContent.dart';
import 'package:ledger_book/View/PageRouting.dart';

class RecordDetail extends StatefulWidget {
  const RecordDetail({super.key});

  @override
  State<RecordDetail> createState() => _RecordDetailState();
}

class _RecordDetailState extends State<RecordDetail>
    with SingleTickerProviderStateMixin {
  bool editMode = false;
  final Map<RecordCategory, List<CheckboxModel<ItemModel>>> checkboxModel = {};
  late TabController _tabController;

  void _initListModel() {
    for (RecordCategory recordCategory in RecordCategory.values) {
      checkboxModel[recordCategory] = [];
      if (AppData().currentRecord == null) return;
      for (int i = 0;
          i < AppData().currentRecord!.getListItem(recordCategory).length;
          i++) {
        checkboxModel[recordCategory]!.add(CheckboxModel<ItemModel>(
            model: AppData().currentRecord!.getListItem(recordCategory)[i],
            checked: false));
      }
    }
  }

  void _switchMode(bool mode) {
    setState(() {
      editMode = mode;
      if (!mode) {
        _initListModel();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _initListModel();

    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() async {
      if (!_tabController.indexIsChanging) {
        switch (_tabController.index) {
          case 0:
            Controller().setCurrentRecordCategory(RecordCategory.income);
            break;
          case 1:
            Controller().setCurrentRecordCategory(RecordCategory.expense);
            break;
          case 2:
            break;
        }
      }
    });

    _tabController.index = 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: editMode
              ? TextFormField(
                  decoration: const InputDecoration(border: InputBorder.none),
                  initialValue: AppData().currentRecord?.title ?? '',
                  style: AppBarTitleTextStyle(
                    color: Theme.of(context).primaryTextTheme.bodyLarge?.color,
                  ),
                  cursorColor:
                      Theme.of(context).primaryTextTheme.bodyLarge?.color,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    RecordModel newModel =
                        AppData().currentRecord ?? RecordModel();
                    newModel.title = value;
                    Controller().editRecord(newModel);
                  },
                )
              : AppBarTitleText(
                  AppData().currentRecord?.title ?? LocalizationString.Error),
        ),
        leading: BackButton(
          onPressed: editMode
              ? () => _switchMode(false)
              : () => Navigator.pop(context),
        ),
        actions: editMode
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BasicDialog(
                        title:
                            TitleText(LocalizationString.Confirm_Delete_Items),
                        successWidget: BasicText(LocalizationString.Confirm),
                        onSuccess: () async {
                          Navigator.pop(context);
                          checkboxModel.forEach((category, listCheckBox) {
                            for (int index = listCheckBox.length - 1;
                                index >= 0;
                                index--) {
                              if (listCheckBox[index].checked) {
                                Controller().deleteItem(category, index);
                              }
                            }
                          });

                          _switchMode(false);
                        },
                        onCancel: () => Navigator.pop(context),
                      );
                    },
                  ),
                ),
                IconButton(
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
                    final newModel = ItemModel();
                    PageRouting.routeWithConditionalValueChangeCallback(
                      context,
                      builder: (context) => ItemDetail(model: newModel),
                      actionCallback: {
                        PageAction.save: (returnValue) async {
                          if (returnValue.isNotEmpty) {
                            await Controller()
                                .addItem(returnValue[0], newModel);
                          }
                          _switchMode(false);
                        },
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
                        title:
                            TitleText(LocalizationString.Confirm_Delete_Record),
                        successWidget: BasicText(LocalizationString.Confirm),
                        onSuccess: () async {
                          Navigator.pop(context);
                          Navigator.pop(context, PageAction.delete);
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
                        await Controller().sortCurrentRecord((a, b) {
                          if (a.dateTime.isBefore(b.dateTime)) {
                            return -1;
                          } else if (a.dateTime == b.dateTime) {
                            return 0;
                          }
                          return 1;
                        });
                        setState(() {});
                      },
                    ),
                    PopupMenuModel(
                      title: LocalizationString.Sort_By_Date_Descending,
                      icon: MyFlutterIcons.sort_alt_down,
                      handle: () async {
                        await Controller().sortCurrentRecord((a, b) {
                          if (a.dateTime.isAfter(b.dateTime)) {
                            return -1;
                          } else if (a.dateTime == b.dateTime) {
                            return 0;
                          }
                          return 1;
                        });
                        setState(() {});
                      },
                    ),
                    PopupMenuModel(
                      title: LocalizationString.Sort_By_Price_Ascending,
                      icon: MyFlutterIcons.sort_number_up,
                      handle: () async {
                        await Controller().sortCurrentRecord((a, b) {
                          if (a.totalPrice < b.totalPrice) {
                            return -1;
                          } else if (a.totalPrice == b.totalPrice) {
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
                        await Controller().sortCurrentRecord((a, b) {
                          if (a.totalPrice > b.totalPrice) {
                            return -1;
                          } else if (a.totalPrice == b.totalPrice) {
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
                        await Controller().sortCurrentRecord(
                            (a, b) => a.title.compareTo(b.title));
                        setState(() {});
                      },
                    ),
                    PopupMenuModel(
                      title: LocalizationString.Sort_By_Title_Descending,
                      icon: MyFlutterIcons.sort_name_down,
                      handle: () async {
                        await Controller().sortCurrentRecord(
                            (a, b) => b.title.compareTo(a.title));
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
                                    TitleText(LocalizationString.Import_Item),
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
                                      .importListItemToCurrentRecord(
                                          textController.text)
                                      .then(
                                    (success) {
                                      textController.clear();
                                      _switchMode(false);
                                      if (success) {
                                        setState(() {});
                                        Utils.showToast(
                                            context,
                                            LocalizationString
                                                .Import_Successfully);
                                      } else {
                                        Utils.showToast(context,
                                            LocalizationString.Import_Error);
                                      }
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
                      handle: () => Utils.copyToClipboard(
                              (AppData().currentRecord ?? RecordModel())
                                  .toJsonString())
                          .then(
                        (value) => Utils.showToast(context,
                            LocalizationString.Copy_To_Clipboard_Successfully),
                        onError: (e) => Utils.showToast(context,
                            '${LocalizationString.Copy_To_Clipboard_Error}: $e'),
                      ),
                    ),
                    PopupMenuModel(
                      title: LocalizationString.Export_Simplified,
                      icon: MyFlutterIcons.file_export,
                      handle: () => Utils.copyToClipboard(
                              Utils.exportRecordString(
                                  AppData().currentRecord ?? RecordModel()))
                          .then(
                        (value) => Utils.showToast(context,
                            LocalizationString.Copy_To_Clipboard_Successfully),
                        onError: (e) => Utils.showToast(context,
                            '${LocalizationString.Copy_To_Clipboard_Error}: $e'),
                      ),
                    ),
                    PopupMenuModel(
                      title: LocalizationString.Export_Details,
                      icon: MyFlutterIcons.file_export,
                      handle: () => Utils.copyToClipboard(
                              Utils.exportRecordString(
                                  AppData().currentRecord ?? RecordModel(),
                                  detail: true))
                          .then(
                        (value) => Utils.showToast(context,
                            LocalizationString.Copy_To_Clipboard_Successfully),
                        onError: (e) => Utils.showToast(context,
                            '${LocalizationString.Copy_To_Clipboard_Error}: $e'),
                      ),
                    ),
                  ],
                ),
              ],
      ),
      body: Column(
        children: [
          BaseTabBar(
            controller: _tabController,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
            children: [
              Align(
                alignment: Alignment.center,
                child: BasicText(LocalizationString.Income),
              ),
              Align(
                alignment: Alignment.center,
                child: BasicText(LocalizationString.Expense),
              ),
              Align(
                alignment: Alignment.center,
                child: BasicText(LocalizationString.Summary),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                RecordDetailContent(
                  editMode: editMode,
                  listCheckboxModel: checkboxModel[RecordCategory.income] ?? [],
                  listModel: AppData()
                          .currentRecord
                          ?.getListItem(RecordCategory.income) ??
                      [],
                  setState: setState,
                  switchMode: _switchMode,
                ),
                RecordDetailContent(
                  editMode: editMode,
                  listCheckboxModel:
                      checkboxModel[RecordCategory.expense] ?? [],
                  listModel: AppData()
                          .currentRecord
                          ?.getListItem(RecordCategory.expense) ??
                      [],
                  setState: setState,
                  switchMode: _switchMode,
                ),
                Center(child: Text(3.toString()))
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: PriceFooter(
        value: AppData()
                .currentRecord
                ?.getTotalPrice(AppData().currentRecordCategory) ??
            0,
      ),
    );
  }
}
