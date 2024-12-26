import 'package:twitter_app/core/helpers/functions/get_scale_factor.dart';

double getResponsiveTextFontSize(
    { required double fontSize}) {
  double scaleFactor = getScaleFactor();
  double responsiveTextFontSize = scaleFactor * fontSize;
  double lowerLimit = fontSize * 0.8;
  double upperLimit = fontSize * 1.2;
  return responsiveTextFontSize.clamp(lowerLimit, upperLimit);
}


