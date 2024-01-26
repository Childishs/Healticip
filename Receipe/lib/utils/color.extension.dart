import 'package:flutter/material.dart';

extension ColorExt on Color {
  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final HSLColor hsl = HSLColor.fromColor(this);
    final HSLColor hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );

    return hslLight.toColor();
  }
}
