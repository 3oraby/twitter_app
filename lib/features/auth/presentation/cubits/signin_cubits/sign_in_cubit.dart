
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/auth/data/repo_impl/auth_repo_impl.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({required this.authRepoImpl}) : super(SignInInitial());

  final AuthRepoImpl authRepoImpl;

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    emit(SignInLoadingState());
    final result = await authRepoImpl.signInWithEmailAndPassword(
        email: email, password: password);
    result.fold(
      (failure) => emit(SignInFailureState(message: failure.message)),
      (userEntity) => emit(SignInLoadedState()),
    );
  }
}
