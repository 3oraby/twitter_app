import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/follow_relationships/presentation/screens/followers_suggestion_screen.dart';
import 'package:twitter_app/features/follow_relationships/presentation/widgets/user_followers_tab_bar_view.dart';
import 'package:twitter_app/features/follow_relationships/presentation/widgets/user_followings_tab_bar_view.dart';

class UserConnectionsScreen extends StatefulWidget {
  const UserConnectionsScreen({super.key});

  static const String routeId = "kUserConnectionScreen";

  @override
  State<UserConnectionsScreen> createState() => _UserConnectionsScreenState();
}

class _UserConnectionsScreenState extends State<UserConnectionsScreen> {
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
        title: Text(
          "${currentUser.firstName} ${currentUser.lastName}",
          style: AppTextStyles.uberMoveBlack20,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, FollowersSuggestionScreen.routeId);
            },
            icon: const Icon(
              Icons.person_add_alt_1_outlined,
              size: 34,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              indicatorColor: AppColors.twitterAccentColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: AppTextStyles.uberMoveBold18,
              unselectedLabelStyle: AppTextStyles.uberMoveBold18.copyWith(
                color: AppColors.secondaryColor,
              ),
              tabs: const [
                Tab(text: "Followers"),
                Tab(text: "Following"),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  UserFollowersTabBarView(),
                  UserFollowingsTabBarView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
