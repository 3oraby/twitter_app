import 'dart:io';

import 'package:twitter_app/core/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class SupabaseStorageService extends StorageService {
  
  static late Supabase _supabase;
  
  static Future<void> supabaseInit() async {
    _supabase = await Supabase.initialize(
      url: 'https://ohbgfbpjtbzfvpgsfret.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9oYmdmYnBqdGJ6ZnZwZ3NmcmV0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU0MDcxNDYsImV4cCI6MjA1MDk4MzE0Nn0.tktAfob4xUEBdSikYK9axRymRDY4O0s_qhq7_0WYL7w',
    );
  }

  @override
  Future<String> uploadFile(File file, String path) {
    throw UnimplementedError();
  }
}
