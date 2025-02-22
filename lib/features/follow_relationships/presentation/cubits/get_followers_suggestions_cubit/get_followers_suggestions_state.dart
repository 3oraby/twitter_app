part of 'get_followers_suggestions_cubit.dart';

abstract class GetFollowersSuggestionsState {}

final class GetFollowersSuggestionsInitial
    extends GetFollowersSuggestionsState {}

final class GetFollowersSuggestionsLoadingState
    extends GetFollowersSuggestionsState {}

final class GetFollowersSuggestionsEmptyState
    extends GetFollowersSuggestionsState {}

final class GetFollowersSuggestionsLoadedState
    extends GetFollowersSuggestionsState {
  final List<UserEntity> suggestionUsers;
  GetFollowersSuggestionsLoadedState({required this.suggestionUsers});
}

final class GetFollowersSuggestionsFailureState
    extends GetFollowersSuggestionsState {
  final String message;
  GetFollowersSuggestionsFailureState({required this.message});
}
