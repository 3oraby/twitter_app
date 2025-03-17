import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/helpers/functions/get_current_firebase_auth_user.dart';
import 'package:twitter_app/core/repos/files_repo/files_repo.dart';
import 'package:twitter_app/features/user/domain/repo_interface/user_repo.dart';

part 'set_user_profile_picture_state.dart';

class SetUserProfilePictureCubit extends Cubit<SetUserProfilePictureState> {
  SetUserProfilePictureCubit({
    required this.userRepo,
    required this.filesRepo,
  }) : super(AddUserProfilePictureInitial());

  final UserRepo userRepo;
  final FilesRepo filesRepo;

  Future<void> setUserProfilePicture({
    required File file,
    String? oldFileUrl,
    bool isUpload = true,
  }) async {
    emit(SetUserProfilePictureLoadingState());
    Either<Failure, String> result;
    if (isUpload || oldFileUrl == null) {
      result = await filesRepo.uploadFile(file);
    } else {
      result = await filesRepo.updateFile(
        oldFileUrl: oldFileUrl,
        file: file,
      );
    }
    result.fold(
      (failure) => emit(
        SetUserProfilePictureFailureState(message: failure.message),
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
              emit(SetUserProfilePictureFailureState(message: failure.message)),
          (success) {
            emit(
              SetUserProfilePictureLoadedState(imageUrl: imageUrl),
            );
          },
        );
      },
    );
  }
}
