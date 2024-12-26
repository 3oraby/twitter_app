import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/features/auth/presentation/widgets/signin_with_phone_number_body.dart';
class SignInWithPhoneNumberScreen extends StatelessWidget {
  const SignInWithPhoneNumberScreen({super.key});
  static const String routeId = "kSignInWithPhoneNumberScreen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        title: "Enter Your Mobile Number".tr(),
        centerTitle: false,
      ),
      body: const SignInWithPhoneNumberBody(),
    );
  }
}
