import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/follow_relationships/domain/repos/follow_repo.dart';
import 'package:twitter_app/features/follow_relationships/presentation/cubits/get_followers_suggestions_cubit/get_followers_suggestions_cubit.dart';
import 'package:twitter_app/features/follow_relationships/presentation/widgets/followers_suggestions_body.dart';

class FollowersSuggestionScreen extends StatelessWidget {
  const FollowersSuggestionScreen({super.key});

  static const String routeId = 'kFollowersSuggestions';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetFollowersSuggestionsCubit(
        followRepo: getIt<FollowRepo>(),
      ),
      child: Scaffold(
        appBar: buildCustomAppBar(
          context,
          title: Text(
            context.tr("Connect"),
            style: AppTextStyles.uberMoveBlack20,
          ),
        ),
        body: const FollowersSuggestionsBlocConsumerBody(),
      ),
    );
  }
}

class FollowersSuggestionsBlocConsumerBody extends StatefulWidget {
  const FollowersSuggestionsBlocConsumerBody({super.key});

  @override
  State<FollowersSuggestionsBlocConsumerBody> createState() =>
      _FollowersSuggestionsBlocConsumerBodyState();
}

class _FollowersSuggestionsBlocConsumerBodyState
    extends State<FollowersSuggestionsBlocConsumerBody> {
  late UserEntity currentUser;

  @override
  void initState() {
    super.initState();
    log("get suggestions followers data");
    currentUser = getCurrentUserEntity();

    BlocProvider.of<GetFollowersSuggestionsCubit>(context)
        .getFollowersSuggestions(currentUserId: currentUser.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetFollowersSuggestionsCubit,
        GetFollowersSuggestionsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GetFollowersSuggestionsLoadedState) {
          return FollowersSuggestionsBody(
            suggestionUsers: state.suggestionUsers,
          );
        } else if (state is GetFollowersSuggestionsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        } else if (state is GetFollowersSuggestionsFailureState) {
          return Text(state.message);
        }
        return const SizedBox();
      },
    );
  }
}
