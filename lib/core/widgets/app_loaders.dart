import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// A gallery of ready-to-use animated loaders powered by flutter_spinkit.
/// Use like: `AppLoaders.wave(color: context.colors.primary)`.
class AppLoaders {
  AppLoaders._();

  static const Color _fallback = Color(0xFF6C4DF6);

  static Widget fadingCircle({Color? color, double size = 44}) =>
      SpinKitFadingCircle(color: color ?? _fallback, size: size);

  static Widget wave({Color? color, double size = 34}) =>
      SpinKitWave(color: color ?? _fallback, size: size);

  static Widget pulse({Color? color, double size = 56}) =>
      SpinKitPulse(color: color ?? _fallback, size: size);

  static Widget cubeGrid({Color? color, double size = 42}) =>
      SpinKitCubeGrid(color: color ?? _fallback, size: size);

  static Widget threeBounce({Color? color, double size = 40}) =>
      SpinKitThreeBounce(color: color ?? _fallback, size: size);

  static Widget ring({Color? color, double size = 44}) =>
      SpinKitRing(color: color ?? _fallback, size: size, lineWidth: 3.5);

  static Widget spinningLines({Color? color, double size = 44}) =>
      SpinKitSpinningLines(color: color ?? _fallback, size: size);
}
