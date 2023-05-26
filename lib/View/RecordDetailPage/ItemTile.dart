import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/ItemModel.dart';
import 'package:ledger_book/View/Common/CommonText.dart';
import 'package:ledger_book/View/Common/CommonTile.dart';
import 'package:ledger_book/View/ItemDetailPage/ItemDetail.dart';
import 'package:ledger_book/View/PageRouting.dart';

class ItemTile extends TileButton {
  ItemTile(
    BuildContext context, {
    super.key,
    required int index,
    required List<ItemModel> listModel,
    super.onLongPress,
    ValueChanged<List>? callback,
  }) : super(
          child: ListTile(
            title: TitleText(listModel[index].dateTimeString ?? '-'),
            subtitle: SubTitleText(
                listModel[index].title ?? LocalizationString.Error),
            trailing: BasicText(
                '${listModel[index].totalPrice.toString() ?? LocalizationString.Error}${LocalizationString.Currency_Unit}'),
          ),
          onPressed: () {
            Controller().setCurrentItem(index);
            final item = AppData().currentItem!;
            PageRouting.routeWithConditionalValueChangeCallback(
              context,
              builder: (context) => ItemDetail(model: item),
              callback: callback,
              actionCallback: {
                PageAction.save: (returnValue) async {
                  if (returnValue.isNotEmpty) {
                    await Controller()
                        .editCurrentItem(item, toCategory: returnValue[0]);
                  }
                },
                PageAction.delete: (returnValue) async {
                  await Controller().deleteCurrentItem();
                },
              },
            );
          },
        );
}
