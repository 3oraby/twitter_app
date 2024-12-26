import 'package:flutter/foundation.dart';
import 'package:twitter_app/core/utils/size_config.dart';

double getScaleFactor() {
  PlatformDispatcher platformDispatcher = PlatformDispatcher.instance;
  double physicalWidth = platformDispatcher.views.first.physicalSize.width;
  double devicePixelRatio = platformDispatcher.views.first.devicePixelRatio;
  double screenWidth = physicalWidth / devicePixelRatio;

  if (screenWidth < SizeConfig.tabletBreakPoint) {
    return screenWidth / 600;
  } else if (screenWidth < SizeConfig.desktopBreakPoint) {
    return screenWidth / 900;
  } else {
    return screenWidth / 1440;
  }
}
