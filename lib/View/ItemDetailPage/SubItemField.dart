import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/SubItemModel.dart';
import 'package:ledger_book/View/Common/CommonMaterial.dart';
import 'package:ledger_book/View/Common/CommonText.dart';

class SubItemFieldView extends Row {
  SubItemFieldView({super.key, required final SubItemModel model})
      : super(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: BasicText(model.title),
              ),
            ),
            BasicText(
                '${model.totalPrice.toString()}${LocalizationString.Currency_Unit}'),
          ],
        );
}

class SubItemFieldEdit extends Column {
  SubItemFieldEdit({
    super.key,
    required final SubItemModel model,
    required ValueChanged<VoidCallback> setParentState,
    TextStyle? style = const BasicTextStyle(),
  }) : super(
          children: [
            Row(
              children: [
                BasicText('${LocalizationString.Title}:     '),
                Expanded(
                  child: TextFormField(
                    initialValue: model.title,
                    style: style,
                    onChanged: (value) =>
                        setParentState(() => model.title = value),
                    textInputAction: TextInputAction.next,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                BasicText('${LocalizationString.Price}:    '),
                Expanded(
                  child: TextFormField(
                    initialValue:
                        model.price != 0 ? model.price.toString() : '',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("^-?\\d*")),
                    ],
                    style: style,
                    onChanged: (value) => setParentState(
                        () => model.price = int.tryParse(value) ?? 0),
                    textInputAction: TextInputAction.done,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                  ),
                ),
                BasicText(LocalizationString.Currency_Unit)
              ],
            ),
          ],
        );
}

class SubItemFieldSimpleEdit extends Row {
  SubItemFieldSimpleEdit({
    super.key,
    required final SubItemModel model,
    TextStyle? style = const BasicTextStyle(),
    VoidCallback? callback,
  }) : super(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: model.title,
                style: style,
                onChanged: (value) => model.title = value,
                textInputAction: TextInputAction.next,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              width: 50,
              child: TextFormField(
                initialValue: model.price > 0 ? model.price.toString() : '',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("^-?\\d*")),
                ],
                style: style,
                onChanged: (value) => model.price = int.tryParse(value) ?? 0,
                onEditingComplete: () => callback?.call(),
                textInputAction: TextInputAction.done,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
              ),
            ),
            BasicText(LocalizationString.Currency_Unit),
          ],
        );
}
