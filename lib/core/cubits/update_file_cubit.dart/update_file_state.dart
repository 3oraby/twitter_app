part of 'update_file_cubit.dart';

abstract class UpdateFileState {}

final class UpdateFileInitial extends UpdateFileState {}

final class UpdateFileLoadingState extends UpdateFileState {}

final class UpdateFileLoadedState extends UpdateFileState {
  final String newPublicFileUrl;

  UpdateFileLoadedState({required this.newPublicFileUrl});
}

final class UpdateFileFailureState extends UpdateFileState {
  final String message;

  UpdateFileFailureState({required this.message});
}
