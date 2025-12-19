import 'package:flutter/material.dart';

/// Simple responsive helpers to scale paddings, font sizes and component
/// dimensions based on the current device width. Uses 390px (iPhone 14) as the
/// design reference and clamps the scale so layouts remain usable on very
/// small/large screens.
class Responsive {
  static const double _referenceWidth = 390.0;
  static const double _minScale = 0.85;
  static const double _maxScale = 1.25;

  static double _scaleFor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (width / _referenceWidth).clamp(_minScale, _maxScale);
  }

  /// Scale any dimension.
  static double scale(BuildContext context, double value,
      {double min = _minScale, double max = _maxScale}) {
    final scale = _scaleFor(context).clamp(min, max);
    return value * scale;
  }

  /// Scale font sizes with a narrower clamp to avoid huge jumps.
  static double font(BuildContext context, double value,
      {double min = 0.9, double max = 1.15}) {
    final scale = _scaleFor(context).clamp(min, max);
    return value * scale;
  }

  /// Quick adaptive padding helper.
  static EdgeInsets padding(BuildContext context,
      {double horizontal = 24, double vertical = 24}) {
    return EdgeInsets.symmetric(
      horizontal: scale(context, horizontal),
      vertical: scale(context, vertical),
    );
  }

  static bool isCompact(BuildContext context) =>
      MediaQuery.of(context).size.width < 360;

  static bool isExpanded(BuildContext context) =>
      MediaQuery.of(context).size.width > 520;
}

extension ResponsiveContext on BuildContext {
  double rs(double value, {double min = Responsive._minScale, double max = Responsive._maxScale}) =>
      Responsive.scale(this, value, min: min, max: max);

  double rf(double value, {double min = 0.9, double max = 1.15}) =>
      Responsive.font(this, value, min: min, max: max);

  EdgeInsets rp({double h = 24, double v = 24}) =>
      Responsive.padding(this, horizontal: h, vertical: v);

  bool get isCompact => Responsive.isCompact(this);
  bool get isExpanded => Responsive.isExpanded(this);
}
