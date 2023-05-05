import 'package:flutter/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveManager {
  static final ResponsiveManager instance = ResponsiveManager._internal();

  factory ResponsiveManager() => instance;

  ResponsiveManager._internal();

  double responsiveMultiplicator(
    BuildContext context,
    double value,
    double mobile,
    double tablet,
    double desktop,
  ) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return value * mobile;
    } else if (ResponsiveBreakpoints.of(context).isTablet) {
      return value * tablet;
    } else if (ResponsiveBreakpoints.of(context).isDesktop) {
      return value * desktop;
    }

    return value * mobile;
  }

  double responsiveSelector(
    BuildContext context,
    double mobile,
    double tablet,
    double desktop,
  ) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return mobile;
    } else if (ResponsiveBreakpoints.of(context).isTablet) {
      return tablet;
    } else if (ResponsiveBreakpoints.of(context).isDesktop) {
      return desktop;
    }

    return mobile;
  }
}
