import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/home/domain/repos/follow_repo.dart';

part 'get_followers_suggestions_state.dart';

class GetFollowersSuggestionsCubit extends Cubit<GetFollowersSuggestionsState> {
  GetFollowersSuggestionsCubit({required this.followRepo})
      : super(GetFollowersSuggestionsInitial());

  final FollowRepo followRepo;

  Future<void> getFollowersSuggestions({required String currentUserId}) async {
    emit(GetFollowersSuggestionsLoadingState());
    var result = await followRepo.getFollowersSuggestions(
      currentUserId: currentUserId,
    );
    result.fold(
      (failure) =>
          emit(GetFollowersSuggestionsFailureState(message: failure.message)),
      (suggestionUsers) => emit(
          GetFollowersSuggestionsLoadedState(suggestionUsers: suggestionUsers)),
    );
  }
}
