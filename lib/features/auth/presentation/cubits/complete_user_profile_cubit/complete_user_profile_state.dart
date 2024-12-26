part of 'complete_user_profile_cubit.dart';

abstract class CompleteUserProfileState {}

final class CompleteUserProfileInitial extends CompleteUserProfileState {}

final class CompleteUserProfileLoadingState extends CompleteUserProfileState {}

final class CompleteUserProfileLoadedState extends CompleteUserProfileState {}

final class CompleteUserProfileFailureState extends CompleteUserProfileState {
  final String message;
  CompleteUserProfileFailureState({required this.message});
}
