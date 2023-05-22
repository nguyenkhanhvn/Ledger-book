import 'package:flutter/material.dart';
import 'package:ledger_book/Controller/Controller.dart';

// Icon

class BasicIcon extends Icon {
  BasicIcon(
    super.icon, {
    super.key,
    super.size,
    super.fill,
    super.weight,
    super.grade,
    super.opticalSize,
    super.shadows,
    super.semanticLabel,
    super.textDirection,
  }) : super(
          color: Localization().themeColor,
        );
}

class BaseIconButton extends SizedBox {
  BaseIconButton({
    super.key,
    required Widget icon,
    required VoidCallback onPressed,
    double? width,
    double? height,
    double? size,
  }) : super(
          width: width,
          height: height,
          child: IconButton(
            padding: const EdgeInsets.all(0.0),
            onPressed: onPressed,
            icon: icon,
            iconSize: size,
          ),
        );
}

// Text Style

class BasicTextStyle extends TextStyle {
  const BasicTextStyle()
      : super(
          fontSize: 16,
        );
}

class AppBarTitleTextStyle extends TextStyle {
  const AppBarTitleTextStyle({
    super.color,
    super.backgroundColor,
    super.fontStyle,
    super.letterSpacing,
    super.wordSpacing,
    super.textBaseline,
    super.height,
    super.leadingDistribution,
    super.locale,
    super.foreground,
    super.background,
    super.shadows,
    super.fontFeatures,
    super.fontVariations,
    super.decoration,
    super.decorationColor,
    super.decorationStyle,
    super.decorationThickness,
    super.debugLabel,
    super.fontFamily,
    super.fontFamilyFallback,
    super.package,
  }) : super(
          fontWeight: FontWeight.bold,
          fontSize: 28,
        );
}

class TitleTextStyle extends TextStyle {
  const TitleTextStyle({
    super.color,
    super.backgroundColor,
    super.fontStyle,
    super.letterSpacing,
    super.wordSpacing,
    super.textBaseline,
    super.height,
    super.leadingDistribution,
    super.locale,
    super.foreground,
    super.background,
    super.shadows,
    super.fontFeatures,
    super.fontVariations,
    super.decoration,
    super.decorationColor,
    super.decorationStyle,
    super.decorationThickness,
    super.debugLabel,
    super.fontFamily,
    super.fontFamilyFallback,
    super.package,
  }) : super(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        );
}

class SubTitleTextStyle extends TextStyle {
  const SubTitleTextStyle({
    super.color,
    super.backgroundColor,
    super.fontStyle,
    super.letterSpacing,
    super.wordSpacing,
    super.textBaseline,
    super.height,
    super.leadingDistribution,
    super.locale,
    super.foreground,
    super.background,
    super.shadows,
    super.fontFeatures,
    super.fontVariations,
    super.decoration,
    super.decorationColor,
    super.decorationStyle,
    super.decorationThickness,
    super.debugLabel,
    super.fontFamily,
    super.fontFamilyFallback,
    super.package,
  }) : super(
          fontSize: 14,
        );
}

// Border

class BasicBorderSide extends BorderSide {
  BasicBorderSide({super.width})
      : super(
          color: Localization().themeColor,
        );
}

class LightBorderSide extends BorderSide {
  LightBorderSide({super.width})
      : super(
          color: Localization().themeColor.shade200,
        );
}

class DarkBorderSide extends BorderSide {
  DarkBorderSide({super.width})
      : super(
          color: Localization().themeColor.shade700,
        );
}
