part of 'change_password_cubit.dart';

abstract class ChangePasswordState {}

final class ChangePasswordInitial extends ChangePasswordState {}

final class ChangePasswordLoadingState extends ChangePasswordState {}

final class ChangePasswordLoadedState extends ChangePasswordState {}

final class ChangePasswordFailureState extends ChangePasswordState {
  final String message;

  ChangePasswordFailureState({required this.message});
}
