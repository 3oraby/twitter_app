import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/utils/app_svgs.dart';
import 'package:twitter_app/core/widgets/custom_tab_bar.dart';
import 'package:twitter_app/core/widgets/keep_alive_tab.dart';
import 'package:twitter_app/core/widgets/leading_app_bar_user_image.dart';
import 'package:twitter_app/features/home/presentation/widgets/following_tab_bar_home_view.dart';
import 'package:twitter_app/features/home/presentation/widgets/for_you_tab_bar_home_view.dart';
import 'package:twitter_app/features/follow_relationships/presentation/screens/followers_suggestion_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  AppBar buildHomeAppBar({
    required BuildContext context,
  }) {
    return buildCustomAppBar(
      context,
      title: SvgPicture.asset(
        AppSvgs.svgXLogoWhiteBackground36,
        colorFilter: ColorFilter.mode(
          Theme.of(context).iconTheme.color!,
          BlendMode.srcIn,
        ),
      ),
      leading: const LeadingAppBarUserImage(),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, FollowersSuggestionScreen.routeId);
          },
          icon: const Icon(
            Icons.person_add_alt_1_outlined,
            size: 34,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          buildHomeAppBar(
            context: context,
          ),
          CustomTabBar(
            controller: _tabController,
            tabs: [
              Tab(text: context.tr("For you")),
              Tab(text: context.tr("accounts_current_user_follow")),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                KeepAliveTab(child: ForYouTabBarHomeView()),
                KeepAliveTab(child: FollowingTabBarHomeView()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
