import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/ItemModel.dart';
import 'package:ledger_book/Model/RecordModel.dart';
import 'package:ledger_book/Model/SubItemModel.dart';

class Utils {
  static String recordCategoryString(RecordCategory category) {
    switch (category) {
      case RecordCategory.income:
        return LocalizationString.Income;
      case RecordCategory.expense:
        return LocalizationString.Expense;
      default:
        return LocalizationString.Error;
    }
  }

  static String basicFormatDateTime(DateTime time) {
    return DateFormat("yyyy-MM-dd hh:mm:ss").format(time);
  }

  static String formatDateTime(DateTime? time) {
    if (time == null) return '-';
    return DateFormat(
            'EEEE, dd/MM/yyyy',
            Localization().currentLocaleSymbol != ''
                ? Localization().currentLocaleSymbol
                : 'en')
        .format(time);
  }

  static String formatShortDateTime(DateTime? time) {
    if (time == null) return '-';
    return DateFormat('dd/MM/yyyy', Localization().currentLocaleSymbol != ''
        ? Localization().currentLocaleSymbol
        : 'en').format(time);
  }

  static Future<void> copyToClipboard(String str) async {
    await Clipboard.setData(ClipboardData(text: str));
  }

  static Future<void> showToast(BuildContext context, String str) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(str),
    ));
  }

  static String exportProfile(String profile, List<RecordModel> listRecord) {
    List<Map<String, dynamic>> jsonListRecord = [];
    for (var record in listRecord) {
      jsonListRecord.add(record.toJson());
    }
    return json.encode({'profile': profile, 'listRecord': jsonListRecord});
  }

  static String exportProfileString(String profile, List<RecordModel> listRecord,
      {String initParser = '',
      int level = 0,
      showList = true,
      bool detail = false}) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Profile_Title}: $profile\n';
    if (showList) {
      level++;
      for (var element in listRecord) {
        initParser = exportRecordString(element,
            initParser: initParser,
            level: level,
            showList: detail ? showList : false,
            detail: detail);
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${AppDefine.SeparatorLineCharacter * (AppDefine.SeparatorLineLength + AppDefine.TabLength * 6)}\n';
      }
      level--;
    }
    return initParser;
  }

  static String exportRecordString(RecordModel record,
      {String initParser = '',
      int level = 0,
      bool showList = true,
      bool detail = false}) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Date_Time}: ${detail ? record.getDateTimeString(RecordCategory.expense) : record.getDateTimeShortString(RecordCategory.expense)}\n';
    if (record.title.isNotEmpty) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Record_Title}: ${record.title}\n';
    }
    if (record.getListItem(RecordCategory.expense).isNotEmpty) {
      if (showList) {
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Item}:\n';
        level++;
        for (var element in record.getListItem(RecordCategory.expense)) {
          initParser = exportItemString(element,
              initParser: initParser,
              level: level,
              showList: detail ? showList : false,
              detail: detail);
          initParser =
              '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${AppDefine.SeparatorLineCharacter * (AppDefine.SeparatorLineLength + AppDefine.TabLength * 4)}\n';
        }
        level--;
      }
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Total}: ${record.getTotalPrice(RecordCategory.expense)}${LocalizationString.Currency_Unit}\n';
    }
    return initParser;
  }

  static String exportItemString(ItemModel item,
      {String initParser = '',
      int level = 0,
      bool showList = true,
      bool detail = false}) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Date_Time}: ${detail ? item.dateTimeString : item.dateTimeString}\n';
    if (item.title.isNotEmpty) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Title}: ${item.title}\n';
    }
    if (item.price != 0) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Price}: ${item.price}${LocalizationString.Currency_Unit}\n';
    }
    if (item.listSubItem.isNotEmpty) {
      if (showList) {
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Sub_Item}:\n';
        level++;
        for (var element in item.listSubItem) {
          initParser = exportSubItemString(element,
              initParser: initParser,
              level: level,
              showList: detail ? showList : false,
              detail: detail);
          initParser =
              '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${AppDefine.SeparatorLineCharacter * (AppDefine.SeparatorLineLength + AppDefine.TabLength * 2)}\n';
        }
        level--;
      }
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Total}: ${item.totalPrice}${LocalizationString.Currency_Unit}\n';
    }
    return initParser;
  }

  static String exportSubItemString(SubItemModel subItem,
      {String initParser = '',
      int level = 0,
      bool showList = true,
      bool detail = false}) {
    if (subItem.title.isNotEmpty) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Title}: ${subItem.title}\n';
    }
    if (subItem.price != 0) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Price}: ${subItem.price}${LocalizationString.Currency_Unit}\n';
    }
    if (subItem.listSubItem.isNotEmpty) {
      if (showList) {
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Sub_Item}:\n';
        level++;
        for (var element in subItem.listSubItem) {
          initParser = exportSubItemString(element,
              initParser: initParser,
              level: level,
              showList: detail ? showList : false,
              detail: detail);
          initParser =
              '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${AppDefine.SeparatorLineCharacter * AppDefine.SeparatorLineLength}\n';
        }
        level--;
      }
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Total}: ${subItem.totalPrice}${LocalizationString.Currency_Unit}\n';
    }
    return initParser;
  }

  // static String exportProfileCustomString(
  //     String profile, List<RecordModel> listRecord,
  //     {String initParser = '',
  //     int level = 0,
  //     showList = true,
  //     bool detail = false}) {
  //   initParser =
  //       '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Profile_Title}: $profile\n';
  //   if (showList) {
  //     level++;
  //     for (var element in listRecord) {
  //       initParser = exportRecordCustomString(element,
  //           initParser: initParser,
  //           level: level,
  //           showList: detail ? showList : false,
  //           detail: detail);
  //       initParser =
  //           '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${AppDefine.SeparatorLineCharacter * (AppDefine.SeparatorLineLength + AppDefine.TabLength * 6)}\n';
  //     }
  //     level--;
  //   }
  //   return initParser;
  // }
  //
  // static String exportRecordCustomString(RecordModel record,
  //     {String initParser = '',
  //     int level = 0,
  //     bool showList = true,
  //     bool detail = false}) {
  //   initParser =
  //       '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Date_Time}: ${detail ? record.getDateTimeString(RecordCategory.expense) : record.getDateTimeShortString(RecordCategory.expense)}\n';
  //   if (record.title.isNotEmpty) {
  //     initParser =
  //         '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Record_Title}: ${record.title}\n';
  //   }
  //   if (record.getListItem(RecordCategory.expense).isNotEmpty) {
  //     if (showList) {
  //       initParser =
  //           '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Item}:\n';
  //       level++;
  //       for (var element in record.getListItem(RecordCategory.expense)) {
  //         initParser = exportItemCustomString(element,
  //             initParser: initParser,
  //             level: level,
  //             showList: detail ? showList : false,
  //             detail: detail);
  //         initParser =
  //             '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${AppDefine.SeparatorLineCharacter * (AppDefine.SeparatorLineLength + AppDefine.TabLength * 4)}\n';
  //       }
  //       level--;
  //     }
  //     initParser =
  //         '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Total}: ${record.getTotalPrice(RecordCategory.expense)}${LocalizationString.Currency_Unit}\n';
  //   }
  //   return initParser;
  // }
  //
  // static String exportItemCustomString(ItemModel item,
  //     {String initParser = '',
  //     int level = 0,
  //     bool showList = true,
  //     bool detail = false}) {
  //   bool customType = false;
  //   if (item.title.isEmpty && item.price == 0 && item.listSubItem.isNotEmpty) {
  //     customType = true;
  //   }
  //   initParser =
  //       '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Date_Time}: ${detail ? item.dateTimeString : item.dateTimeString}\n';
  //   if (item.title.isNotEmpty) {
  //     initParser =
  //         '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Title}: ${item.title}\n';
  //   }
  //   if (item.price != 0) {
  //     initParser =
  //         '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Price}: ${item.price}${LocalizationString.Currency_Unit}\n';
  //   }
  //   if (item.listSubItem.isNotEmpty) {
  //     if (showList) {
  //       initParser =
  //           '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Sub_Item}:\n';
  //       level++;
  //       for (var element in item.listSubItem) {
  //         initParser = exportSubItemCustomString(element,
  //             initParser: initParser,
  //             level: level,
  //             showList: detail ? showList : false,
  //             detail: detail);
  //         if (!customType) {
  //           initParser =
  //               '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${AppDefine.SeparatorLineCharacter * (AppDefine.SeparatorLineLength + AppDefine.TabLength * 2)}\n';
  //         }
  //       }
  //       level--;
  //     }
  //     initParser =
  //         '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Total}: ${item.totalPrice}${LocalizationString.Currency_Unit}\n';
  //   }
  //   return initParser;
  // }
  //
  // static String exportSubItemCustomString(SubItemModel subItem,
  //     {String initParser = '',
  //     int level = 0,
  //     bool showList = true,
  //     bool detail = false}) {
  //   if (subItem.title.isNotEmpty && subItem.price != 0) {
  //     initParser =
  //         '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${subItem.title}: ${subItem.price}${LocalizationString.Currency_Unit}\n';
  //   } else {
  //     if (subItem.title.isNotEmpty) {
  //       initParser =
  //           '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Title}: ${subItem.title}\n';
  //     }
  //     if (subItem.price != 0) {
  //       initParser =
  //           '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Price}: ${subItem.price}${LocalizationString.Currency_Unit}\n';
  //     }
  //   }
  //   if (subItem.listSubItem.isNotEmpty) {
  //     if (showList) {
  //       initParser =
  //           '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Sub_Item}:\n';
  //       level++;
  //       for (var element in subItem.listSubItem) {
  //         initParser = exportSubItemCustomString(element,
  //             initParser: initParser,
  //             level: level,
  //             showList: detail ? showList : false,
  //             detail: detail);
  //         initParser =
  //             '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${AppDefine.SeparatorLineCharacter * AppDefine.SeparatorLineLength}\n';
  //       }
  //       level--;
  //     }
  //     initParser =
  //         '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Total}: ${subItem.totalPrice}${LocalizationString.Currency_Unit}\n';
  //   }
  //   return initParser;
  // }
}
