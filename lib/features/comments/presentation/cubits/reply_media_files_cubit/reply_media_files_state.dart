part of 'reply_media_files_cubit.dart';

abstract class ReplyMediaFilesState {}

final class ReplyMediaFilesInitial extends ReplyMediaFilesState {}

class ReplyMediaFilesUpdatedState extends ReplyMediaFilesState {
  final List<File> mediaFiles;

  ReplyMediaFilesUpdatedState({required this.mediaFiles});
}
