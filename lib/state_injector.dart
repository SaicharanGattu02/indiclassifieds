import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/data/cubit/City/city_cubit.dart';
import 'package:indiclassifieds/data/cubit/subCategory/sub_category_cubit.dart';
import 'package:indiclassifieds/data/cubit/subCategory/sub_category_repository.dart';
import 'package:indiclassifieds/data/cubit/theme_cubit.dart';
import 'data/bloc/internet_status/internet_status_bloc.dart';
import 'data/cubit/City/city_repository.dart';
import 'data/cubit/LogInWithMobile/login_with_mobile.dart';
import 'data/cubit/LogInWithMobile/login_with_mobile_repository.dart';
import 'data/cubit/States/states_cubit.dart';
import 'data/cubit/States/states_repository.dart';
import 'data/cubit/category/category_cubit.dart';
import 'data/cubit/category/category_repository.dart';
import 'data/cubit/commomAd/common_ad_cubit.dart';
import 'data/cubit/commomAd/common_ad_repo.dart';
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
    RepositoryProvider<SubCategoryRepository>(
      create: (context) => SubCategoryRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<SelectCityRepository>(
      create: (context) =>
          SelectCityImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<SelectStateRepository>(
      create: (context) =>
          SelectStatesImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<CommonAdRepository>(
      create: (context) =>
          CommonAdImpl(remoteDataSource: context.read<RemoteDataSource>()),
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
    BlocProvider<SubCategoryCubit>(
      create: (context) =>
          SubCategoryCubit(context.read<SubCategoryRepository>()),
    ),
    BlocProvider<SelectStatesCubit>(
      create: (context) =>
          SelectStatesCubit(context.read<SelectStateRepository>()),
    ),
    BlocProvider<SelectCityCubit>(
      create: (context) =>
          SelectCityCubit(context.read<SelectCityRepository>()),
    ),
    BlocProvider<CommonAdCubit>(
      create: (context) => CommonAdCubit(context.read<CommonAdRepository>()),
    ),
  ];
}
