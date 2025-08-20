import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/cubit/MyAds/my_ads_cubit.dart';
import '../../data/cubit/MyAds/my_ads_states.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/app_colors.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/AdCardDynamic.dart';
import '../../widgets/CommonLoader.dart';

enum AdStatus { approved, pending, expired }

extension AdStatusLabel on AdStatus {
  String get label {
    switch (this) {
      case AdStatus.approved: return 'Approved';
      case AdStatus.pending:  return 'Pending';
      case AdStatus.expired:  return 'Expired';
    }
  }

  /// API param to send
  String get apiParam {
    switch (this) {
      case AdStatus.approved: return 'approved';
      case AdStatus.pending:  return 'pending';
      case AdStatus.expired:  return 'expired';
    }
  }
}

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  AdStatus selectedStatus = AdStatus.approved;

  @override
  void initState() {
    super.initState();
    // initial fetch for "approved"
    context.read<MyAdsCubit>().getMyAds(selectedStatus.apiParam);
  }

  void _onChangeTab(AdStatus status) {
    setState(() => selectedStatus = status);
    context.read<MyAdsCubit>().getMyAds(status.apiParam); // resets to page 1
  }

  bool _onScrollNotification(ScrollNotification sn, bool hasNextPage) {
    if (!hasNextPage) return false;

    final isScrollEnd = sn.metrics.pixels >= (sn.metrics.maxScrollExtent - 200);
    final movingForward = sn is ScrollUpdateNotification && sn.scrollDelta != null && sn.scrollDelta! > 0;

    if (isScrollEnd && movingForward) {
      context.read<MyAdsCubit>().getMoreMyAds(selectedStatus.apiParam);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final textColor = ThemeHelper.textColor(context);
    final bgColor   = ThemeHelper.backgroundColor(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: BackButton(color: textColor),
        title: Text('Your Ads', style: AppTextStyles.titleLarge(textColor)),
      ),
      body: Column(
        children: [
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: AdStatus.values.map((status) {
                final isSelected = selectedStatus == status;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextButton(
                      onPressed: () => _onChangeTab(status),
                      style: TextButton.styleFrom(
                        backgroundColor: isSelected ? AppColors.primary : Colors.grey.shade200,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        status.label.toUpperCase(),
                        style: AppTextStyles.bodyMedium(
                          isSelected ? Colors.white : Colors.grey.shade700,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // List + pagination
          Expanded(
            child: BlocBuilder<MyAdsCubit, MyAdsStates>(
              builder: (context, state) {
                final isLoading     = state is MyAdsLoading || state is MyAdsInitially;
                final isLoadingMore = state is MyAdsLoadingMore;
                final hasNextPage   = (state is MyAdsLoaded) ? state.hasNextPage
                    : (state is MyAdsLoadingMore) ? state.hasNextPage
                    : false;

                if (isLoading) {
                  return Center(child:DottedProgressWithLogo());
                }

                if (state is MyAdsFailure) {
                  return Center(
                    child: Text(state.error.isEmpty ? 'Failed to load ads' : state.error,
                        style: AppTextStyles.bodyMedium(textColor)),
                  );
                }

                final model = (state is MyAdsLoaded)
                    ? state.myAdsModel
                    : (state is MyAdsLoadingMore)
                    ? state.myAdsModel
                    : null ;

                final items = model?.data ?? [];

                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'No ${selectedStatus.label.toLowerCase()} ads',
                      style: AppTextStyles.bodyMedium(textColor),
                    ),
                  );
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (sn) => _onScrollNotification(sn, hasNextPage),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length + (isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, index) {
                      if (isLoadingMore && index == items.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final ad = items[index];
                      return AdCardDynamic(ad: ad, isDark: isDark, textColor: textColor);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


