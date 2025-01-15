part of 'get_user_connections_cubit.dart';

abstract class GetUserConnectionsState {}

final class GetUserConnectionsInitial extends GetUserConnectionsState {}

final class GetUserConnectionsLoadingState extends GetUserConnectionsState {}

final class GetUserConnectionsEmptyState extends GetUserConnectionsState {}

final class GetUserConnectionsLoadedState extends GetUserConnectionsState {
  final List<UserWithFollowStatusEntity> userConnections;
  GetUserConnectionsLoadedState({required this.userConnections});
}

final class GetUserConnectionsFailureState extends GetUserConnectionsState {
  final String message;
  GetUserConnectionsFailureState({required this.message});
}
