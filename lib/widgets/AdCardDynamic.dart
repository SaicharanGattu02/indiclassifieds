import 'package:flutter/material.dart';
import '../model/MyAdsModel.dart';
import '../theme/AppTextStyles.dart';
import 'ActionButton.dart';

class AdCardDynamic extends StatelessWidget {
  final Data ad;
  final bool isDark;
  final Color textColor;

  const AdCardDynamic({
    required this.ad,
    required this.isDark,
    required this.textColor,
    Key? key,
  }) : super(key: key);

  Color _statusColor(String? status) {
    switch ((status ?? '').toLowerCase()) {
      case 'approved':
        return Colors.green.shade700;
      case 'pending':
        return Colors.orange.shade800;
      case 'expired':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Color _statusBgColor(String? status) {
    switch ((status ?? '').toLowerCase()) {
      case 'approved':
        return Colors.green.shade100;
      case 'pending':
        return Colors.orange.shade100;
      case 'expired':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  String _priceText(String? price) =>
      (price == null || price.isEmpty) ? '—' : "₹$price";

  String _postedText(String? postedAt) =>
      (postedAt == null || postedAt.isEmpty) ? '' : postedAt;

  @override
  Widget build(BuildContext context) {
    final imageUrl = ad.image ?? '';
    final location = ad.location ?? '';

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
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Top row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageUrl.isEmpty
                    ? Container(
                        width: 64,
                        height: 64,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.directions_car_filled_outlined),
                      )
                    : Image.network(
                        imageUrl,
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
                      ad.title ?? 'Untitled',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium(
                        textColor,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location.isEmpty ? (ad.description ?? '') : location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall(Colors.grey.shade600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _priceText(ad.price),
                      style: AppTextStyles.titleLarge(Colors.blue),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusBgColor(ad.status),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  (ad.status ?? '').isEmpty
                      ? '—'
                      : ad.status!.substring(0, 1).toUpperCase() +
                            ad.status!.substring(1),
                  style: AppTextStyles.labelSmall(_statusColor(ad.status)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Middle: stats + posted date (using likes as "interested" if needed)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _postedText(ad.postedAt),
                style: AppTextStyles.labelSmall(Colors.grey.shade600),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 0.5),

          // Bottom actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ActionButton(
                icon: Icons.edit_outlined,
                label: 'Edit',
                onTap: () {},
              ),
              ActionButton(
                icon: Icons.delete_outline,
                label: 'Delete',
                textColor: Colors.grey.shade600,
                onTap: () {},
              ),
              ActionButton(
                icon: Icons.campaign_outlined,
                label: 'Promote',
                onTap: () {},
              ),
              ActionButton(
                icon: Icons.sell_outlined,
                label: 'Mark Sold',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
