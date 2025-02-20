import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/user/domain/repo_interface/user_repo.dart';

part 'update_user_information_state.dart';

class UpdateUserInformationCubit extends Cubit<UpdateUserInformationState> {
  UpdateUserInformationCubit({
    required this.userRepo,
  }) : super(UpdateUserInformationInitial());

  final UserRepo userRepo;

  Future<void> updateUserData({
    required Map<String, dynamic> data,
    required String documentId,
  }) async {
    emit(UpdateUserInformationLoadingState());
    var res = await userRepo.updateUserData(data: data, documentId: documentId);
    res.fold(
      (failure) => emit(
        UpdateUserInformationFailure(message: failure.message),
      ),
      (success) => emit(UpdateUserInformationLoadedState()),
    );
  }
}
