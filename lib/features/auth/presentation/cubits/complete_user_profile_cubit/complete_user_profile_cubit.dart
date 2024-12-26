import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/user/domain/repo_interface/user_repo.dart';

part 'complete_user_profile_state.dart';

class CompleteUserProfileCubit extends Cubit<CompleteUserProfileState> {
  CompleteUserProfileCubit({required this.userRepo})
      : super(CompleteUserProfileInitial());

  final UserRepo userRepo;

  Future<void> addUserData({
    required Map<String, dynamic> data,
    required String documentId,
  }) async {
    emit(CompleteUserProfileLoadingState());
    var result = await userRepo.addUserData(
      data: data,
      documentId: documentId,
    );
    result.fold(
      (failure) =>
          emit(CompleteUserProfileFailureState(message: failure.message)),
      (success) => emit(CompleteUserProfileLoadedState()),
    );
  }
}
