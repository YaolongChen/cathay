import 'package:flutter/material.dart';

abstract final class Dimens {
  // common padding

  static const padding2 = 2.0;

  static const padding4 = 4.0;

  static const padding8 = 8.0;

  static const padding12 = 12.0;

  static const padding16 = 16.0;

  static const padding20 = 20.0;

  static const padding24 = 24.0;

  static const padding28 = 28.0;

  static const padding32 = 32.0;

  // common corner

  static const cornerExtraSmall = Radius.circular(4.0);

  static const cornerSmall = Radius.circular(8.0);

  static const cornerMedium = Radius.circular(12.0);

  static const cornerLarge = Radius.circular(16.0);

  static const cornerLargeIncreased = Radius.circular(20.0);

  static const cornerExtraLarge = Radius.circular(28.0);

  static const cornerExtraLargeIncreased = Radius.circular(32.0);

  static const cornerExtraExtraLarge = Radius.circular(48.0);

  // common spacing

  static const spacingSmall = 8.0;

  static const spacingMedium = 12.0;

  static const spacingLarge = 16.0;

  static const paddingScreenHorizontal = 20.0;

  static const paddingScreenVertical = 24.0;

  static EdgeInsets get edgeInsetsScreenHorizontal =>
      const EdgeInsets.symmetric(horizontal: paddingScreenHorizontal);

  static EdgeInsets get edgeInsetsScreenSymmetric => const EdgeInsets.symmetric(
    horizontal: paddingScreenHorizontal,
    vertical: paddingScreenVertical,
  );

  static const profilePictureSize = 120.0;
}
