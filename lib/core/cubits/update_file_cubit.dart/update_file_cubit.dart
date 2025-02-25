
import 'package:flutter_bloc/flutter_bloc.dart';

part 'update_file_state.dart';

class UpdateFileCubit extends Cubit<UpdateFileState> {
  UpdateFileCubit() : super(UpdateFileInitial());
}
