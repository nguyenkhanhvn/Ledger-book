import 'package:flutter/material.dart';

class BaseListView extends Scrollbar {
  BaseListView({
    super.key,
    super.controller,
    super.thumbVisibility,
    super.trackVisibility,
    super.thickness = 5,
    super.radius = const Radius.circular(5),
    super.notificationPredicate,
    super.interactive,
    super.scrollbarOrientation,
    int? itemCount,
    required NullableIndexedWidgetBuilder itemBuilder,
    EdgeInsetsGeometry padding = const EdgeInsets.only(right: 10),
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) : super(
          child: ListView.builder(
            shrinkWrap: shrinkWrap,
            physics: physics,
            padding: padding,
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          ),
        );
}
