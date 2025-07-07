import 'package:flutter/material.dart';
import '../../Components/CustomAppButton.dart';
import '../../Components/CutomAppBar.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonTextField.dart';
import '../../theme/AppTextStyles.dart';

class LifeStyleAd extends StatefulWidget {
  const LifeStyleAd({super.key});

  @override
  State<LifeStyleAd> createState() => _LifeStyleAdState();
}

class _LifeStyleAdState extends State<LifeStyleAd> {
  final _formKey = GlobalKey<FormState>();

  final itemController = TextEditingController();
  final specsController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final notesController = TextEditingController();

  String selectedCategory = '';

  final List<String> categories = [
    'Sunglasses',
    'Sports & Fitness',
    'Wellness Spa',
    'Musical Instruments',
    'Perfumes'
  ];

  @override
  void dispose() {
    itemController.dispose();
    specsController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);

    return Scaffold(
      appBar: CustomAppBar1(title: 'Life style ad', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Item Information', textColor),
              _sectionSubTitle('Category', textColor),
              _buildSingleSelectChips(
                  categories, selectedCategory,
                      (val) => setState(() => selectedCategory = val), textColor),

              CommonTextField1(
                lable: 'Item Name/Brand',
                hint: 'e.g., Ray-Ban Aviator, Yoga Mat Set',
                controller: itemController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Item name required' : null,
              ),
              CommonTextField1(
                lable: 'Specifications',
                hint: 'e.g., Size, Material, Special Features',
                controller: specsController,
                color: textColor,
              ),

              _sectionTitle('Seller Information', textColor),
              CommonTextField1(
                lable: 'Full Name',
                hint: 'Enter your full name',
                controller: nameController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Name required' : null,
              ),
              CommonTextField1(
                lable: 'Phone Number',
                hint: 'Enter your phone number',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                color: textColor,
                prefixIcon: Icon(Icons.phone, color: textColor, size: 16),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Phone required' : null,
              ),
              CommonTextField1(
                lable: 'Email Address',
                hint: 'Enter your email address',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                color: textColor,
                prefixIcon: Icon(Icons.mail, color: textColor, size: 16),
              ),
              CommonTextField1(
                maxLines: 3,
                lable: 'Additional Notes',
                hint: 'Any special requirements or notes',
                controller: notesController,
                color: textColor,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: CustomAppButton1(
            text: 'Submit Details',
            onPlusTap: () {
              if (_formKey.currentState?.validate() ?? false) {
                debugPrint(
                    'Category: $selectedCategory, Item: ${itemController.text}, Seller: ${nameController.text}, Phone: ${phoneController.text}');
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.titleMedium(color)
            .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _sectionSubTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.bodyLarge(color)
            .copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildSingleSelectChips(
      List<String> options, String selected, Function(String) onSelected, Color color) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected == option;
        return ChoiceChip(
          label: Text(option, style: AppTextStyles.bodySmall(color)),
          selected: isSelected,
          onSelected: (_) => onSelected(option),
        );
      }).toList(),
    );
  }
}
