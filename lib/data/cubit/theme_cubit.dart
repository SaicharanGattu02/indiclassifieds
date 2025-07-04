import 'package:flutter_bloc/flutter_bloc.dart';

enum AppThemeMode { system, light, dark }

class ThemeCubit extends Cubit<AppThemeMode> {
  ThemeCubit() : super(AppThemeMode.system);

  void setLightTheme() => emit(AppThemeMode.light);
  void setDarkTheme() => emit(AppThemeMode.dark);
  void setSystemTheme() => emit(AppThemeMode.system);
}
