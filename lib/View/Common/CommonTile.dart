import 'package:flutter/material.dart';

import 'CommonMaterial.dart';

class BasicTile extends Container {
  BasicTile({
    super.key,
    super.alignment,
    super.padding,
    super.color,
    super.foregroundDecoration,
    super.width,
    super.height,
    super.constraints,
    super.margin,
    super.transform,
    super.transformAlignment,
    super.child,
    super.clipBehavior = Clip.none,
    required BorderSide borderLine,
  }) : super(
          decoration: BoxDecoration(
            border: Border(
              bottom: borderLine,
            ),
          ),
        );
}

class TileButton extends TextButton {
  TileButton({
    super.key,
    required Widget child,
    required super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) : super(
          child: Container(
            width: width,
            height: height,
            padding: padding,
            margin: margin,
            decoration: BoxDecoration(
              border: Border(
                bottom: LightBorderSide(),
              ),
            ),
            child: child,
          ),
        );
}
