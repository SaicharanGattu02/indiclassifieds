import 'package:flutter/material.dart';
import '../theme/AppTextStyles.dart';
import '../theme/ThemeHelper.dart';

class BoostYourSalesScreen extends StatelessWidget {
  const BoostYourSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final bgColor = ThemeHelper.backgroundColor(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: Text(
          "Boost Your Sales",
          style: AppTextStyles.headlineSmall(
            Colors.white,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Choose the perfect plan to maximize your selling potential",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium(textColor).copyWith(height: 1.4),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              "Choose Your Plan",
              style: AppTextStyles.headlineMedium(
                textColor,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "Select the perfect package to boost your sales",
              style: AppTextStyles.bodyMedium(textColor.withOpacity(0.7)),
            ),
            const SizedBox(height: 20),

            // Essential Pack
            _buildPlanCard(
              context,
              title: "Essential Boost Pack",
              subtitle: "Perfect for beginners",
              price: "₹149",
              oldPrice: "₹499",
              discount: "70% OFF",
              gradient: [Colors.blue.shade400, Colors.blue.shade300],
              icon: Icons.rocket_launch,
              features: const [
                "3 Standard Listings",
                "1 Boosted Post (7 days)",
                "Basic Analytics",
              ],
            ),

            const SizedBox(height: 18),

            // Power Seller Plan
            _buildPlanCard(
              context,
              title: "Power Seller Plan + Auto Boost",
              subtitle: "Most popular choice",
              price: "₹239",
              oldPrice: "₹899",
              discount: "73% OFF",
              gradient: [Colors.orange.shade400, Colors.deepOrange.shade300],
              icon: Icons.local_fire_department,
              tag: "MOST POPULAR",
              features: const [
                "10 Premium Listings",
                "3 Boosted Posts",
                "Top Category Placement",
                "Priority Support",
              ],
            ),

            const SizedBox(height: 18),

            // Pro Combo
            _buildPlanCard(
              context,
              title: "Pro Promotion + Feature Combo",
              subtitle: "Maximum visibility",
              price: "₹299",
              oldPrice: "₹1100",
              discount: "73% OFF",
              gradient: [Colors.purpleAccent, Colors.pinkAccent],
              icon: Icons.star,
              features: const [
                "Unlimited Listings (90 days)",
                "5 Top Pinned Posts",
                "Homepage Spotlight",
                "Advanced Analytics",
              ],
            ),

            const SizedBox(height: 30),

            // Bottom footer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: textColor.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  "Secure Payment",
                  style: AppTextStyles.bodySmall(textColor.withOpacity(0.7)),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.support_agent,
                  size: 16,
                  color: textColor.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  "24/7 Support",
                  style: AppTextStyles.bodySmall(textColor.withOpacity(0.7)),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.verified,
                  size: 16,
                  color: textColor.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  "Best Value",
                  style: AppTextStyles.bodySmall(textColor.withOpacity(0.7)),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              "Need help choosing?",
              style: AppTextStyles.bodyMedium(textColor),
            ),
            GestureDetector(
              onTap: () {
                // TODO: implement support navigation
              },
              child: Text(
                "Contact Support",
                style: AppTextStyles.bodyMedium(
                  Colors.blue,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String price,
    required String oldPrice,
    required String discount,
    required List<Color> gradient,
    required IconData icon,
    required List<String> features,
    String? tag,
  }) {
    final textColor = ThemeHelper.textColor(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Card
        Container(
          decoration: BoxDecoration(
            color: ThemeHelper.cardColor(context),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: ThemeHelper.isDarkMode(context)
                    ? Colors.black.withOpacity(
                        0.3,
                      ) // darker shadow in dark mode
                    : Colors.black.withOpacity(
                        0.05,
                      ), // lighter shadow in light mode
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                ),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 22),
                alignment: Alignment.center,
                child: Icon(icon, size: 50, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.headlineSmall(
                        textColor,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium(
                        textColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      discount,
                      style: AppTextStyles.bodySmall(
                        Colors.green,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: features
                          .map(
                            (f) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    f,
                                    style: AppTextStyles.bodyMedium(textColor),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: gradient.last,
                      ),
                      icon: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                      ),
                      label: Text(
                        "View Plans",
                        style: AppTextStyles.bodyMedium(
                          Colors.white,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Floating Tag
        if (tag != null)
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: AppTextStyles.labelSmall(
                    Colors.white,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
