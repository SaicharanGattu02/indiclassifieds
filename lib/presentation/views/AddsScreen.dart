import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/AppTheme.dart';
import '../../theme/app_colors.dart';

enum AdStatus { active, pending, expired }

extension AdStatusLabel on AdStatus {
  String get label {
    switch (this) {
      case AdStatus.active:
        return 'Active';
      case AdStatus.pending:
        return 'Pending';
      case AdStatus.expired:
        return 'Expired';
    }
  }
}

class Ad {
  final String title, imageUrl, yearKmTrans, price, postedDate;
  final int views, interested;
  final AdStatus status;

  Ad({
    required this.title,
    required this.imageUrl,
    required this.yearKmTrans,
    required this.price,
    required this.postedDate,
    required this.views,
    required this.interested,
    required this.status,
  });
}

class AdsScreen extends StatelessWidget {
  AdsScreen({super.key});

  final List<Ad> _allAds = [
    Ad(
      title: 'Mercedes-Benz GLC',
      imageUrl: 'assets/appleipod.png',
      yearKmTrans: '2023 • 15,000 km • Automatic',
      price: '₹9,58,900',
      postedDate: 'Posted Jul 1, 2025',
      views: 245,
      interested: 12,
      status: AdStatus.active,
    ),
    Ad(
      title: 'Audi RS7 Sportback',
      imageUrl: 'assets/cycleride.png',
      yearKmTrans: '2024 • 8,500 km • Automatic',
      price: '₹11,15,000',
      postedDate: 'Posted Jun 28, 2025',
      views: 189,
      interested: 8,
      status: AdStatus.active,
    ),
    Ad(
      title: 'Tesla Model 3 Long Range',
      imageUrl: 'assets/gamepad.png',
      yearKmTrans: '2024 • 5,200 km • Automatic',
      price: '₹14,55,00',
      postedDate: 'Posted Jun 25, 2025',
      views: 312,
      interested: 15,
      status: AdStatus.active,
    ),
    // add more ads here, even with pending/expired statuses
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.getLightTheme(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: const BackButton(color: AppColors.darkText),
            title: Text(
              'Your Ads',
              style: AppTextStyles.titleLarge(AppColors.darkText),
            ),
            elevation: 0,
            backgroundColor: AppColors.lightBackground,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: AppTextStyles.bodyLarge(Colors.white),
                  unselectedLabelStyle: AppTextStyles.bodyLarge(Colors.grey),
                  tabs: const [
                    Tab(text: 'ACTIVE'),
                    Tab(text: 'PENDING'),
                    Tab(text: 'EXPIRED'),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: AdStatus.values.map((status) {
              final ads = _allAds.where((a) => a.status == status).toList();
              if (ads.isEmpty) {
                return Center(
                  child: Text(
                    'No ${status.label.toLowerCase()} ads',
                    style: AppTextStyles.bodyMedium(AppColors.darkText),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: ads.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, i) => _AdCard(ad: ads[i]),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// ←←← REPLACED CARD BEGINS HERE ←←←

class _AdCard extends StatelessWidget {
  final Ad ad;
  const _AdCard({required this.ad, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: image / title+details / status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(ad.imageUrl, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ad.title,
                        style: AppTextStyles.headlineSmall(AppColors.darkText),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ad.yearKmTrans,
                        style: AppTextStyles.bodySmall(Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    ad.status.label,
                    style: AppTextStyles.labelMedium(Colors.green.shade700),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Price
            Text(ad.price, style: AppTextStyles.titleLarge(AppColors.primary)),

            const SizedBox(height: 12),

            // Stats + Posted date
            Row(
              children: [
                Icon(
                  Icons.remove_red_eye_outlined,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  '${ad.views}',
                  style: AppTextStyles.bodySmall(Colors.grey.shade600),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  '${ad.interested}',
                  style: AppTextStyles.bodySmall(Colors.grey.shade600),
                ),
                const Spacer(),
                Text(
                  ad.postedDate,
                  style: AppTextStyles.bodySmall(Colors.grey.shade600),
                ),
              ],
            ),

            const Divider(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ActionButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  onTap: () {
                    /* TODO */
                  },
                ),
                _ActionButton(
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  textColor: Colors.grey.shade600,
                  onTap: () {
                    /* TODO */
                  },
                ),
                _ActionButton(
                  icon: Icons.campaign_outlined,
                  label: 'Promote',
                  onTap: () {
                    /* TODO */
                  },
                ),
                _ActionButton(
                  icon: Icons.sell_outlined,
                  label: 'Mark Sold',
                  onTap: () {
                    /* TODO */
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.textColor = AppColors.primary,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Row(
          children: [
            Icon(icon, size: 16, color: textColor),
            const SizedBox(width: 4),
            Text(label, style: AppTextStyles.bodyMedium(textColor)),
          ],
        ),
      ),
    );
  }
}
