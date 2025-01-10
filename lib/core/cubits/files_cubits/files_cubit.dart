
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/repos/files_repo/files_repo.dart';

part 'files_state.dart';

class FilesCubit extends Cubit<FilesState> {
  FilesCubit({required this.filesRepo}) : super(FilesInitial());

  final FilesRepo filesRepo;
  
  // Future<void> 
}
