part of 'toggle_bookmarks_cubit.dart';

abstract class ToggleBookmarksState {}

final class ToggleBookmarksInitial extends ToggleBookmarksState {}

final class ToggleBookmarksLoadingState extends ToggleBookmarksState {}

final class ToggleBookmarksLoadedState extends ToggleBookmarksState {}

final class ToggleBookmarksFailureState extends ToggleBookmarksState {
  final String message;
  ToggleBookmarksFailureState({required this.message});
}
