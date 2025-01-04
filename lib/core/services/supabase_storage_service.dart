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
    // String extensionName = extension(file.path);
    String uploadPath = "$path/$fileName";
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
}
