import 'package:flutter/cupertino.dart';

class PopupMenuModel {
  final String title;
  final IconData? icon;
  final VoidCallback? handle;

  const PopupMenuModel({this.title = '', this.icon, this.handle});
}