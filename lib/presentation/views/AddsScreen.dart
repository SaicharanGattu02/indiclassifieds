import 'package:flutter/material.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/app_colors.dart';
import '../../theme/ThemeHelper.dart';

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

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  AdStatus selectedStatus = AdStatus.active;

  final List<Ad> _allAds = [
    Ad(
      title: 'Mercedes-Benz GLC',
      imageUrl: 'assets/images/carimg.png',
      yearKmTrans: '2023 • 15,000 km • Automatic',
      price: '₹9,58,900',
      postedDate: 'Posted Jul 1, 2025',
      views: 245,
      interested: 12,
      status: AdStatus.active,
    ),
    Ad(
      title: 'Audi RS7 Sportback',
      imageUrl: 'assets/images/carimg.png',
      yearKmTrans: '2024 • 8,500 km • Automatic',
      price: '₹1,115,000',
      postedDate: 'Posted Jun 28, 2025',
      views: 189,
      interested: 8,
      status: AdStatus.active,
    ),
    Ad(
      title: 'Tesla Model 3 Long Range',
      imageUrl: 'assets/images/carimg.png',
      yearKmTrans: '2024 • 5,200 km • Automatic',
      price: '₹1,45,500',
      postedDate: 'Posted Jun 25, 2025',
      views: 312,
      interested: 15,
      status: AdStatus.pending,
    ),
    Ad(
      title: 'Honda Fit Hybrid',
      imageUrl: 'assets/images/carimg.png',
      yearKmTrans: '2021 • 28,500 km • Automatic',
      price: '₹8,19,800',
      postedDate: 'Posted Jun 20, 2025',
      views: 178,
      interested: 6,
      status: AdStatus.expired,
    ),
    Ad(
      title: 'BMW 5 Series 530i',
      imageUrl: 'assets/images/carimg.png',
      yearKmTrans: '2023 • 12,000 km • Automatic',
      price: '₹7,62,500',
      postedDate: 'Posted Jun 15, 2025',
      views: 201,
      interested: 9,
      status: AdStatus.active,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final textColor = ThemeHelper.textColor(context);
    final bgColor = ThemeHelper.backgroundColor(context);

    final List<Ad> visibleAds = _allAds.where((a) => a.status == selectedStatus).toList();

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: AdStatus.values.map((status) {
                final isSelected = selectedStatus == status;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextButton(
                      onPressed: () => setState(() => selectedStatus = status),
                      style: TextButton.styleFrom(
                        backgroundColor: isSelected ? AppColors.primary : Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
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
          Expanded(
            child: visibleAds.isEmpty
                ? Center(
              child: Text(
                'No ${selectedStatus.label.toLowerCase()} ads',
                style: AppTextStyles.bodyMedium(textColor),
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: visibleAds.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, index) {
                final ad = visibleAds[index];
                return _AdCard(ad: ad, isDark: isDark, textColor: textColor);
              },
            ),
          ),
        ],
      ),
    );
  }
}
class _AdCard extends StatelessWidget {
  final Ad ad;
  final bool isDark;
  final Color textColor;

  const _AdCard({
    required this.ad,
    required this.isDark,
    required this.textColor,
    Key? key,
  }) : super(key: key);

  Color getStatusColor(AdStatus status) {
    switch (status) {
      case AdStatus.active:
        return Colors.green.shade700;
      case AdStatus.pending:
        return Colors.orange.shade800;
      case AdStatus.expired:
        return Colors.red.shade700;
    }
  }

  Color getStatusBgColor(AdStatus status) {
    switch (status) {
      case AdStatus.active:
        return Colors.green.shade100;
      case AdStatus.pending:
        return Colors.orange.shade100;
      case AdStatus.expired:
        return Colors.red.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: isDark
            ? []
            : [
          BoxShadow(
            color: Colors.black12.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Top: Image, title, specs, price, status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  ad.imageUrl,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.title,
                      style: AppTextStyles.bodyMedium(textColor).copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ad.yearKmTrans,
                      style: AppTextStyles.bodySmall(Colors.grey.shade600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ad.price,
                      style: AppTextStyles.titleLarge(Colors.blue),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getStatusBgColor(ad.status),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  ad.status.label,
                  style: AppTextStyles.labelSmall(getStatusColor(ad.status)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Middle: stats + posted date
          Row(
            children: [
              Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text("${ad.views} views", style: AppTextStyles.labelSmall(Colors.grey.shade600)),
              const SizedBox(width: 16),
              Icon(Icons.person_outline, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text("${ad.interested} interested", style: AppTextStyles.labelSmall(Colors.grey.shade600)),
              const Spacer(),
              Text(ad.postedDate, style: AppTextStyles.labelSmall(Colors.grey.shade600)),
            ],
          ),

          const Divider(height: 24),

          // Bottom: Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ActionButton(icon: Icons.edit_outlined, label: 'Edit', onTap: () {}),
              _ActionButton(icon: Icons.delete_outline, label: 'Delete', textColor: Colors.grey.shade600, onTap: () {}),
              _ActionButton(icon: Icons.campaign_outlined, label: 'Promote', onTap: () {}),
              _ActionButton(icon: Icons.sell_outlined, label: 'Mark Sold', onTap: () {}),
            ],
          ),
        ],
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
