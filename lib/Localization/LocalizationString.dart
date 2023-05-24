import 'package:ledger_book/Controller/Controller.dart';

class LocalizationString {
  static final LocalizationString _instance = LocalizationString._internal();

  factory LocalizationString() {
    return _instance;
  }

  LocalizationString._internal();

  static String get Error_Locale => Localization().listString['Error_Locale']??'Error_Locale';
  static String get App_Title => Localization().listString['App_Title']??'App_Title';
  static String get Language => Localization().listString['Language']??'Language';
  static String get Theme => Localization().listString['Theme']??'Theme';
  static String get Error_Theme => Localization().listString['Error_Theme']??'Error_Theme';
  static String get Color => Localization().listString['Color']??'Color';
  static String get Profile_Title => Localization().listString['Profile_Name']??'Profile_Name';
  static String get Error_Profile_Name => Localization().listString['Error_Profile_Name']??'Error_Profile_Name';
  static String get Add_Profile => Localization().listString['Add_Profile']??'Add_Profile';
  static String get Edit_Profile => Localization().listString['Edit_Profile']??'Edit_Profile';
  static String get Error => Localization().listString['Error']??'Error';
  static String get Exit => Localization().listString['Exit']??'Exit';
  static String get Settings => Localization().listString['Settings']??'Settings';
  static String get Total => Localization().listString['Total']??'Total';
  static String get Currency_Unit => Localization().listString['Currency_Unit']??'Currency_Unit';
  static String get List_Item => Localization().listString['List_Item']??'List_Item';
  static String get Item => Localization().listString['Item']??'Item';
  static String get Import_Item => Localization().listString['Import_Item']??'Import_Item';
  static String get Sub_Item => Localization().listString['Sub_Item']??'Sub_Item';
  static String get Add_Order => Localization().listString['Add_Order']??'Add_Order';
  static String get Import_Order => Localization().listString['Import_Order']??'Import_Order';
  static String get List_Sub_Item => Localization().listString['List_Sub_Item']??'List_Sub_Item';
  static String get Add_Sub_Item => Localization().listString['Add_Sub_Item']??'Add_Sub_Item';
  static String get Edit_Sub_Item => Localization().listString['Edit_Sub_Item']??'Edit_Sub_Item';
  static String get Confirm => Localization().listString['Confirm']??'Confirm';
  static String get Add => Localization().listString['Add']??'Add';
  static String get Confirm_Add => Localization().listString['Confirm_Add']??'Confirm_Add';
  static String get Save => Localization().listString['Save']??'Save';
  static String get Confirm_Save => Localization().listString['Confirm_Saved']??'Confirm_Saved';
  static String get Cancel => Localization().listString['Cancel']??'Cancel';
  static String get Delete => Localization().listString['Delete']??'Delete';
  static String get Delete_Order => Localization().listString['Delete_Order']??'Delete_Order';
  static String get Delete_Item => Localization().listString['Delete_Item']??'Delete_Item';
  static String get Delete_Sub_Item => Localization().listString['Delete_Sub_Item']??'Delete_Sub_Item';
  static String get Confirm_Delete => Localization().listString['Confirm_Delete']??'Confirm_Delete';
  static String get Confirm_Add_Profile => Localization().listString['Confirm_Add_Profile']??'Confirm_Add_Profile';
  static String get Confirm_Edit_Profile => Localization().listString['Confirm_Edit_Profile']??'Confirm_Edit_Profile';
  static String get Confirm_Delete_Profile => Localization().listString['Confirm_Delete_Profile']??'Confirm_Delete_Profile';
  static String get Confirm_Delete_Order => Localization().listString['Confirm_Delete_Order']??'Confirm_Delete_Order';
  static String get Confirm_Delete_Orders => Localization().listString['Confirm_Delete_Orders']??'Confirm_Delete_Orders';
  static String get Confirm_Delete_Item => Localization().listString['Confirm_Delete_Item']??'Confirm_Delete_Item';
  static String get Confirm_Delete_Items => Localization().listString['Confirm_Delete_Items']??'Confirm_Delete_Items';
  static String get Confirm_Delete_Sub_Item => Localization().listString['Confirm_Delete_Sub_Item']??'Confirm_Delete_Sub_Item';
  static String get Back => Localization().listString['Back']??'Back';
  static String get Confirm_Back => Localization().listString['Confirm_Back']??'Confirm_Back';
  static String get Price => Localization().listString['Price']??'Price';
  static String get Title => Localization().listString['Title']??'Title';
  static String get Order_Title => Localization().listString['Order_Title']??'Order_Title';
  static String get To => Localization().listString['To']??'To';
  static String get Sort_By_Date_Ascending => Localization().listString['Sort_By_Date_Ascending']??'Sort_By_Date_Ascending';
  static String get Sort_By_Date_Descending => Localization().listString['Sort_By_Date_Descending']??'Sort_By_Date_Descending';
  static String get Sort_By_Price_Ascending => Localization().listString['Sort_By_Price_Ascending']??'Sort_By_Price_Ascending';
  static String get Sort_By_Price_Descending => Localization().listString['Sort_By_Price_Descending']??'Sort_By_Price_Descending';
  static String get Sort_By_Title_Ascending => Localization().listString['Sort_By_Title_Ascending']??'Sort_By_Title_Ascending';
  static String get Sort_By_Title_Descending => Localization().listString['Sort_By_Title_Descending']??'Sort_By_Title_Descending';
  static String get Date_Time => Localization().listString['Date_Time']??'Date_Time';
  static String get Import_Export => Localization().listString['Import_Export']??'Import_Export';
  static String get Import => Localization().listString['Import']??'Import';
  static String get Import_Profile => Localization().listString['Import_Profile']??'Import_Profile';
  static String get Export_Profile => Localization().listString['Export_Profile']??'Export_Profile';
  static String get Export_Raw => Localization().listString['Export_Raw']??'Export_Raw';
  static String get Export_Simplified => Localization().listString['Export_Simplified']??'Export_Simplified';
  static String get Export_Details => Localization().listString['Export_Details']??'Export_Details';
  static String get Copy_To_Clipboard_Successfully => Localization().listString['Copy_To_Clipboard_Successfully']??'Copy_To_Clipboard_Successfully';
  static String get Copy_To_Clipboard_Error => Localization().listString['Copy_To_Clipboard_Error']??'Copy_To_Clipboard_Error';
  static String get Import_Successfully => Localization().listString['Import_Successfully']??'Import_Successfully';
  static String get Import_Error => Localization().listString['Import_Error']??'Import_Error';
}