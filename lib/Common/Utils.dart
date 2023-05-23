import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/ItemModel.dart';
import 'package:ledger_book/Model/OrderModel.dart';
import 'package:ledger_book/Model/SubItemModel.dart';

class Utils {

  static String basicFormatDateTime(DateTime time) {
    return DateFormat("yyyy-MM-dd hh:mm:ss").format(time);
  }

  static String formatDateTime(DateTime? time) {
    if (time == null) return '-';
    return DateFormat('EEEE, dd/MM/yyyy', 'vi').format(time);
  }

  static String formatShortDateTime(DateTime? time) {
    if (time == null) return '-';
    return DateFormat('dd/MM/yyyy', 'vi').format(time);
  }

  static Future<void> copyToClipboard(String str) async {
    await Clipboard.setData(ClipboardData(text: str));
  }

  static Future<void> showToast(BuildContext context, String str) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
      content: Text(str),
    ));
  }

  static String exportProfileString(String profile, List<OrderModel> listOrder,
      {String initParser = '', int level = 0, bool detail = false}) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Profile_Title}: $profile\n';
    level++;
    for (var element in listOrder) {
      initParser = exportOrderString(element,
          initParser: initParser, level: level, detail: detail);
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${AppDefine.SeparatorLineCharacter * (AppDefine.SeparatorLineLength + AppDefine.TabLength * 6)}\n';
    }
    return '';
  }

  static String exportOrderString(OrderModel order,
      {String initParser = '', int level = 0, bool detail = false}) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Order_Title}: ${order.title}\n'
        '${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Total}: ${order.totalPrice}${LocalizationString.Currency_Unit}\n';
    if (detail) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Item}:\n';
      level++;
      for (var element in order.listItem) {
        initParser = exportItemString(element,
            initParser: initParser, level: level, detail: detail);
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${AppDefine.SeparatorLineCharacter * (AppDefine.SeparatorLineLength + AppDefine.TabLength * 4)}\n';
      }
    }
    return initParser;
  }

  static String exportItemString(ItemModel item,
      {String initParser = '', int level = 0, bool detail = false}) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Date_Time}: ${item.dateTime}\n'
        '${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Title}: ${item.title}\n';
    if (item.price != 0) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Price}: ${item.price}${LocalizationString.Currency_Unit}\n';
    }
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Total}: ${item.totalPrice}${LocalizationString.Currency_Unit}\n';
    if (detail && item.listSubItem.isNotEmpty) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Sub_Item}:\n';
      level++;
      for (var element in item.listSubItem) {
        initParser = exportSubItemString(element,
            initParser: initParser, level: level, detail: detail);
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${AppDefine.SeparatorLineCharacter * (AppDefine.SeparatorLineLength + AppDefine.TabLength * 2)}\n';
      }
    }
    return initParser;
  }

  static String exportSubItemString(SubItemModel subItem,
      {String initParser = '', int level = 0, bool detail = false}) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Title}: ${subItem.title}\n';
    if (subItem.price != 0) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Price}: ${subItem.price}${LocalizationString.Currency_Unit}\n';
    }
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Total}: ${subItem.totalPrice}${LocalizationString.Currency_Unit}\n';
    if (detail && subItem.listSubItem.isNotEmpty) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Sub_Item}:\n';
      level++;
      for (var element in subItem.listSubItem) {
        initParser = exportSubItemString(element,
            initParser: initParser, level: level, detail: detail);
        initParser =
            '$initParser\n${AppDefine.TabCharacter * AppDefine.TabLength * level}${AppDefine.SeparatorLineCharacter * AppDefine.SeparatorLineLength}\n';
      }
    }
    return initParser;
  }
}
