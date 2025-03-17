import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/local_storage_data_names.dart';
import 'package:twitter_app/core/services/shared_preferences_singleton.dart';
import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/user/domain/repo_interface/user_repo.dart';

part 'complete_user_profile_state.dart';

class CompleteUserProfileCubit extends Cubit<CompleteUserProfileState> {
  CompleteUserProfileCubit({required this.userRepo})
      : super(CompleteUserProfileInitial());

  final UserRepo userRepo;

  Future<void> addUserToFirestore({
    required Map<String, dynamic> data,
    required String documentId,
  }) async {
    emit(CompleteUserProfileLoadingState());
    var result = await userRepo.addUserToFirestore(
      data: data,
      documentId: documentId,
    );
    result.fold(
      (failure) =>
          emit(CompleteUserProfileFailureState(message: failure.message)),
      (success) async {
        emit(
          CompleteUserProfileLoadedState(userEntity: UserModel.fromJson(data)),
        );
        await SharedPreferencesSingleton.setBool(
            LocalStorageDataNames.kIsSignUpCompleted, false);
      },
    );
  }
}
