import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/features/follow_relationships/data/models/following_relationship_model.dart';
import 'package:twitter_app/features/follow_relationships/domain/repos/follow_repo.dart';
import 'package:twitter_app/features/follow_relationships/presentation/cubits/toggle_follow_relation_ship_cubit/toggle_follow_relation_ship_cubit.dart';

class CustomToggleFollowButton extends StatelessWidget {
  const CustomToggleFollowButton({
    super.key,
    required this.followedId,
    required this.followingId,
    this.isActive = false,
  });

  final String followedId;
  final String followingId;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToggleFollowRelationShipCubit(
        followRepo: getIt<FollowRepo>(),
      ),
      child: CustomToggleFollowButtonBlocConsumerBody(
        followedId: followedId,
        followingId: followingId,
        isActive: isActive,
      ),
    );
  }
}

class CustomToggleFollowButtonBlocConsumerBody extends StatefulWidget {
  const CustomToggleFollowButtonBlocConsumerBody({
    super.key,
    required this.followedId,
    required this.followingId,
    required this.isActive,
  });

  final String followedId;
  final String followingId;
  final bool isActive;

  @override
  State<CustomToggleFollowButtonBlocConsumerBody> createState() =>
      _CustomToggleFollowButtonBlocConsumerBodyState();
}

class _CustomToggleFollowButtonBlocConsumerBodyState
    extends State<CustomToggleFollowButtonBlocConsumerBody> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive;
  }

  _toggleFollow() async {
    BlocProvider.of<ToggleFollowRelationShipCubit>(context)
        .toggleFollowRelationShip(
            data: FollowingRelationshipModel(
              followedId: widget.followedId,
              followingId: widget.followingId,
              followedAt: Timestamp.now(),
            ).toJson(),
            isMakingFollowRelation: !isActive);
    setState(() {
      isActive = !isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToggleFollowRelationShipCubit,
        ToggleFollowRelationShipState>(
      listener: (context, state) {
        if (state is ToggleFollowRelationShipFailureState) {
          showCustomSnackBar(context, context.tr(state.message));
          setState(() {
            isActive = !isActive;
          });
        }
      },
      builder: (context, state) {
        return CustomContainerButton(
          width: 105,
          height: 40,
          internalVerticalPadding: 0,
          internalHorizontalPadding: 0,
          borderColor: AppColors.borderColor,
          borderWidth: 1,
          backgroundColor: isActive ? Colors.white : AppColors.primaryColor,
          onPressed: state is ToggleFollowRelationShipLoadingState
              ? null
              : _toggleFollow,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                isActive ? context.tr("Following") : context.tr("Follow"),
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
