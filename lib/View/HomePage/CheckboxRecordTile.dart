import 'package:flutter/material.dart';
import 'package:ledger_book/View/Model/CheckboxModel.dart';
import 'package:ledger_book/Model/RecordModel.dart';
import 'package:ledger_book/View/Common/CommonMaterial.dart';
import 'package:ledger_book/View/Common/CommonText.dart';

class CheckboxRecordTile extends Container {
  CheckboxRecordTile(
      {super.key,
      required CheckboxModel<RecordModel> model,
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
              subtitle: SubTitleText(model.model.getDateTimeShortString(RecordCategory.expense)),
              onChanged: (value) =>
                  setState(() => model.checked = value ?? false),
            ),
          ),
        );
}
