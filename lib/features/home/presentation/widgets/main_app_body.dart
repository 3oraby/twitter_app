import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/features/suggestion_followers/domain/repos/follow_repo.dart';
import 'package:twitter_app/features/suggestion_followers/presentation/cubits/get_followers_suggestions_cubit/get_followers_suggestions_cubit.dart';
import 'package:twitter_app/features/suggestion_followers/presentation/screens/followers_suggestion_view.dart';
import 'package:twitter_app/features/home/presentation/widgets/home_view.dart';
import 'package:twitter_app/features/home/presentation/widgets/notification_view.dart';
import 'package:twitter_app/features/home/presentation/widgets/search_view.dart';
import 'package:twitter_app/features/home/presentation/widgets/setting_view.dart';

class MainAppBody extends StatelessWidget {
  const MainAppBody({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IndexedStack(
        index: currentIndex,
        children: [
          const HomeView(),
          const SearchView(),
          BlocProvider(
            create: (context) => GetFollowersSuggestionsCubit(
              followRepo: getIt<FollowRepo>(),
            ),
            child: const FollowersSuggestionView(),
          ),
          const NotificationView(),
          const SettingView(),
        ],
      ),
    );
  }
}
