import 'dart:io';

abstract class StorageService {
  Future<String> uploadFile(File file, String path);
  Future<void> deleteFiles(List<String> paths);
  Future<String> updateFile({
    required String oldFileUrl,
    required File newFile,
  });
}
