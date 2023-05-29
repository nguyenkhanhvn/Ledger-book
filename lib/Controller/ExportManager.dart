import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/ItemModel.dart';
import 'package:ledger_book/Model/RecordModel.dart';
import 'package:ledger_book/Model/SubItemModel.dart';

import '../Common/Define.dart';

abstract class ExportManager {
  String exportProfileString(
    final String profile,
    final List<RecordModel> listRecord, {
    String initParser = '',
    int level = 0,
    final showList = true,
    final bool detail = false,
  });

  String exportRecordString(
    final RecordModel record, {
    String initParser = '',
    int level = 0,
    final bool showList = true,
    final bool detail = false,
  });

  String exportItemString(
    final ItemModel item, {
    String initParser = '',
    int level = 0,
    final bool showList = true,
    final bool detail = false,
  });

  String exportSubItemString(
    final SubItemModel subItem, {
    String initParser = '',
    int level = 0,
    final bool showList = true,
    final bool detail = false,
  });
}

class ExportManagerDefault implements ExportManager {
  @override
  String exportProfileString(
      final String profile, final List<RecordModel> listRecord,
      {String initParser = '',
      int level = 0,
      final showList = true,
      bool detail = false}) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Profile_Name}: $profile\n';
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
    detail = true;
    return initParser;
  }

  @override
  String exportRecordString(
    final RecordModel record, {
    String initParser = '',
    int level = 0,
    final bool showList = true,
    final bool detail = false,
  }) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Date_Time}: ${detail ? record.dateTimeString : record.dateTimeShortString}\n';
    if (record.title.isNotEmpty) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Record_Title}: ${record.title}\n';
    }

    for (RecordCategory category in RecordCategory.values) {
      String categoryTitle;
      String categoryTotal;
      switch (category) {
        case RecordCategory.income:
          categoryTitle = LocalizationString.Income;
          categoryTotal = LocalizationString.Total_Income;
          break;
        case RecordCategory.expense:
          categoryTitle = LocalizationString.Expense;
          categoryTotal = LocalizationString.Total_Expense;
          break;
        default:
          categoryTitle = LocalizationString.Title;
          categoryTotal = LocalizationString.Total;
          break;
      }
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}$categoryTitle:\n';

      level++;
      if (showList) {
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Item}:\n';
        level++;
        for (var element in record.getListItem(category)) {
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
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}$categoryTotal: ${record.getTotalPrice(category)}${LocalizationString.Currency_Unit}\n';
      level--;
    }
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Income} - ${LocalizationString.Expense} = ${record.getTotalPrice(RecordCategory.income) - record.getTotalPrice(RecordCategory.expense)}${LocalizationString.Currency_Unit}\n';
    return initParser;
  }

  @override
  String exportItemString(ItemModel item,
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
    if (item.price == 0 || item.listSubItem.isNotEmpty) {
      if (item.listSubItem.isNotEmpty && showList) {
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

  @override
  String exportSubItemString(SubItemModel subItem,
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
    if (subItem.price == 0 || subItem.listSubItem.isNotEmpty) {
      if (subItem.listSubItem.isNotEmpty && showList) {
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
}

class ExportManagerCustom implements ExportManager {
  @override
  String exportProfileString(String profile, List<RecordModel> listRecord,
      {String initParser = '',
      int level = 0,
      showList = true,
      bool detail = false}) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Profile_Name}: $profile\n';
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

  @override
  String exportRecordString(RecordModel record,
      {String initParser = '',
      int level = 0,
      bool showList = true,
      bool detail = false}) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Date_Time}: ${detail ? record.dateTimeString : record.dateTimeShortString}\n';
    if (record.title.isNotEmpty) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Record_Title}: ${record.title}\n';
    }

    for (RecordCategory category in RecordCategory.values) {
      String categoryTitle;
      String categoryTotal;
      switch (category) {
        case RecordCategory.income:
          categoryTitle = LocalizationString.Income;
          categoryTotal = LocalizationString.Total_Income;
          break;
        case RecordCategory.expense:
          categoryTitle = LocalizationString.Expense;
          categoryTotal = LocalizationString.Total_Expense;
          break;
        default:
          categoryTitle = LocalizationString.Title;
          categoryTotal = LocalizationString.Total;
          break;
      }
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}$categoryTitle:\n';

      level++;
      if (showList) {
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Item}:\n';
        level++;
        for (var element in record.getListItem(category)) {
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
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}$categoryTotal: ${record.getTotalPrice(category)}${LocalizationString.Currency_Unit}\n';
      level--;
    }
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Income} - ${LocalizationString.Expense} = ${record.getTotalPrice(RecordCategory.income) - record.getTotalPrice(RecordCategory.expense)}${LocalizationString.Currency_Unit}\n';
    return initParser;
  }

  @override
  String exportItemString(ItemModel item,
      {String initParser = '',
      int level = 0,
      bool showList = true,
      bool detail = false}) {
    bool customType = false;
    if (item.title.isEmpty && item.price == 0 && item.listSubItem.isNotEmpty) {
      customType = true;
    }
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
    if (item.price == 0 || item.listSubItem.isNotEmpty) {
      if (item.listSubItem.isNotEmpty && showList) {
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Sub_Item}:\n';
        level++;
        for (var element in item.listSubItem) {
          initParser = exportSubItemString(element,
              initParser: initParser,
              level: level,
              showList: detail ? showList : false,
              detail: detail);
          if (!customType) {
            initParser =
                '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${AppDefine.SeparatorLineCharacter * (AppDefine.SeparatorLineLength + AppDefine.TabLength * 2)}\n';
          }
        }
        level--;
      }
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Total}: ${item.totalPrice}${LocalizationString.Currency_Unit}\n';
    }
    return initParser;
  }

  @override
  String exportSubItemString(SubItemModel subItem,
      {String initParser = '',
      int level = 0,
      bool showList = true,
      bool detail = false}) {
    if (subItem.title.isNotEmpty && subItem.price != 0) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${subItem.title}: ${subItem.price}${LocalizationString.Currency_Unit}\n';
    } else {
      if (subItem.title.isNotEmpty) {
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Title}: ${subItem.title}\n';
      }
      if (subItem.price != 0) {
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Price}: ${subItem.price}${LocalizationString.Currency_Unit}\n';
      }
    }
    if (subItem.price == 0 || subItem.listSubItem.isNotEmpty) {
      if (subItem.listSubItem.isNotEmpty && showList) {
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
}

class ExportManagerOneCategoryDefault implements ExportManager {
  RecordCategory category;

  ExportManagerOneCategoryDefault({required this.category});

  @override
  String exportProfileString(String profile, List<RecordModel> listRecord,
      {String initParser = '',
      int level = 0,
      showList = true,
      bool detail = false}) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Profile_Name}: $profile\n';
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

  @override
  String exportRecordString(RecordModel record,
      {String initParser = '',
      int level = 0,
      bool showList = true,
      bool detail = false}) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Date_Time}: ${detail ? record.getDateTimeString(category) : record.getDateTimeShortString(category)}\n';
    if (record.title.isNotEmpty) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Record_Title}: ${record.title}\n';
    }
    if (record.getListItem(category).isNotEmpty) {
      if (showList) {
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Item}:\n';
        level++;
        for (var element in record.getListItem(category)) {
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
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Total}: ${record.getTotalPrice(category)}${LocalizationString.Currency_Unit}\n';
    }
    return initParser;
  }

  @override
  String exportItemString(ItemModel item,
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
    if (item.price == 0 || item.listSubItem.isNotEmpty) {
      if (item.listSubItem.isNotEmpty && showList) {
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

  @override
  String exportSubItemString(SubItemModel subItem,
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
    if (subItem.price == 0 || subItem.listSubItem.isNotEmpty) {
      if (subItem.listSubItem.isNotEmpty && showList) {
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
}

class ExportManagerOneCategoryCustom implements ExportManager {
  RecordCategory category;

  ExportManagerOneCategoryCustom({required this.category});

  @override
  String exportProfileString(String profile, List<RecordModel> listRecord,
      {String initParser = '',
      int level = 0,
      showList = true,
      bool detail = false}) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Profile_Name}: $profile\n';
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

  @override
  String exportRecordString(RecordModel record,
      {String initParser = '',
      int level = 0,
      bool showList = true,
      bool detail = false}) {
    initParser =
        '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Date_Time}: ${detail ? record.getDateTimeString(category) : record.getDateTimeShortString(category)}\n';
    if (record.title.isNotEmpty) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Record_Title}: ${record.title}\n';
    }
    if (record.getListItem(category).isNotEmpty) {
      if (showList) {
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Item}:\n';
        level++;
        for (var element in record.getListItem(category)) {
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
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Total}: ${record.getTotalPrice(category)}${LocalizationString.Currency_Unit}\n';
    }
    return initParser;
  }

  @override
  String exportItemString(ItemModel item,
      {String initParser = '',
      int level = 0,
      bool showList = true,
      bool detail = false}) {
    bool customType = false;
    if (item.title.isEmpty && item.price == 0 && item.listSubItem.isNotEmpty) {
      customType = true;
    }
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
    if (item.price == 0 || item.listSubItem.isNotEmpty) {
      if (item.listSubItem.isNotEmpty && showList) {
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.List_Sub_Item}:\n';
        level++;
        for (var element in item.listSubItem) {
          initParser = exportSubItemString(element,
              initParser: initParser,
              level: level,
              showList: detail ? showList : false,
              detail: detail);
          if (!customType) {
            initParser =
                '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${AppDefine.SeparatorLineCharacter * (AppDefine.SeparatorLineLength + AppDefine.TabLength * 2)}\n';
          }
        }
        level--;
      }
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Total}: ${item.totalPrice}${LocalizationString.Currency_Unit}\n';
    }
    return initParser;
  }

  @override
  String exportSubItemString(SubItemModel subItem,
      {String initParser = '',
      int level = 0,
      bool showList = true,
      bool detail = false}) {
    if (subItem.title.isNotEmpty && subItem.price != 0) {
      initParser =
          '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${subItem.title}: ${subItem.price}${LocalizationString.Currency_Unit}\n';
    } else {
      if (subItem.title.isNotEmpty) {
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Title}: ${subItem.title}\n';
      }
      if (subItem.price != 0) {
        initParser =
            '$initParser${AppDefine.TabCharacter * AppDefine.TabLength * level}${LocalizationString.Price}: ${subItem.price}${LocalizationString.Currency_Unit}\n';
      }
    }
    if (subItem.price == 0 || subItem.listSubItem.isNotEmpty) {
      if (subItem.listSubItem.isNotEmpty && showList) {
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
}
