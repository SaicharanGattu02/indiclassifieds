import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/Components/CutomAppBar.dart';
import 'package:indiclassifieds/data/cubit/Products/products_cubit.dart';
import 'package:indiclassifieds/model/WishlistModel.dart';
import 'package:intl/intl.dart';

import '../../data/cubit/ProductDetails/product_details_cubit.dart';
import '../../data/cubit/ProductDetails/product_details_states.dart';
import '../../data/cubit/Products/Product_cubit1.dart';
import '../../model/ProductDetailsModel.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonLoader.dart';
import '../../widgets/SimilarProducts.dart';
import '../../widgets/SimilarProductsSection.dart';

extension DetailsX on Details {
  Map<String, dynamic> merged() {
    final map = Map<String, dynamic>.from(toJson());
    const hide = {'id', 'listing_id', 'created_at', 'updated_at'};
    map.removeWhere(
      (k, v) => hide.contains(k) || v == null || v.toString().trim().isEmpty,
    );
    return map;
  }
}

class ProductDetailsScreen extends StatefulWidget {
  final int listingId;
  final int subcategory_id;
  const ProductDetailsScreen({
    super.key,
    required this.listingId,
    required this.subcategory_id,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _pgCtrl = PageController();
  int _page = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProductDetailsCubit>().getProductDetails(widget.listingId);
    context.read<ProductsCubit1>().getProducts(
      subCategoryId: widget.subcategory_id.toString(),
    );
  }

  @override
  void dispose() {
    _pgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final bgColor = ThemeHelper.backgroundColor(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppBar1(title: 'Details', actions: []),
      bottomNavigationBar: _BottomCtaBar(
        onContact: () {
        },
        onChat: () {
        },
      ),
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsStates>(
        builder: (context, state) {
          if (state is ProductDetailsLoading ||
              state is ProductDetailsInitially) {
            return Center(child: DottedProgressWithLogo());
          }
          if (state is ProductDetailsFailure) {
            return _ErrorView(
              message: state.error.isNotEmpty ? state.error : "Failed to load.",
              onRetry: () => context
                  .read<ProductDetailsCubit>()
                  .getProductDetails(widget.listingId),
            );
          }
          final model = (state as ProductDetailsLoaded).productDetailsModel;
          final data = model.data!;
          final listing = data.listing!;
          final images = data.images ?? const [];
          final details = data.details;
          final posted = data.postedBy;

          final title = listing.title ?? "—";
          final priceStr = _formatINR(listing.price);
          final location = listing.location ?? "—";

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: PageView.builder(
                        controller: _pgCtrl,
                        onPageChanged: (i) => setState(() => _page = i),
                        itemCount: (images.isEmpty ? 1 : images.length),
                        itemBuilder: (_, i) {
                          final url = images.isNotEmpty
                              ? images[i].image
                              : null;
                          return _ImageHero(url: url);
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: _Dots(
                        count: images.isEmpty ? 1 : images.length,
                        index: _page,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹$priceStr",
                        style: AppTextStyles.headlineMedium(
                          textColor,
                        ).copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: AppTextStyles.headlineSmall(textColor),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Item Information",
                    style: AppTextStyles.headlineSmall(
                      textColor,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Chips (Posted + Location)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      if (listing.createdAt != null)
                        _InfoChip(
                          icon: Icons.calendar_today_rounded,
                          label: "Posted",
                          value: _shortDate(listing.createdAt),
                        ),
                      if (location.isNotEmpty)
                        _InfoChip(
                          icon: Icons.place_rounded,
                          label: "Location",
                          value: location,
                        ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ===== Description =====
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Description",
                    style: AppTextStyles.headlineSmall(
                      textColor,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Text(
                    (listing.description ?? "—").trim(),
                    style: AppTextStyles.bodyMedium(textColor),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ===== Specifications (Dynamic via Map) =====
              if (details != null) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Specifications",
                      style: AppTextStyles.headlineSmall(
                        textColor,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: buildSpecifications(details),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],

              // ===== Posted By =====
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _PostedByCard(
                    avatarUrl: posted?.image,
                    name: posted?.name ?? "—",
                    postedOn: posted?.postedAt ?? _shortDate(listing.createdAt),
                    onViewProfile: () {
                      /* TODO */
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // // ===== Location =====
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 16),
              //     child: Text(
              //       "Location",
              //       style: AppTextStyles.headlineSmall(textColor).copyWith(fontWeight: FontWeight.w700),
              //     ),
              //   ),
              // ),
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              //     child: Row(
              //       children: [
              //         Icon(Icons.radio_button_checked, size: 18, color: ThemeHelper.textColor(context).withOpacity(.5)),
              //         const SizedBox(width: 6),
              //         Expanded(child: Text(location, style: AppTextStyles.bodyMedium(textColor))),
              //       ],
              //     ),
              //   ),
              // ),
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(16),
              //       child: Container(
              //         height: 170,
              //         color: ThemeHelper.cardColor(context),
              //         alignment: Alignment.center,
              //         child: Text("Map preview here", style: AppTextStyles.bodySmall(textColor)),
              //       ),
              //     ),
              //   ),
              // ),
              // const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ===== Similar Items (demo) =====
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Similar Items",
                    style: AppTextStyles.headlineSmall(
                      textColor,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 250,
                  child: SimilarProductsSection(
                    subCategoryId: listing.subCategoryId!.toString(),
                    excludeId: listing.id,
                    onTap: (prod) {
                      context.pushReplacement(
                        "/products_details?listingId=${listing.id}&subcategory_id=${listing.subCategoryId}",
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }

  Widget buildSpecifications(Details d) {
    final map = d.merged(); // from extension
    if (map.isEmpty)
      return Text(
        "No specifications available.",
        style: AppTextStyles.bodyMedium(ThemeHelper.textColor(context)),
      );

    final textColor = ThemeHelper.textColor(context);
    final dividerColor = ThemeHelper.isDarkMode(context)
        ? Colors.white12
        : const Color(0x11000000);

    return Column(
      children: map.entries.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: dividerColor)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _labelize(e.key),
                  style: AppTextStyles.bodyMedium(
                    textColor,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  _formatValue(e.key, e.value),
                  textAlign: TextAlign.right,
                  style: AppTextStyles.bodyMedium(textColor),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ===== Helpers =====
  String _labelize(String key) {
    return key
        .replaceAll("_", " ")
        .split(" ")
        .map((w) => w.isEmpty ? w : "${w[0].toUpperCase()}${w.substring(1)}")
        .join(" ");
  }

  String _formatValue(String key, dynamic value) {
    if (value == null) return "—";
    final v = value.toString().trim();
    if (key.contains("mobile")) {
      final d = v.replaceAll(RegExp(r'\D'), '');
      return d.length >= 4 ? "******${d.substring(d.length - 4)}" : v;
    }
    if (key.contains("price")) return "₹$v";
    if (key.contains("facing_direction")) {
      return v.isEmpty
          ? v
          : (v[0].toUpperCase() + v.substring(1).toLowerCase());
    }
    return v;
  }
}

// ===== Widgets =====

class _ImageHero extends StatelessWidget {
  final String? url;
  const _ImageHero({this.url});

  @override
  Widget build(BuildContext context) {
    final cardColor = ThemeHelper.cardColor(context);
    final iconColor = ThemeHelper.textColor(context).withOpacity(.5);
    return Container(
      color: cardColor,
      child: (url == null || url!.isEmpty)
          ? Center(child: Icon(Icons.image, size: 56, color: iconColor))
          : Image.network(url!, fit: BoxFit.cover),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;
  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    final activeColor = ThemeHelper.textColor(context);
    final idleColor = activeColor.withOpacity(0.25);
    return Wrap(
      spacing: 6,
      children: List.generate(count, (i) {
        final active = i == index;
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: active ? activeColor : idleColor,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final chipBg = ThemeHelper.isDarkMode(context)
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.04);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            "$label  ",
            style: AppTextStyles.bodySmall(
              textColor,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
          Text(value, style: AppTextStyles.bodySmall(textColor)),
        ],
      ),
    );
  }
}

class _PostedByCard extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final String postedOn;
  final VoidCallback onViewProfile;
  const _PostedByCard({
    required this.avatarUrl,
    required this.name,
    required this.postedOn,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final cardColor = ThemeHelper.cardColor(context);
    final borderColor = ThemeHelper.isDarkMode(context)
        ? Colors.white12
        : Colors.black12;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                ? NetworkImage(avatarUrl!)
                : null,
            child: (avatarUrl == null || avatarUrl!.isEmpty)
                ? Icon(Icons.person, color: textColor)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Posted by",
                  style: AppTextStyles.bodySmall(textColor.withOpacity(.6)),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: AppTextStyles.bodyMedium(
                    textColor,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  "Posted on $postedOn",
                  style: AppTextStyles.bodySmall(textColor.withOpacity(.6)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onViewProfile,
            icon: Icon(Icons.person_add_alt_1, color: textColor),
          ),
        ],
      ),
    );
  }
}



class _BottomCtaBar extends StatelessWidget {
  final VoidCallback onContact;
  final VoidCallback onChat;
  const _BottomCtaBar({required this.onContact, required this.onChat});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onContact,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  backgroundColor: const Color(0xFF1866FF),
                ),
                child: Text(
                  "Contact Seller",
                  style: AppTextStyles.bodyMedium(Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onChat,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  backgroundColor: const Color(0xFF1866FF),
                ),
                child: Text(
                  "Chat",
                  style: AppTextStyles.bodyMedium(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Skeleton & Error (theme-aware) =====

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    final card = ThemeHelper.cardColor(context);
    return ListView(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(color: card),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: List.generate(
              6,
              (i) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 16,
                color: card,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final iconColor = Colors.redAccent;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: iconColor),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(textColor),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Utility formatting =====

String _formatINR(String? price) {
  final val = double.tryParse(price ?? "");
  if (val == null) return "0";
  final f = NumberFormat.currency(
    locale: 'en_IN',
    symbol: "",
    decimalDigits: 0,
  );
  return f.format(val);
}

String _shortDate(String? iso) {
  if (iso == null) return "—";
  final d = DateTime.tryParse(iso);
  if (d == null) return "—";
  return DateFormat('dd/MM/yyyy').format(d.toLocal());
}
