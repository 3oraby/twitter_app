import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/auth/domain/repo_interface/auth_repo.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit({required this.authRepo}) : super(LogoutInitial());

  final AuthRepo authRepo;

  Future<void> logOut() async {
    emit(LogoutLoadingState());
    final result = await authRepo.logOut();
    result.fold(
      (failure) => emit(LogOutFailureState(message: failure.message)),
      (success) => emit(LogoutLoadedState()),
    );
  }
}
