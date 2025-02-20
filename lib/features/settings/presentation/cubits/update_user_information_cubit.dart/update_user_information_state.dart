part of 'update_user_information_cubit.dart';

abstract class UpdateUserInformationState {}

final class UpdateUserInformationInitial extends UpdateUserInformationState {}

final class UpdateUserInformationLoadingState
    extends UpdateUserInformationState {}

final class UpdateUserInformationLoadedState
    extends UpdateUserInformationState {}

final class UpdateUserInformationFailure extends UpdateUserInformationState {
  final String message;

  UpdateUserInformationFailure({required this.message});
}
