import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/features/suggestion_followers/data/models/following_relationship_model.dart';
import 'package:twitter_app/features/suggestion_followers/domain/repos/follow_repo.dart';
import 'package:twitter_app/features/suggestion_followers/presentation/cubits/toggle_follow_relation_ship_cubit/toggle_follow_relation_ship_cubit.dart';

class CustomFollowButton extends StatelessWidget {
  const CustomFollowButton({
    super.key,
    required this.followedId,
    required this.followingId,
  });

  final String followedId;
  final String followingId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToggleFollowRelationShipCubit(
        followRepo: getIt<FollowRepo>(),
      ),
      child: CustomFollowButtonBlocConsumerBody(
        followedId: followedId,
        followingId: followingId,
      ),
    );
  }
}

class CustomFollowButtonBlocConsumerBody extends StatefulWidget {
  const CustomFollowButtonBlocConsumerBody({
    super.key,
    required this.followedId,
    required this.followingId,
  });

  final String followedId;
  final String followingId;

  @override
  State<CustomFollowButtonBlocConsumerBody> createState() =>
      _CustomFollowButtonBlocConsumerBodyState();
}

class _CustomFollowButtonBlocConsumerBodyState
    extends State<CustomFollowButtonBlocConsumerBody> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToggleFollowRelationShipCubit,
        ToggleFollowRelationShipState>(
      listener: (context, state) {
        if (state is ToggleFollowRelationShipFailureState) {
          showCustomSnackBar(context, 'Failed to update follow relationship');
        }
      },
      builder: (context, state) {
        final isLoading = state is ToggleFollowRelationShipLoadingState;

        return CustomContainerButton(
          width: 105,
          height: 40,
          internalVerticalPadding: 0,
          internalHorizontalPadding: 0,
          borderColor: AppColors.borderColor,
          borderWidth: 1,
          backgroundColor: isActive
              ? Colors.white
              : AppColors.primaryColor,
          onPressed: isLoading
              ? null
              : () async {
                  await BlocProvider.of<ToggleFollowRelationShipCubit>(context)
                      .toggleFollowRelationShip(
                    data: FollowingRelationshipModel(
                      followedId: widget.followedId,
                      followingId: widget.followingId,
                      followedAt: Timestamp.now(),
                    ).toJson(),
                  );
                  setState(() {
                    isActive = !isActive;
                  });
                },
          child: Center(
            child: isLoading
                ? Padding(
                  padding: const EdgeInsets.all(4),
                  child: CircularProgressIndicator(
                    color: isActive ? Colors.black : Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      isActive ? "Following" : "Follow",
                      style: AppTextStyles.uberMoveBold14.copyWith(
                        color: isActive ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class ActiveToggleFollowButton extends StatelessWidget {
  const ActiveToggleFollowButton({
    super.key,
    required this.followedId,
    required this.isLoading,
    required this.followingId,
    required this.onPressed,
  });

  final String followedId;
  final bool isLoading;
  final String followingId;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return CustomContainerButton(
      key: Key(followedId),
      width: 100,
      height: 40,
      internalVerticalPadding: 0,
      internalHorizontalPadding: 0,
      backgroundColor: AppColors.highlightBackgroundColor,
      onPressed: onPressed,
      child: Center(
        child: isLoading
            ? const SizedBox(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  "Following",
                  style: AppTextStyles.uberMoveBold14,
                ),
              ),
      ),
    );
  }
}

class InActiveToggleFollowButton extends StatelessWidget {
  const InActiveToggleFollowButton({
    super.key,
    required this.followedId,
    required this.isLoading,
    required this.followingId,
    required this.onPressed,
  });

  final String followedId;
  final bool isLoading;
  final String followingId;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomContainerButton(
      key: Key(followedId),
      width: 100,
      height: 40,
      internalVerticalPadding: 0,
      internalHorizontalPadding: 0,
      backgroundColor: AppColors.primaryColor,
      onPressed: onPressed,
      child: Center(
        child: isLoading
            ? const SizedBox(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  "Follow",
                  style: AppTextStyles.uberMoveBold14
                      .copyWith(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
