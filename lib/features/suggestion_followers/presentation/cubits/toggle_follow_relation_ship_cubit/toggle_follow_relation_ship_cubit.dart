import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/suggestion_followers/domain/repos/follow_repo.dart';

part 'toggle_follow_relation_ship_state.dart';

class ToggleFollowRelationShipCubit
    extends Cubit<ToggleFollowRelationShipState> {
  ToggleFollowRelationShipCubit({required this.followRepo})
      : super(ToggleFollowRelationShipInitial());

  final FollowRepo followRepo;

  Future<void> toggleFollowRelationShip({
    required Map<String, dynamic> data,
    required bool isMakingFollowRelation,
  }) async {
    emit(ToggleFollowRelationShipLoadingState());
    var res = await followRepo.toggleFollowRelationShip(
      data: data,
      isMakingFollowRelation: isMakingFollowRelation,
    );
    res.fold(
      (failure) =>
          emit(ToggleFollowRelationShipFailureState(message: failure.message)),
      (success) => emit(ToggleFollowRelationShipLoadedState()),
    );
  }
}
