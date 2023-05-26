import 'package:flutter/material.dart';
import 'package:ledger_book/Model/ItemModel.dart';
import 'package:ledger_book/View/Common/CommonListview.dart';
import 'package:ledger_book/View/Model/CheckboxModel.dart';

import 'CheckboxItemTile.dart';
import 'ItemTile.dart';

class RecordDetailContent extends BaseListView {
  RecordDetailContent(
      {super.key,
      required bool editMode,
      required List<CheckboxModel<ItemModel>> listCheckboxModel,
      required List<ItemModel> listModel,
      required ValueChanged<VoidCallback> setState,
      required ValueChanged<bool> switchMode})
      : super(
          itemCount: editMode ? listCheckboxModel.length : listModel.length,
          itemBuilder: editMode
              ? (BuildContext context, int index) {
                  return CheckboxItemTile(
                      model: listCheckboxModel[index], setState: setState);
                }
              : (BuildContext context, int index) {
                  return ItemTile(
                    context,
                    index: index,
                    listModel: listModel,
                    callback: (value) => switchMode(false),
                    onLongPress: () {
                      if (index >= 0 && index < listCheckboxModel.length) {
                        listCheckboxModel[index].checked = true;
                        switchMode(true);
                      }
                    },
                  );
                },
        );
}
