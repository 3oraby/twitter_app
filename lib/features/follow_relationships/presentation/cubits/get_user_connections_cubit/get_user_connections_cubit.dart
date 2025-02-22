import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/follow_relationships/domain/entities/user_with_follow_status_entity.dart';
import 'package:twitter_app/features/follow_relationships/domain/repos/follow_repo.dart';

part 'get_user_connections_state.dart';

class GetUserConnectionsCubit extends Cubit<GetUserConnectionsState> {
  GetUserConnectionsCubit({required this.followRepo})
      : super(GetUserConnectionsInitial());

  final FollowRepo followRepo;

  Future<void> getUserConnections({
    required String targetUserId,
    required bool isFetchingFollowers,
  }) async {
    emit(GetUserConnectionsLoadingState());
    var res = await followRepo.getUserConnections(
      targetUserId: targetUserId,
      isFetchingFollowers: isFetchingFollowers,
    );
    res.fold(
        (failure) =>
            emit(GetUserConnectionsFailureState(message: failure.message)),
        (userConnections) {
      if (userConnections.isEmpty) {
        emit(GetUserConnectionsEmptyState());
      } else {
        emit(GetUserConnectionsLoadedState(userConnections: userConnections));
      }
    });
  }
}
