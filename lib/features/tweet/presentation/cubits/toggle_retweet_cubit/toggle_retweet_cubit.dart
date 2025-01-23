import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/tweet/domain/repos/retweet_repo.dart';

part 'toggle_retweet_state.dart';

class ToggleRetweetCubit extends Cubit<ToggleRetweetState> {
  ToggleRetweetCubit({required this.retweetRepo})
      : super(ToggleRetweetInitial());

  final RetweetRepo retweetRepo;

  Future<void> toggleRetweet({
    required Map<String, dynamic> data,
  }) async {
    emit(ToggleRetweetLoadingState());
    var res = await retweetRepo.toggleRetweet(data: data);
    res.fold(
      (failure) => emit(ToggleRetweetFailureState(message: failure.message)),
      (success) => emit(ToggleRetweetLoadedState()),
    );
  }
}
