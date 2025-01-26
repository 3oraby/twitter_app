import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/bookmark/domain/repos/bookmark_repo.dart';

part 'toggle_bookmarks_state.dart';

class ToggleBookmarksCubit extends Cubit<ToggleBookmarksState> {
  ToggleBookmarksCubit({required this.bookmarkRepo})
      : super(ToggleBookmarksInitial());

  final BookmarkRepo bookmarkRepo;
  Future<void> toggleBookmark({
    required Map<String, dynamic> data,
  }) async {
    emit(ToggleBookmarksLoadedState());
    var res = await bookmarkRepo.toggleBookmark(data: data);
    res.fold(
      (failure) => emit(ToggleBookmarksFailureState(message: failure.message)),
      (success) => emit(ToggleBookmarksLoadedState()),
    );
  }
}
