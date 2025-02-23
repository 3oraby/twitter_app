part of 'get_users_search_cubit.dart';

abstract class GetUsersSearchState {}

final class GetUsersSearchInitial extends GetUsersSearchState {}

final class GetUsersSearchLoadingState extends GetUsersSearchState {}

final class GetUsersSearchEmptyState extends GetUsersSearchState {}

final class GetUsersSearchLoadedState extends GetUsersSearchState {
  final List<UserEntity> users;

  GetUsersSearchLoadedState({required this.users});
}

final class GetUsersSearchFailureState extends GetUsersSearchState {
  final String message;

  GetUsersSearchFailureState({required this.message});
}
