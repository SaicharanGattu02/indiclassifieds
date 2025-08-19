import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/data/cubit/AddToWishlist/addToWishlistCubit.dart';
import 'package:indiclassifieds/data/cubit/Advertisement/advertisement_cubit.dart';
import 'package:indiclassifieds/data/cubit/Advertisement/advertisement_repo.dart';
import 'package:indiclassifieds/data/cubit/AdvertisementDetails/advertisement_details_cubit.dart';
import 'package:indiclassifieds/data/cubit/Banners/banner_cubit.dart';
import 'package:indiclassifieds/data/cubit/Banners/banner_repository.dart';
import 'package:indiclassifieds/data/cubit/Categories/categories_cubit.dart';
import 'package:indiclassifieds/data/cubit/Categories/categories_repository.dart';
import 'package:indiclassifieds/data/cubit/City/city_cubit.dart';
import 'package:indiclassifieds/data/cubit/Dashboard/DashboardCubit.dart';
import 'package:indiclassifieds/data/cubit/MyAds/my_ads_cubit.dart';
import 'package:indiclassifieds/data/cubit/MyAds/my_ads_repo.dart';
import 'package:indiclassifieds/data/cubit/Packages/packages_cubit.dart';
import 'package:indiclassifieds/data/cubit/Packages/packages_repository.dart';
import 'package:indiclassifieds/data/cubit/Plans/plans_cubit.dart';
import 'package:indiclassifieds/data/cubit/Plans/plans_repository.dart';
import 'package:indiclassifieds/data/cubit/ProductDetails/product_details_cubit.dart';
import 'package:indiclassifieds/data/cubit/ProductDetails/product_details_repo.dart';
import 'package:indiclassifieds/data/cubit/Products/products_cubit.dart';
import 'package:indiclassifieds/data/cubit/Products/products_repository.dart';
import 'package:indiclassifieds/data/cubit/Profile/profile_cubit.dart';
import 'package:indiclassifieds/data/cubit/Profile/profile_repo.dart';
import 'package:indiclassifieds/data/cubit/UpdateProfile/update_profile_cubit.dart';
import 'package:indiclassifieds/data/cubit/UserActivePlans/user_active_plans_cubit.dart';
import 'package:indiclassifieds/data/cubit/Wishlist/wishlist_cubit.dart';
import 'package:indiclassifieds/data/cubit/Wishlist/wishlist_repository.dart';
import 'package:indiclassifieds/data/cubit/subCategory/sub_category_cubit.dart';
import 'package:indiclassifieds/data/cubit/subCategory/sub_category_repository.dart';
import 'package:indiclassifieds/data/cubit/theme_cubit.dart';
import 'data/bloc/internet_status/internet_status_bloc.dart';
import 'data/cubit/Ad/AstrologyAd/astrology_ad_cubit.dart';
import 'data/cubit/Ad/AstrologyAd/astrology_ad_repo.dart';
import 'data/cubit/Ad/BikesAd/bikes_ad_cubit.dart';
import 'data/cubit/Ad/BikesAd/bikes_ad_repo.dart';
import 'data/cubit/Ad/CarsAd/cars_ad_cubit.dart';
import 'data/cubit/Ad/CarsAd/cars_ad_repo.dart';
import 'data/cubit/Ad/CityRentalsAd/city_rentals_ad_cubit.dart';
import 'data/cubit/Ad/CityRentalsAd/city_rentals_ad_repo.dart';
import 'data/cubit/Ad/CoWorkingAd/co_working_ad_cubit.dart';
import 'data/cubit/Ad/CoWorkingAd/co_working_ad_repo.dart';
import 'data/cubit/Ad/CommercialvehicleAd/commercial_vehicle_ad_cubit.dart';
import 'data/cubit/Ad/CommercialvehicleAd/commercial_vehicle_ad_repo.dart';
import 'data/cubit/Ad/CommonAd/common_ad_cubit.dart';
import 'data/cubit/Ad/CommonAd/common_ad_repo.dart';
import 'data/cubit/Ad/CommunityAd/community_ad_cubit.dart';
import 'data/cubit/Ad/CommunityAd/community_ad_repo.dart';
import 'data/cubit/Ad/EducationAd/education_ad_cubit.dart';
import 'data/cubit/Ad/EducationAd/education_ad_repo.dart';
import 'data/cubit/Ad/JobsAd/jobs_ad_cubit.dart';
import 'data/cubit/Ad/JobsAd/jobs_ad_repo.dart';
import 'data/cubit/Ad/MobileAd/mobile_ad_cubit.dart';
import 'data/cubit/Ad/MobileAd/mobile_ad_repo.dart';
import 'data/cubit/Ad/PetsAd/pets_ad_cubit.dart';
import 'data/cubit/Ad/PetsAd/pets_ad_repo.dart';
import 'data/cubit/Ad/PropertyAd/popperty_ad_cubit.dart';
import 'data/cubit/Ad/PropertyAd/property_ad_repo.dart';
import 'data/cubit/City/city_repository.dart';
import 'data/cubit/LogInWithMobile/login_with_mobile.dart';
import 'data/cubit/LogInWithMobile/login_with_mobile_repository.dart';
import 'data/cubit/PostAdvertisement/post_advertisement_cubit.dart';
import 'data/cubit/States/states_cubit.dart';
import 'data/cubit/States/states_repository.dart';
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
    RepositoryProvider<BannersRepository>(
      create: (context) => BannersRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<CategoriesRepo>(
      create: (context) => CategoriesRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<ProductsRepo>(
      create: (context) =>
          ProductsRepoImpl(remoteDataSource: context.read<RemoteDataSource>()),
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
    RepositoryProvider<MobileAdRepository>(
      create: (context) =>
          MobileAdImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<PropertyAdRepository>(
      create: (context) =>
          PropertyAdImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<CarsAdRepository>(
      create: (context) =>
          CarsAdImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<BikeAdRepository>(
      create: (context) =>
          BikeAdImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<CommercialVehileAdRepository>(
      create: (context) => CommercialVehileAdImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<PetsAdRepository>(
      create: (context) =>
          PetsAdImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<JobsAdRepository>(
      create: (context) =>
          JobsAdImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<EducationAdRepository>(
      create: (context) =>
          EducationAdImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<AstrologyAdRepository>(
      create: (context) =>
          AstrologyAdImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<CommunityAdRepository>(
      create: (context) =>
          CommunityAdImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<CityRentalsAdRepository>(
      create: (context) =>
          CityRentalsAdImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<CoWorkingAdRepository>(
      create: (context) =>
          CoWorkingAdImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),

    RepositoryProvider<WishlistRepository>(
      create: (context) => WishlistRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<PlansRepository>(
      create: (context) => PlansRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<PackagesRepository>(
      create: (context) => PackagesRepositoryImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<ProductDetailsRepo>(
      create: (context) => ProductDetailsRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<MyAdsRepo>(
      create: (context) =>
          MyAdsRepoImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<ProfileRepo>(
      create: (context) =>
          ProfileRepoImpl(remoteDataSource: context.read<RemoteDataSource>()),
    ),
    RepositoryProvider<AdvertisementRepo>(
      create: (context) => AdvertisementRepoImpl(
        remoteDataSource: context.read<RemoteDataSource>(),
      ),
    ),
    RepositoryProvider<PlansRepository>(
      create: (context) => PlansRepositoryImpl(
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
    BlocProvider<BannerCubit>(
      create: (context) => BannerCubit(context.read<BannersRepository>()),
    ),
    BlocProvider<CategoriesCubit>(
      create: (context) => CategoriesCubit(context.read<CategoriesRepo>()),
    ),
    BlocProvider<ProductsCubit>(
      create: (context) => ProductsCubit(context.read<ProductsRepo>()),
    ),

    BlocProvider<UserActivePlanCubit>(
      create: (context) => UserActivePlanCubit(context.read<PlansRepository>()),
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
    BlocProvider<PropertyAdCubit>(
      create: (context) =>
          PropertyAdCubit(context.read<PropertyAdRepository>()),
    ),
    BlocProvider<CarsAdCubit>(
      create: (context) => CarsAdCubit(context.read<CarsAdRepository>()),
    ),
    BlocProvider<BikesAdCubit>(
      create: (context) => BikesAdCubit(context.read<BikeAdRepository>()),
    ),
    BlocProvider<CommercialVehileAdCubit>(
      create: (context) =>
          CommercialVehileAdCubit(context.read<CommercialVehileAdRepository>()),
    ),
    BlocProvider<PetsAdCubit>(
      create: (context) => PetsAdCubit(context.read<PetsAdRepository>()),
    ),
    BlocProvider<JobsAdCubit>(
      create: (context) => JobsAdCubit(context.read<JobsAdRepository>()),
    ),
    BlocProvider<EducationAdCubit>(
      create: (context) =>
          EducationAdCubit(context.read<EducationAdRepository>()),
    ),
    BlocProvider<AstrologyAdCubit>(
      create: (context) =>
          AstrologyAdCubit(context.read<AstrologyAdRepository>()),
    ),
    BlocProvider<CommunityAdCubit>(
      create: (context) =>
          CommunityAdCubit(context.read<CommunityAdRepository>()),
    ),
    BlocProvider<CityRentalsAdCubit>(
      create: (context) =>
          CityRentalsAdCubit(context.read<CityRentalsAdRepository>()),
    ),
    BlocProvider<CoWorkingAdCubit>(
      create: (context) =>
          CoWorkingAdCubit(context.read<CoWorkingAdRepository>()),
    ),
    BlocProvider<MobileAdCubit>(
      create: (context) => MobileAdCubit(context.read<MobileAdRepository>()),
    ),
    BlocProvider<WishlistCubit>(
      create: (context) => WishlistCubit(context.read<WishlistRepository>()),
    ),
    BlocProvider<AddToWishlistCubit>(
      create: (context) =>
          AddToWishlistCubit(context.read<WishlistRepository>()),
    ),
    BlocProvider<PlansCubit>(
      create: (context) => PlansCubit(context.read<PlansRepository>()),
    ),
    BlocProvider<PackagesCubit>(
      create: (context) => PackagesCubit(context.read<PackagesRepository>()),
    ),
    BlocProvider<ProductDetailsCubit>(
      create: (context) =>
          ProductDetailsCubit(context.read<ProductDetailsRepo>()),
    ),
    BlocProvider<MyAdsCubit>(
      create: (context) => MyAdsCubit(context.read<MyAdsRepo>()),
    ),
    BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit(context.read<ProfileRepo>()),
    ),
    BlocProvider<UpdateProfileCubit>(
      create: (context) => UpdateProfileCubit(context.read<ProfileRepo>()),
    ),
    BlocProvider<AdvertisementsCubit>(
      create: (context) =>
          AdvertisementsCubit(context.read<AdvertisementRepo>()),
    ),
    BlocProvider<PostAdvertisementsCubit>(
      create: (context) =>
          PostAdvertisementsCubit(context.read<AdvertisementRepo>()),
    ),
    BlocProvider<AdvertisementDetailsCubit>(
      create: (context) =>
          AdvertisementDetailsCubit(context.read<AdvertisementRepo>()),
    ),
    BlocProvider<DashboardCubit>(
      create: (context) => DashboardCubit(
        bannersCubit: context.read<BannerCubit>(),
        categoryCubit: context.read<CategoriesCubit>(),
        productsCubit: context.read<ProductsCubit>(),
      ),
    ),
  ];
}
