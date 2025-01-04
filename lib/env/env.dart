// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
    @EnviedField(varName: 'supabaseAnonKey')
    static const String supabaseAnonKey = _Env.supabaseAnonKey;
}