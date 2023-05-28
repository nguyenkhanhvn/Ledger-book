import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ledger_book/Controller/Controller.dart';

class BaseTabBar extends TabBar {
  BaseTabBar({super.key,super.controller,
    super.isScrollable = false,
    BorderRadiusGeometry? borderRadius,

    super.padding,
    super.indicatorColor,
    super.automaticIndicatorColorAdjustment = true,
    super.indicatorWeight = 2.0,
    super.indicatorPadding = EdgeInsets.zero,
    super.dividerColor,
    super.labelColor,
    super.labelStyle,
    super.labelPadding,
    super.unselectedLabelStyle,
    super.dragStartBehavior = DragStartBehavior.start,
    super.overlayColor,
    super.mouseCursor,
    super.enableFeedback,
    super.onTap,
    super.physics,
    super.splashFactory,
    super.splashBorderRadius, required List<Widget> children,})
      : super(
          unselectedLabelColor: Localization().themeColor,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: BoxDecoration(
              borderRadius: borderRadius,
              color: Localization().themeColor),
          tabs: List.generate(
            children.length,
            (index) => Tab(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border:
                        Border.all(color: Localization().themeColor, width: 1)),
                child: children[index],
              ),
            ),
          ),
        );
}
