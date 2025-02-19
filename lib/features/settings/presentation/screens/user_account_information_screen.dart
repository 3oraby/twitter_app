import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_logout_button.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/settings/presentation/widgets/custom_user_information_item.dart';
import 'package:twitter_app/features/settings/presentation/widgets/joined_on_date_info.dart';

class UserAccountInformationScreen extends StatefulWidget {
  const UserAccountInformationScreen({super.key});

  static const String routeId = 'kAccountInformationScreen';

  @override
  State<UserAccountInformationScreen> createState() =>
      _UserAccountInformationScreenState();
}

class _UserAccountInformationScreenState
    extends State<UserAccountInformationScreen> {
  late UserEntity currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        title: Column(
          children: [
            Text(
              "Account",
              style: AppTextStyles.uberMoveBlack20,
            ),
            Text(
              "@${getCurrentUserEntity().email}",
              style: AppTextStyles.uberMoveMedium16
                  .copyWith(color: AppColors.thirdColor),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
          vertical: AppConstants.topPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: JoinedOnDateInfo(joinedAt: currentUser.joinedAt),
            ),
            CustomUserInformationItem(  
              title: "Email",
              value: currentUser.email,
            ),
            CustomUserInformationItem(
              title: "First Name",
              value: currentUser.firstName ?? '',
              onTap: () {},
            ),
            CustomUserInformationItem(
              title: "Last Name",
              value: currentUser.lastName ?? '',
              onTap: () {},
            ),
            CustomUserInformationItem(
              title: "Bio",
              value: currentUser.bio ?? "None",
              onTap: () {},
            ),
            CustomUserInformationItem(
              title: "Age",
              value: currentUser.age.toString(),
              onTap: () {},
            ),
            CustomUserInformationItem(
              title: "Phone",
              value: currentUser.phoneNumber ?? "Add",
              onTap: () {},
            ),
            const VerticalGap(8),
            const Center(child: CustomLogOutButton()),
          ],
        ),
      ),
    );
  }
}
