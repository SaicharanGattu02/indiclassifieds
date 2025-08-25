import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/SecureStorageService.dart';

enum AppThemeMode { system, light, dark }

class ThemeCubit extends Cubit<AppThemeMode> {
  final SecureStorageService storage;
  String _userId = 'anon';

  ThemeCubit(this.storage) : super(AppThemeMode.system);

  String get _key => 'theme_$_userId';

  AppThemeMode _fromString(String? s) {
    switch (s) {
      case 'light': return AppThemeMode.light;
      case 'dark':  return AppThemeMode.dark;
      case 'system':
      default:      return AppThemeMode.system;
    }
  }

  /// Call this whenever you know the current user (login / app resume)
  Future<void> setUser(String userId) async {
    _userId = (userId.isNotEmpty) ? userId : 'anon';
    final saved = await storage.getString(_key);
    emit(_fromString(saved));
  }

  Future<void> setMode(AppThemeMode mode) async {
    emit(mode);
    await storage.setString(_key, mode.name);
  }

  Future<void> setLightTheme() => setMode(AppThemeMode.light);
  Future<void> setDarkTheme()  => setMode(AppThemeMode.dark);
  Future<void> setSystemTheme()=> setMode(AppThemeMode.system);

  /// Optional: clear on logout
  Future<void> clearForCurrentUser() => storage.delete(_key);
}

