import 'package:flutter/material.dart';
import 'package:indiclassifieds/Components/CutomAppBar.dart';
import 'package:indiclassifieds/theme/app_colors.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({Key? key}) : super(key: key);

  // Function to launch email
  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@indclassifieds.in',
      query: 'subject=Support Request for IND Classifieds',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // Handle error (e.g., show a snackbar)
    }
  }

  // Function to launch phone call
  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+91 83091 63721');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      // Handle error
    }
  }

  // Function to launch WhatsApp
  Future<void> _launchWhatsApp() async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '/+91 83091 63721',
      query: 'text=Hello, I need support with IND Classifieds',
    );
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final backgroundColor = ThemeHelper.backgroundColor(context);
    return Scaffold(
      appBar: CustomAppBar1(title: 'Contact Support', actions: []),
      body: SafeArea(
        child: Container(
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Header Image or Illustration
                Lottie.asset(
                  'assets/lottie/Support.json',
                  width: 200,
                  height: 200,
                  repeat: true,
                ),
                const SizedBox(height: 24),
                // Title
                Text(
                  'We’re Here to Help!',
                  style: AppTextStyles.headlineMedium(textColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Subtitle
                Text(
                  'Reach out to us via Email, Phone, or WhatsApp. Our team responds within 24 hours.',
                  style: AppTextStyles.bodyMedium(textColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Contact Options
                _buildContactOption(
                  context,
                  icon: Icons.email_rounded,
                  title: 'Email Us',
                  subtitle: 'support@indclassifieds.in',
                  onTap: _launchEmail,
                ),
                const SizedBox(height: 16),
                _buildContactOption(
                  context,
                  icon: Icons.phone_rounded,
                  title: 'Call Us',
                  subtitle: '+91 83091 63721',
                  onTap: _launchPhone,
                ),
                const SizedBox(height: 16),
                _buildContactOption(
                  context,
                  icon: Icons.chat_bubble_rounded,
                  title: 'WhatsApp Us',
                  subtitle: 'Chat with us instantly',
                  onTap: _launchWhatsApp,
                ),
                const Spacer(),
                // Footer
                Text(
                  'IND Classifieds - Buy, Sell, Connect!',
                  style: AppTextStyles.bodySmall(textColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build contact option cards
  Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final textColor = ThemeHelper.textColor(context);
    return Card(
      elevation: 4,
      color: ThemeHelper.cardColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(icon, size: 28, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.titleMedium(textColor)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyles.bodySmall(textColor)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: textColor),
            ],
          ),
        ),
      ),
    );
  }
}
