import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Utils.dart';
import 'package:ledger_book/Model/CheckboxModel.dart';
import 'package:ledger_book/Model/ItemModel.dart';
import 'package:ledger_book/View/Common/CommonMaterial.dart';
import 'package:ledger_book/View/Common/CommonText.dart';

class CheckboxItemTile extends Container {
  CheckboxItemTile(
      {super.key,
      required CheckboxModel<ItemModel> model,
      required ValueChanged<VoidCallback> setState})
      : super(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: LightBorderSide(),
              ),
            ),
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: model.checked,
              selected: model.checked,
              title: TitleText(model.model.title),
              subtitle: SubTitleText(
                Utils.formatShortDateTime(model.model.dateTime),
              ),
              onChanged: (value) =>
                  setState(() => model.checked = value ?? false),
            ),
          ),
        );
}
