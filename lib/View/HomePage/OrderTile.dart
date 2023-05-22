import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Common/Utils.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/View/Common/CommonText.dart';
import 'package:ledger_book/View/Common/CommonTile.dart';
import 'package:ledger_book/View/OrderDetailPage/OrderDetail.dart';
import 'package:ledger_book/View/PageRouting.dart';

class OrderTile extends TileButton {
  OrderTile(
    BuildContext context, {
    super.key,
    required int index,
    super.onLongPress,
    VoidCallback? callback,
    Map<PageAction, VoidCallback>? actionCallback,
  }) : super(
          child: ListTile(
            title: TitleText(
              '${Utils.formatShortDateTime(AppData().listOrder[index].startDate)}'
              ' ${LocalizationString.To} '
              '${Utils.formatShortDateTime(AppData().listOrder[index].endDate)}',
            ),
            subtitle: SubTitleText(AppData().listOrder[index].title),
            trailing: BasicText(
                '${AppData().listOrder[index].totalPrice.toString()}${LocalizationString.Currency_Unit}'),
          ),
          onPressed: () async {
            Controller().setCurrentOrder(index);
            await PageRouting.routeWithCallback(
              context,
              builder: (context) => const OrderDetail(),
              callback: callback,
              actionCallback: actionCallback,
            );
          },
        );
}
