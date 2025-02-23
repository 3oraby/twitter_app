import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/follow_relationships/domain/entities/user_with_follow_status_entity.dart';
import 'package:twitter_app/features/search/domain/repos/users_search_repo.dart';

part 'get_users_search_state.dart';

class GetUsersSearchCubit extends Cubit<GetUsersSearchState> {
  GetUsersSearchCubit({
    required this.usersSearchRepo,
  }) : super(GetUsersSearchInitial());

  final UsersSearchRepo usersSearchRepo;

  Future<void> getUsersSearch({
    required String query,
    int? limit,
  }) async {
    emit(GetUsersSearchLoadingState());
    var res = await usersSearchRepo.searchUsers(
      query: query,
      limit: limit,
    );

    res.fold(
      (failure) => emit(GetUsersSearchFailureState(message: failure.message)),
      (users) => users.isEmpty
          ? emit(GetUsersSearchEmptyState())
          : emit(GetUsersSearchLoadedState(users: users)),
    );
  }
}
