import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/SubItemModel.dart';
import 'package:ledger_book/View/Common/CommonMaterial.dart';
import 'package:ledger_book/View/Common/CommonText.dart';
import 'package:ledger_book/View/Common/SimpleDialog.dart';
import 'package:ledger_book/View/Common/CommonTile.dart';
import 'package:ledger_book/View/ItemDetailPage/SubItemField.dart';
import 'package:ledger_book/View/PageRouting.dart';

import 'SubItemDetail.dart';

class SubItemTile extends TileButton {
  SubItemTile(
    BuildContext context, {
    super.key,
    required final SubItemModel model,
    ValueChanged<SubItemModel>? editModelCallback,
    VoidCallback? deleteModelCallback,
  }) : super(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SubItemFieldView(
                    model: model,
                  ),
                ),
              ),
              BaseIconButton(
                width: 32,
                icon: BasicIcon(Icons.delete),
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BasicDialog(
                      title: TitleText(LocalizationString.Confirm_Delete),
                      successWidget: BasicText(LocalizationString.Confirm),
                      onSuccess: () async {
                        Navigator.pop(context);
                        deleteModelCallback?.call();
                      },
                      onCancel: () => Navigator.pop(context),
                    );
                  },
                ),
              ),
            ],
          ),
          onPressed: () {
            final subItem = SubItemModel.clone(model);
            PageRouting.routeWithConditionalCallback(
              context,
              builder: (context) => SubItemDetail(
                model: subItem,
              ),
              actionCallback: {
                PageAction.save: () => editModelCallback?.call(subItem),
                PageAction.delete: () => deleteModelCallback?.call(),
              },
            );
          },
        );
}

class SubItemFieldTile extends Row {
  SubItemFieldTile(
    BuildContext context, {
    super.key,
    required final SubItemModel model,
    VoidCallback? callback,
  }) : super(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SubItemFieldSimpleEdit(
                  model: model,
                  callback: callback,
                ),
              ),
            ),
            BaseIconButton(
              width: 32,
              icon: BasicIcon(Icons.add_circle),
              onPressed: () {
                callback?.call();
              },
            ),
          ],
        );
}
