import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/RecordModel.dart';
import 'package:ledger_book/View/Common/CommonText.dart';
import 'package:ledger_book/View/Common/CommonTile.dart';
import 'package:ledger_book/View/RecordDetailPage/RecordDetail.dart';
import 'package:ledger_book/View/PageRouting.dart';

class RecordTile extends TileButton {
  RecordTile(
    BuildContext context, {
    super.key,
    required int index,
    super.onLongPress,
    VoidCallback? callback,
    Map<PageAction, VoidCallback>? actionCallback,
  }) : super(
          child: ListTile(
            title: TitleText(AppData().listRecord[index].getDateTimeShortString(RecordCategory.expense)),
            subtitle: SubTitleText(AppData().listRecord[index].title),
            trailing: BasicText(
                '${AppData().listRecord[index].getTotalPrice(RecordCategory.expense).toString()}${LocalizationString.Currency_Unit}'),
          ),
          onPressed: () async {
            Controller().setCurrentRecord(index);
            await PageRouting.routeWithCallback(
              context,
              builder: (context) => const RecordDetail(),
              callback: callback,
              actionCallback: actionCallback,
            );
          },
        );
}
