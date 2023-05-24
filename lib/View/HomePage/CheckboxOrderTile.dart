import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Utils.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/View/Model/CheckboxModel.dart';
import 'package:ledger_book/Model/OrderModel.dart';
import 'package:ledger_book/View/Common/CommonMaterial.dart';
import 'package:ledger_book/View/Common/CommonText.dart';

class CheckboxOrderTile extends Container {
  CheckboxOrderTile(
      {super.key,
      required CheckboxModel<OrderModel> model,
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
              subtitle: SubTitleText(model.model.dateTimeShortString),
              onChanged: (value) =>
                  setState(() => model.checked = value ?? false),
            ),
          ),
        );
}
