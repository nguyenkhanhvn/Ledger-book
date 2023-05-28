import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Define.dart';

class PageRouting {
  static void route(
    BuildContext context, {
    required WidgetBuilder builder,
  }) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: builder,
      ),
    );
  }

  static Future<PageAction?> routeWithCallback(
    BuildContext context, {
    required WidgetBuilder builder,
    VoidCallback? callback,
    Map<PageAction, VoidCallback>? actionCallback,
  }) async {
    PageAction? action = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: builder,
      ),
    );
    if (action != null) {
      actionCallback?[action]?.call();
    }
    callback?.call();
    return action;
  }

  static Future<PageAction?> routeWithConditionalCallback(
    BuildContext context, {
    required WidgetBuilder builder,
    VoidCallback? callback,
    Map<PageAction, VoidCallback>? actionCallback,
  }) async {
    PageAction? action = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: builder,
      ),
    );
    if (action != null) {
      actionCallback?[action]?.call();
      callback?.call();
    }
    return action;
  }

  static Future<List<dynamic>?> routeWithConditionalValueChangeCallback(
      BuildContext context, {
        required WidgetBuilder builder,
        ValueChanged<List>? callback,
        Map<PageAction, ValueChanged<List>>? actionCallback,
      }) async {
    List<dynamic>? returnValue = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: builder,
      ),
    );
    if (returnValue != null && returnValue.isNotEmpty) {
    actionCallback?[returnValue[0]]?.call(returnValue.sublist(1));
    callback?.call(returnValue.sublist(1));
    }
    return returnValue;
  }
}
