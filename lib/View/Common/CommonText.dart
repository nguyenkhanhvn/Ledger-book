import 'package:flutter/material.dart';

import 'CommonMaterial.dart';

class BasicText extends Text {
  const BasicText(super.data, {super.key})
      : super(
    style: const BasicTextStyle(),
  );
}

class AppBarTitleText extends Text {
  const AppBarTitleText(super.data, {super.key})
      : super(
    style: const AppBarTitleTextStyle(),
  );
}

class TitleText extends Text {
  const TitleText(super.data, {super.key})
      : super(
    style: const TitleTextStyle(),
  );
}

class SubTitleText extends Text {
  const SubTitleText(super.data, {super.key})
      : super(
    style: const SubTitleTextStyle(),
  );
}
