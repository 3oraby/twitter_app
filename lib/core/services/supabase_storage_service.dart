import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:twitter_app/core/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/core/utils/supabase_buckets_name.dart';
import 'package:twitter_app/env/env.dart';

class SupabaseStorageService extends StorageService {
  static late Supabase _supabase;

  static Future<void> supabaseInit() async {
    _supabase = await Supabase.initialize(
      url: BackendEndpoints.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
    );
  }

  @override
  Future<String> uploadFile(File file, String path) async {
    String fileName = basename(file.path);
    String uploadPath = "$path/${DateTime.now()}/$fileName";
    await _supabase.client.storage
        .from(SupabaseBucketsName.twitterImages)
        .upload(
          uploadPath,
          file,
        );

    String publicFileUrl = _supabase.client.storage
        .from(SupabaseBucketsName.twitterImages)
        .getPublicUrl(uploadPath);
    log("------------------------- upload file ------------------------");
    log("fileName: $fileName");
    log("uploadPath: $uploadPath");
    log("publicFileUrl: $publicFileUrl");
    log("--------------------------------------------------------------");
    return publicFileUrl;
  }

  @override
  Future<void> deleteFiles(List<String> paths) async {
    try {
      log("------------------------- delete file ------------------------");

      List<String> uploadPaths = paths
          .map((url) => convertPublicUrlToUploadPath(
                publicUrl: url,
                bucketName: SupabaseBucketsName.twitterImages,
              ))
          .toList();

      await _supabase.client.storage
          .from(SupabaseBucketsName.twitterImages)
          .remove(uploadPaths);

      log("Successfully deleted files: $uploadPaths");
      log("--------------------------------------------------------------");
    } catch (e) {
      log("Error deleting files: $e");
      throw Exception("Failed to delete files from storage");
    }
  }

  String convertPublicUrlToUploadPath({
    required String publicUrl,
    required String bucketName,
  }) {
    Uri uri = Uri.parse(publicUrl);
    String uploadPath = uri.path.split("public/").last;
    uploadPath = uploadPath.replaceFirst("$bucketName/", "");
    uploadPath = Uri.decodeComponent(uploadPath);

    return uploadPath;
  }

  @override
  Future<String> updateFile({
    required String oldFileUrl,
    required File newFile,
  }) async {
    try {
      log("------------------------- update file ------------------------");

      String uploadPath = convertPublicUrlToUploadPath(
        publicUrl: oldFileUrl,
        bucketName: SupabaseBucketsName.twitterImages,
      );

      log("upload path: $uploadPath");

      await _supabase.client.storage
          .from(SupabaseBucketsName.twitterImages)
          .update(
            uploadPath,
            newFile,
          );

      String newPublicFileUrl = _supabase.client.storage
          .from(SupabaseBucketsName.twitterImages)
          .getPublicUrl(uploadPath);

      log("Successfully update file: $newPublicFileUrl");
      log("--------------------------------------------------------------");
      return newPublicFileUrl;
    } catch (e) {
      log("Error update files: $e");
      throw Exception("Failed to update file from storage");
    }
  }
}
