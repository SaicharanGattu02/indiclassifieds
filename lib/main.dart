import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/state_injector.dart';
import 'package:indiclassifieds/theme/AppTheme.dart';

import 'app_routes/router.dart';
import 'data/cubit/theme_cubit.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: StateInjector.repositoryProviders,
      child: MultiBlocProvider(
        providers: StateInjector.blocProviders,
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, appThemeMode) {
        ThemeMode themeMode;
        switch (appThemeMode) {
          case AppThemeMode.light:
            themeMode = ThemeMode.light;
            break;
          case AppThemeMode.dark:
            themeMode = ThemeMode.dark;
            break;
          case AppThemeMode.system:
          default:
            themeMode = ThemeMode.system;
        }
        return MaterialApp.router(
          title: 'Flutter Theme Example',
          theme: AppTheme.getLightTheme(),
          darkTheme: AppTheme.getDarkTheme(),
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
        );
      },
    );
  }
}
