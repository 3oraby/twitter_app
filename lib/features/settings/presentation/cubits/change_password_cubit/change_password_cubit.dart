import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/auth/domain/repo_interface/auth_repo.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit({
    required this.authRepo,
  }) : super(ChangePasswordInitial());

  final AuthRepo authRepo;

  Future<void> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoadingState());
    var res = await authRepo.changePassword(
      email: email,
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    res.fold(
      (failure) => emit(ChangePasswordFailureState(message: failure.message)),
      (success) async {
        var result = await authRepo.logOut();
        result.fold(
          (failure) =>
              emit(ChangePasswordFailureState(message: failure.message)),
          (success) => emit(ChangePasswordLoadedState()),
        );
      },
    );
  }
}
