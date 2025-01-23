part of 'toggle_retweet_cubit.dart';

abstract class ToggleRetweetState {}

final class ToggleRetweetInitial extends ToggleRetweetState {}

final class ToggleRetweetLoadingState extends ToggleRetweetState {}

final class ToggleRetweetLoadedState extends ToggleRetweetState {}

final class ToggleRetweetFailureState extends ToggleRetweetState {
  final String message;

  ToggleRetweetFailureState({required this.message});
}
