import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/services/shared_preferences_singleton.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  _loadTheme() {
    final isDark = SharedPreferencesSingleton.getBool('isDarkTheme') ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme(bool isDark) async {
    await SharedPreferencesSingleton.setBool('isDarkTheme', isDark);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
