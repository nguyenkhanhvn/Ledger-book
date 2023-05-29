import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/RecordModel.dart';

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
    return DateFormat(
            'dd/MM/yyyy',
            Localization().currentLocaleSymbol != ''
                ? Localization().currentLocaleSymbol
                : 'en')
        .format(time);
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

  static String exportListProfile(List<String> listProfile, List<List<RecordModel>> listRecord) {
    if(listProfile.length != listRecord.length) return '';
    List<Map<String, dynamic>> jsonData = [];
    for(int i = 0; i<listProfile.length; i++) {
      List<Map<String, dynamic>> jsonListRecord = [];
      for (var record in listRecord[i]) {
        jsonListRecord.add(record.toJson());
      }
      jsonData.add({'profile': listProfile[i], 'listRecord': jsonListRecord});
    }
    return json.encode(jsonData);
  }
}
