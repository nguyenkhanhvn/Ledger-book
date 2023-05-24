import 'package:flutter/material.dart';
import 'package:ledger_book/View/Model/PopupMenuModel.dart';

import 'CommonMaterial.dart';
import 'CommonText.dart';

class BasicPopupMenu extends PopupMenuButton<PopupMenuModel> {
  BasicPopupMenu({
    super.key,
    required List<PopupMenuModel> listMenu,
    super.icon,
  }) : super(
          itemBuilder: (BuildContext context) => listMenu
              .map((option) => PopupMenuItem<PopupMenuModel>(
                    value: option,
                    child: Row(
                      children: [
                        Expanded(child: BasicText(option.title)),
                        BasicIcon(option.icon),
                      ],
                    ),
                  ))
              .toList(),
          onSelected: (choice) {
            choice.handle?.call();
            },
        );
}
