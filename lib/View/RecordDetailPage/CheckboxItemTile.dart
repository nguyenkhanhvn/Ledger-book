import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Utils.dart';
import 'package:ledger_book/View/Model/CheckboxModel.dart';
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
              title: TitleText(Utils.formatShortDateTime(model.model.dateTime)),
              subtitle: SubTitleText(model.model.title),
              onChanged: (value) =>
                  setState(() => model.checked = value ?? false),
            ),
          ),
        );
}
