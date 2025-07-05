import 'package:flutter/material.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final bgColor = ThemeHelper.backgroundColor(context);
    final textColor = ThemeHelper.textColor(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Profile', style: AppTextStyles.headlineSmall(textColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile header
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/user_photo.png'),
            ),
            const SizedBox(height: 8),
            Text('Manikanta.N', style: AppTextStyles.headlineSmall(textColor)),
            Text(
              'Member since June 2023',
              style: AppTextStyles.bodySmall(textColor),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {},
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 20),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statTile('28', 'Sales', textColor),
                _statTile('4.9', 'Rating', textColor),
                _statTile('45', 'Reviews', textColor),
              ],
            ),

            const SizedBox(height: 20),

            // Achievements
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Achievements',
                style: AppTextStyles.titleLarge(textColor),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _achievementTile(
                  Icons.verified,
                  Colors.green,
                  'Verified Seller',
                  textColor,
                ),
                _achievementTile(
                  Icons.local_shipping,
                  Colors.blue,
                  'Fast Shipper',
                  textColor,
                ),
                _achievementTile(
                  Icons.star,
                  Colors.amber,
                  'Top Rated',
                  textColor,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Settings list
            _settingsTile(
              Icons.unsubscribe_outlined,
              Colors.blue.shade100,
              'Subscription',
              textColor,
              trailing: Icons.arrow_forward_ios,
            ),
            _settingsTile(
              Icons.language,
              Colors.green.shade100,
              'Language',
              textColor,
              trailingText: 'English',
            ),
            _settingsTile(
              Icons.nightlight_round,
              Colors.purple.shade100,
              'Dark Theme',
              textColor,
              isSwitch: true,
            ),
            _settingsTile(
              Icons.share,
              Colors.orange.shade100,
              'Share this App',
              textColor,
              trailing: Icons.arrow_forward_ios,
            ),
            _settingsTile(
              Icons.star_rate,
              Colors.yellow.shade100,
              'Rate us',
              textColor,
              trailing: Icons.arrow_forward_ios,
            ),
            _settingsTile(
              Icons.headset_mic,
              Colors.lightBlue.shade100,
              'Contact us',
              textColor,
              trailing: Icons.arrow_forward_ios,
            ),
            _settingsTile(
              Icons.favorite,
              Colors.red.shade100,
              'Wishlist',
              textColor,
              trailing: Icons.arrow_forward_ios,
            ),
            _settingsTile(
              Icons.info,
              Colors.purple.shade100,
              'About us',
              textColor,
              trailing: Icons.arrow_forward_ios,
            ),

            const SizedBox(height: 20),

            // Logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {},
                child: const Text('Log Out'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _statTile(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headlineMedium(color)),
        Text(label, style: AppTextStyles.bodySmall(color)),
      ],
    );
  }

  Widget _achievementTile(
    IconData icon,
    Color iconColor,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.labelMedium(color)),
      ],
    );
  }

  Widget _settingsTile(
    IconData icon,
    Color iconBg,
    String label,
    Color textcolor, {
    IconData? trailing,
    String? trailingText,
    bool isSwitch = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.8)])
      ),
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconBg,
            child: Icon(icon, size: 18, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: AppTextStyles.bodyMedium(textcolor)),
          ),
          if (trailingText != null)
            Text(trailingText, style: AppTextStyles.bodySmall(textcolor)),
          if (trailing != null) Icon(trailing, size: 16, color: Colors.grey),
          if (isSwitch) Switch(value: false, onChanged: (val) {}),
        ],
      ),
    );
  }
}
