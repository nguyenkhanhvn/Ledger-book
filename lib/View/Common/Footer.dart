import 'package:flutter/material.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/View/Common/CommonMaterial.dart';
import 'package:ledger_book/View/Common/CommonText.dart';

class PriceFooter extends Container {
  final int value;

  PriceFooter({
    required this.value,
    super.key,
    super.alignment,
    super.padding = const EdgeInsets.all(10),
    super.color,
    super.foregroundDecoration,
    super.width = double.infinity,
    super.height = 50,
    super.constraints,
    super.margin,
    super.transform,
    super.transformAlignment,
    super.clipBehavior,
  }) : super(
          decoration: BoxDecoration(
            border: Border(
              top: BasicBorderSide(width: 2.0),
            ),
          ),
          child: BasicText(
              '${LocalizationString.Total}:     $value${LocalizationString.Currency_Unit}'),
        );
}
