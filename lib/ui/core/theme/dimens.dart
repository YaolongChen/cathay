import 'package:flutter/material.dart';

abstract final class Dimens {
  const Dimens();

  static const paddingHorizontal = 20.0;

  static const paddingVertical = 24.0;

  double get paddingScreenHorizontal;

  double get paddingScreenVertical;

  EdgeInsets get edgeInsetsScreenHorizontal =>
      EdgeInsets.symmetric(horizontal: paddingScreenHorizontal);

  EdgeInsets get edgeInsetsScreenSymmetric => EdgeInsets.symmetric(
    horizontal: paddingScreenHorizontal,
    vertical: paddingScreenVertical,
  );

  static final Dimens mobile = _DimensMobile();
  static final Dimens pad = _DimensPad();

  factory Dimens.of(BuildContext context) => switch (MediaQuery.sizeOf(
    context,
  ).width) {
    > 600 => pad,
    _ => mobile,
  };
}

final class _DimensMobile extends Dimens {
  @override
  double get paddingScreenHorizontal => Dimens.paddingHorizontal;

  @override
  double get paddingScreenVertical => Dimens.paddingVertical;
}

final class _DimensPad extends Dimens {
  @override
  double get paddingScreenHorizontal => 32.0;

  @override
  double get paddingScreenVertical => 40.0;
}
