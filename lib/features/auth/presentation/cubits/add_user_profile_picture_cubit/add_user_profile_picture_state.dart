part of 'add_user_profile_picture_cubit.dart';

abstract class AddUserProfilePictureState {}

final class AddUserProfilePictureInitial extends AddUserProfilePictureState {}

final class AddUserProfilePictureLoadingState
    extends AddUserProfilePictureState {}

final class AddUserProfilePictureLoadedState
    extends AddUserProfilePictureState {
  final String imageUrl;
  AddUserProfilePictureLoadedState({required this.imageUrl});
}

final class AddUserProfilePictureFailureState
    extends AddUserProfilePictureState {
      final String message;
      AddUserProfilePictureFailureState({required this.message});
    }
