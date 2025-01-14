part of 'toggle_follow_relation_ship_cubit.dart';

abstract class ToggleFollowRelationShipState {}

final class ToggleFollowRelationShipInitial
    extends ToggleFollowRelationShipState {}

final class ToggleFollowRelationShipLoadingState
    extends ToggleFollowRelationShipState {}

final class ToggleFollowRelationShipLoadedState
    extends ToggleFollowRelationShipState {}

final class ToggleFollowRelationShipFailureState
    extends ToggleFollowRelationShipState {
  final String message;
  ToggleFollowRelationShipFailureState({required this.message});
}
