import 'package:flutter/material.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/View/Common/CommonText.dart';

class BasicDialog extends AlertDialog {
  BasicDialog({
    super.key,
    super.title,
    super.titleTextStyle,
    super.titlePadding,
    super.scrollable = true,
    super.content,
    required Widget successWidget,
    VoidCallback? onSuccess,
    Widget? cancelWidget,
    VoidCallback? onCancel,
  }) : super(actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
            onPressed: onSuccess,
            child: successWidget,
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: const StadiumBorder(),
            ),
            onPressed: onCancel,
            child: cancelWidget??BasicText(LocalizationString.Cancel),
          ),
        ]);
}
