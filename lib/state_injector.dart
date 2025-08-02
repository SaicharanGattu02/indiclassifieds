import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/data/cubit/theme_cubit.dart';
import 'data/bloc/internet_status/internet_status_bloc.dart';
import 'data/cubit/LogInWithMobileCubit/login_with_mobile.dart';
import 'data/cubit/LogInWithMobileCubit/login_with_mobile_repository.dart';
import 'data/cubit/category/category_cubit.dart';
import 'data/cubit/category/category_repository.dart';
import 'data/remote_data_source.dart';

class StateInjector {
  static final repositoryProviders = <RepositoryProvider>[
    RepositoryProvider<RemoteDataSource>(
      create: (context) => RemoteDataSourceImpl(),
    ),
    RepositoryProvider<LogInWithMobileRepository>(
      create: (context) => LogInMobileRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<CategoryRepository>(
      create: (context) => CategoryRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
  ];

  static final blocProviders = <BlocProvider>[
    BlocProvider<InternetStatusBloc>(create: (context) => InternetStatusBloc()),
    BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
    BlocProvider<LogInwithMobileCubit>(
      create: (context) =>
          LogInwithMobileCubit(context.read<LogInWithMobileRepository>()),
    ),
    BlocProvider<CategoryCubit>(
      create: (context) => CategoryCubit(context.read<CategoryRepository>()),
    ),
  ];
}
