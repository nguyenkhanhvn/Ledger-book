import 'package:flutter/material.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/View/Common/CommonMaterial.dart';
import 'package:ledger_book/View/Common/CommonText.dart';

class RecordEdit extends Row {
  RecordEdit({super.key, required final TextEditingController textController})
      : super(
    children: [
      BasicText('${LocalizationString.Record_Title}: '),
      Expanded(
        child: TextField(
          controller: textController,
          style: const BasicTextStyle(),
        ),
      ),
    ],
  );
}
