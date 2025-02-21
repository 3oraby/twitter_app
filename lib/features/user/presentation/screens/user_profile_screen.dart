import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_background_icon.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/user/presentation/widgets/show_user_profile_date.dart';
import 'package:twitter_app/features/user/presentation/widgets/show_user_profile_screen_tabs.dart';
import 'package:twitter_app/features/user/presentation/widgets/show_user_profile_tab_bars.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.userEntity});

  static const String routeId = 'kUserProfileScreen';
  final UserEntity userEntity;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late ScrollController _scrollController;
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 200 && !_showAppBarTitle) {
      setState(() {
        _showAppBarTitle = true;
      });
    } else if (_scrollController.offset <= 200 && _showAppBarTitle) {
      setState(() {
        _showAppBarTitle = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.twitterAccentColor,
              expandedHeight: 400,
              title: _showAppBarTitle
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.userEntity.firstName ?? ''} ${widget.userEntity.lastName ?? ''}",
                          style: AppTextStyles.uberMoveBold18.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "@${widget.userEntity.email}",
                          style: AppTextStyles.uberMoveRegular16.copyWith(
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  : null,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomBackgroundIcon(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  contentPadding: 8,
                  backgroundColor: AppColors.iconsBackgroundColor,
                  iconData: Icons.arrow_back,
                  iconColor: Colors.white,
                ),
              ),
              actions: [
                CustomBackgroundIcon(
                  onTap: () {},
                  contentPadding: 8,
                  backgroundColor: AppColors.iconsBackgroundColor,
                  iconColor: Colors.white,
                  iconData: Icons.search,
                ),
                const HorizontalGap(AppConstants.horizontalPadding),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: ShowUserProfileData(
                  userEntity: widget.userEntity,
                ),
              ),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(48),
                child: ShowUserProfileTabBars(),
              ),
            ),
          ],
          body: const ShowUserProfileScreenTabs(),
        ),
      ),
    );
  }
}
