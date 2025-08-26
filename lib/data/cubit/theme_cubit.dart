import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/SecureStorageService.dart';

enum AppThemeMode { system, light, dark }

class ThemeCubit extends Cubit<AppThemeMode> {
  final SecureStorageService storage;

  ThemeCubit(this.storage) : super(AppThemeMode.system);

  String get _key => 'theme';

  AppThemeMode _fromString(String? s) {
    switch (s) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
      default:
        return AppThemeMode.system;
    }
  }

  /// Call this whenever you know the current user (login / app resume)
  Future<void> setUser() async {
    try {
      final saved = await storage.getString(_key);
      // Fallback to system theme if no theme was saved
      emit(_fromString(saved) ?? AppThemeMode.system);
    } catch (e) {
      // In case of any error, default to system theme
      emit(AppThemeMode.system);
      print('Error while setting theme: $e');
    }
  }


  Future<void> setMode(AppThemeMode mode) async {
    try {
      emit(mode);
      await storage.setString(_key, mode.name);
    } catch (e) {
      // Handle any errors that may occur during storage
      print('Error while saving theme: $e');
    }
  }


  Future<void> setLightTheme() => setMode(AppThemeMode.light);
  Future<void> setDarkTheme() => setMode(AppThemeMode.dark);
  Future<void> setSystemTheme() => setMode(AppThemeMode.system);

  /// Optional: clear on logout
  Future<void> clearForCurrentUser() => storage.delete(_key);
}
