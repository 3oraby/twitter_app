import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/suggestion_followers/presentation/cubits/get_followers_suggestions_cubit/get_followers_suggestions_cubit.dart';
import 'package:twitter_app/features/suggestion_followers/presentation/widgets/followers_suggestions_body.dart';

class FollowersSuggestionView extends StatefulWidget {
  const FollowersSuggestionView({super.key});

  @override
  State<FollowersSuggestionView> createState() =>
      _FollowersSuggestionViewState();
}

class _FollowersSuggestionViewState extends State<FollowersSuggestionView> {
  AppBar buildSuggestionsAppBar({
    required BuildContext context,
  }) {
    return buildCustomAppBar(
      context,
      automaticallyImplyLeading: false,
      title: Text(
        "Connect",
        style: AppTextStyles.uberMoveBlack20,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    UserEntity currentUser = getCurrentUserEntity();
    log("get suggestions followers data");
    BlocProvider.of<GetFollowersSuggestionsCubit>(context)
        .getFollowersSuggestions(currentUserId: currentUser.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSuggestionsAppBar(context: context),
        const FollowersSuggestionsBlocConsumerBody()
      ],
    );
  }
}

class FollowersSuggestionsBlocConsumerBody extends StatelessWidget {
  const FollowersSuggestionsBlocConsumerBody({super.key});

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
          return const CircularProgressIndicator(
            color: AppColors.primaryColor,
          );
        } else if (state is GetFollowersSuggestionsFailureState) {
          return Text(state.message);
        }
        return const SizedBox();
      },
    );
  }
}
