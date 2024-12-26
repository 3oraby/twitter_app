import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/auth/data/repo_impl/auth_repo_impl.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required this.authRepoImpl}) : super(SignUpInitial());
  final AuthRepoImpl authRepoImpl;

  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    emit(SignUpLoadingState());
    final result = await authRepoImpl.createUserWithEmailAndPassword(
        email: email, password: password);
    result.fold(
      (failure) => emit(SignUpFailureState(message: failure.message)),
      (userEntity) => emit(SignUpLoadedState()),
    );
  }
}
