import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/utils/app_images.dart';

class AddUserProfilePictureScreen extends StatelessWidget {
  const AddUserProfilePictureScreen({super.key});

  static const String routeId = 'kAddUserProfilePictureScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        title: SvgPicture.asset(AppImages.svgXLogoWhiteBackground48),
      ),
    );
  }
}
