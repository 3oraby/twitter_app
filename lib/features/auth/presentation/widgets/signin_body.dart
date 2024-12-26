import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/utils/app_images.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/utils/validators.dart';
import 'package:twitter_app/core/widgets/custom_text_form_field.dart';
import 'package:twitter_app/core/widgets/custom_trigger_button.dart';
import 'package:twitter_app/core/widgets/password_text_form_field.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/presentation/cubits/signin_cubits/sign_in_cubit.dart';
import 'package:twitter_app/features/auth/presentation/screens/signin_with_phone_number_screen.dart';
import 'package:twitter_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:twitter_app/features/auth/presentation/widgets/auth_switch_widget.dart';
import 'package:twitter_app/features/auth/presentation/widgets/custom_or_divider.dart';
import 'package:twitter_app/features/auth/presentation/widgets/social_sign_in_button.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({
    super.key,
  });

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;
  final formKey = GlobalKey<FormState>();
  late String email, password;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
      ),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const VerticalGap(16),
              CustomTextFormFieldWidget(
                autovalidateMode: autovalidateMode,
                hintText: "Email".tr(),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    Validators.validateNormalText(context, value),
                onSaved: (value) {
                  email = value!;
                },
              ),
              const VerticalGap(16),
              PasswordTextFieldWidget(
                autovalidateMode: autovalidateMode,
                validator: (value) =>
                    Validators.validateNormalText(context, value),
                onSaved: (value) {
                  password = value!;
                },
              ),
              const VerticalGap(16),
              CustomTriggerButton(
                buttonDescription: Text(
                  "Sign In".tr(),
                  style: AppTextStyles.uberMoveBold22
                      .copyWith(color: Colors.white),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    SignInCubit signInCubit =
                        BlocProvider.of<SignInCubit>(context);
                    signInCubit.signInWithEmailAndPassword(
                        email: email, password: password);
                  } else {
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
              ),
              const VerticalGap(10),
              AuthSwitchWidget(
                promptText: "Don't have an account?".tr(),
                actionText: "SignUp".tr(),
                onActionPressed: () {
                  Navigator.pushNamed(context, SignUpScreen.routeId);
                },
              ),
              const VerticalGap(16),
              const CustomOrDivider(),
              const VerticalGap(24),
              SocialSignInButton(
                logoName: AppImages.svgPhoneNumberLogo,
                description: "Continue With Phone".tr(),
                onPressed: () {
                  Navigator.pushNamed(
                      context, SignInWithPhoneNumberScreen.routeId);
                },
              ),
              const VerticalGap(16),
              SocialSignInButton(
                logoName: AppImages.svgGoogleLogo,
                description: "Continue With Google".tr(),
                onPressed: () {},
              ),
              // CustomTriggerButton(
              //   onPressed: () {
              //     AuthRepoImpl(firebaseAuthService: FirebaseAuthService()).getCurrentUser();
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
