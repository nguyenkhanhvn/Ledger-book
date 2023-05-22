import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Common/Utils.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/View/Common/CommonText.dart';
import 'package:ledger_book/View/Common/CommonTile.dart';
import 'package:ledger_book/View/ItemDetailPage/ItemDetail.dart';
import 'package:ledger_book/View/PageRouting.dart';

class ItemTile extends TileButton {
  ItemTile(
    BuildContext context, {
    super.key,
    required int index,
    super.onLongPress,
    VoidCallback? callback,
  }) : super(
          child: ListTile(
            title: TitleText(Utils.formatDateTime(
                AppData().currentOrder?.listItem[index].dateTime)),
            subtitle: SubTitleText(
                AppData().currentOrder?.listItem[index].data.title ??
                    LocalizationString.Error),
            trailing: BasicText(
                '${AppData().currentOrder?.listItem[index].totalPrice.toString() ?? LocalizationString.Error}${LocalizationString.Currency_Unit}'),
          ),
          onPressed: () {
            Controller().setCurrentItem(index);
            final item = AppData().currentItem!;
            PageRouting.routeWithConditionalCallback(
              context,
              builder: (context) => ItemDetail(model: item),
              callback: callback,
              actionCallback: {
                PageAction.save: () async => await Controller().editItem(item),
                PageAction.delete: () async =>
                    await Controller().deleteCurrentItem(),
              },
            );
          },
        );
}
