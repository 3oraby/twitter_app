import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/get_current_firebase_auth_user.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/helpers/functions/save_user_data_in_prefs.dart';
import 'package:twitter_app/core/repos/files_repo/files_repo.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/user/domain/repo_interface/user_repo.dart';

part 'add_user_profile_picture_state.dart';

class AddUserProfilePictureCubit extends Cubit<AddUserProfilePictureState> {
  AddUserProfilePictureCubit({
    required this.userRepo,
    required this.filesRepo,
  }) : super(AddUserProfilePictureInitial());

  final UserRepo userRepo;
  final FilesRepo filesRepo;

  Future<void> addUserProfilePicture({required File file}) async {
    emit(AddUserProfilePictureLoadingState());
    var result = await filesRepo.uploadFile(file);
    result.fold(
      (failure) => emit(
        AddUserProfilePictureFailureState(message: failure.message),
      ),
      (imageUrl) async {
        User user = getCurrentFirebaseAuthUser();
        var result = await userRepo.updateUserData(
          data: {
            'profilePicUrl': imageUrl,
          },
          documentId: user.uid,
        );
        result.fold(
          (failure) =>
              emit(AddUserProfilePictureFailureState(message: failure.message)),
          (success) async {
            //! save user data
            UserEntity userEntity = getCurrentUserEntity();
            userEntity.profilePicUrl = imageUrl;
            await saveUserDataInPrefs(user: userEntity);
            emit(
              AddUserProfilePictureLoadedState(imageUrl: imageUrl),
            );
          },
        );
      },
    );
  }
}
