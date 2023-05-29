import 'package:flutter/material.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/ItemModel.dart';
import 'package:ledger_book/Model/RecordModel.dart';
import 'package:ledger_book/View/Common/CommonListview.dart';
import 'package:ledger_book/View/Common/Footer.dart';
import 'package:ledger_book/View/Model/CheckboxModel.dart';

import 'CheckboxItemTile.dart';
import 'ItemTile.dart';

class RecordDetailContent extends Column {
  RecordDetailContent(
      {super.key,
      required bool editMode,
      required List<CheckboxModel<ItemModel>> listCheckboxModel,
      required RecordCategory modelCategory,
      required ValueChanged<VoidCallback> setState,
      required ValueChanged<bool> switchMode})
      : super(
          children: [
            Expanded(
              child: BaseListView(
                itemCount: editMode
                    ? listCheckboxModel.length
                    : (AppData().currentRecord?.getListItem(modelCategory) ??
                            [])
                        .length,
                itemBuilder: editMode
                    ? (BuildContext context, int index) => CheckboxItemTile(
                        model: listCheckboxModel[index], setState: setState)
                    : (BuildContext context, int index) => ItemTile(
                          context,
                          index: index,
                          listModel: (AppData()
                                  .currentRecord
                                  ?.getListItem(modelCategory) ??
                              []),
                          callback: (value) => switchMode(false),
                          onLongPress: () {
                            if (index >= 0 &&
                                index < listCheckboxModel.length) {
                              listCheckboxModel[index].checked = true;
                              switchMode(true);
                            }
                          },
                        ),
              ),
            ),
            PriceFooter(
              title: _getTotalTitle(modelCategory),
              value:
                  (AppData().currentRecord?.getTotalPrice(modelCategory)) ?? 0,
              number: (AppData().currentRecord?.getListItem(modelCategory).length) ?? 0,
              numberSuffix: LocalizationString.Item,
            ),
          ],
        );
}

String _getTotalTitle(RecordCategory category) {
  switch (category) {
    case RecordCategory.income:
      return LocalizationString.Total_Income;
    case RecordCategory.expense:
      return LocalizationString.Total_Expense;
    default:
      return LocalizationString.Total;
  }
}
