import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/CheckboxModel.dart';
import 'package:ledger_book/Model/OrderModel.dart';
import 'package:ledger_book/View/Common/CommonListview.dart';
import 'package:ledger_book/View/Common/CommonMaterial.dart';
import 'package:ledger_book/View/Common/CommonText.dart';
import 'package:ledger_book/View/Common/Footer.dart';
import 'package:ledger_book/View/Common/SimpleDialog.dart';
import 'package:ledger_book/View/HomePage/CheckboxOrderTile.dart';
import 'package:ledger_book/View/HomePage/Drawer.dart';
import 'package:ledger_book/View/HomePage/OrderEdit.dart';

import 'OrderTile.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? callback;

  const HomePage({super.key, this.callback});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool editMode = false;
  final List<CheckboxModel<OrderModel>> listModel = [];

  void _initListModel({List<int> checkedList = const []}) {
    listModel.clear();
    for (int i = 0; i < AppData().listOrder.length; i++) {
      listModel.add(CheckboxModel<OrderModel>(
          model: AppData().listOrder[i], checked: checkedList.contains(i)));
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
        actions: editMode
            ? [
                BaseIconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BasicDialog(
                        title:
                            TitleText(LocalizationString.Confirm_Delete_Orders),
                        successWidget: BasicText(LocalizationString.Confirm),
                        onSuccess: () async {
                          Navigator.pop(context);
                          for (int i = 0; i < listModel.length; i++) {
                            if (listModel[i].checked) {
                              await Controller().deleteOrder(i);
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
                          title: TitleText(LocalizationString.Add_Order),
                          scrollable: true,
                          content: OrderEdit(textController: textController),
                          successWidget: BasicText(LocalizationString.Add),
                          onSuccess: () async {
                            Navigator.pop(context);
                            await Controller().addOrder(
                              OrderModel(title: textController.text),
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
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: BaseIconButton(
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
                      return CheckboxOrderTile(
                          model: listModel[index], setState: setState);
                    },
                  )
                : BaseListView(
                    itemCount: AppData().listOrder.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderTile(
                        context,
                        index: index,
                        callback: () => _switchMode(false),
                        actionCallback: {
                          PageAction.delete: () async =>
                              await Controller().deleteCurrentOrder(),
                        },
                        onLongPress: () => _switchMode(true, checkedList: [index]),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: PriceFooter(
        value: AppData().totalPrice,
      ),
    );
  }
}
