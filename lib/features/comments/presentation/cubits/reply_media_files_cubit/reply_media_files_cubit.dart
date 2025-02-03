import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'reply_media_files_state.dart';

class ReplyMediaFilesCubit extends Cubit<ReplyMediaFilesState> {
  ReplyMediaFilesCubit() : super(ReplyMediaFilesInitial());

  final List<File> _mediaFiles = [];

  List<File> get mediaFiles => List.unmodifiable(_mediaFiles);

  void addMediaFile(File file) {
    _mediaFiles.add(file);
    emit(ReplyMediaFilesUpdatedState(
        mediaFiles: List.unmodifiable(_mediaFiles)));
  }

  void removeMediaFile(int index) {
    if (index >= 0 && index < _mediaFiles.length) {
      _mediaFiles.removeAt(index);
      emit(ReplyMediaFilesUpdatedState(
          mediaFiles: List.unmodifiable(_mediaFiles)));
    }
  }

  void clearMediaFiles() {
    _mediaFiles.clear();
    emit(ReplyMediaFilesUpdatedState(
        mediaFiles: List.unmodifiable(_mediaFiles)));
  }
}
