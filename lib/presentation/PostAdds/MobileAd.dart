import 'package:flutter/material.dart';
import '../../Components/CustomAppButton.dart';
import '../../Components/CutomAppBar.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonTextField.dart';
import '../../theme/AppTextStyles.dart';

class MobileAd extends StatefulWidget {
  const MobileAd({super.key});

  @override
  State<MobileAd> createState() => _MobileAdState();
}

class _MobileAdState extends State<MobileAd> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final modelController = TextEditingController();
  final conditionController = TextEditingController();
  final colorController = TextEditingController();
  final storageController = TextEditingController();
  final fullNameController = TextEditingController();
  final idController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final instructionsController = TextEditingController();
  final notesController = TextEditingController();

  // Selection states
  String selectedCategory = '';
  String selectedDuration = '';
  String paymentMethod = 'Cash';

  final List<String> deviceCategories = [
    'Mobiles', 'Tablets', 'Wearables', 'Accessories', 'Others'
  ];
  final List<String> rentalDurations = [
    'Hourly', 'Daily', 'Weekly', 'Monthly'
  ];

  @override
  void dispose() {
    modelController.dispose();
    conditionController.dispose();
    colorController.dispose();
    storageController.dispose();
    fullNameController.dispose();
    idController.dispose();
    phoneController.dispose();
    addressController.dispose();
    instructionsController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);

    return Scaffold(
      appBar: CustomAppBar1(title: 'Mobile Ad', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Device Information', textColor),
              _buildSingleSelectChips(
                  deviceCategories, selectedCategory,
                      (val) => setState(() => selectedCategory = val), textColor),

              CommonTextField1(
                lable: 'Device Model',
                hint: 'e.g., iPhone 14 Pro, Samsung Galaxy Tab S8',
                controller: modelController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Device model required' : null,
              ),
              CommonTextField1(
                lable: 'Device Condition',
                hint: 'Select condition',
                controller: conditionController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Condition required' : null,
              ),
              CommonTextField1(
                lable: 'Color',
                hint: 'e.g., Space Gray, Midnight Blue',
                controller: colorController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Color required' : null,
              ),
              CommonTextField1(
                lable: 'Storage Capacity',
                hint: 'Select storage',
                controller: storageController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Storage required' : null,
              ),

              _sectionTitle('Rental Duration', textColor),
              _buildSingleSelectChips(
                  rentalDurations, selectedDuration,
                      (val) => setState(() => selectedDuration = val), textColor),

              _sectionTitle('Renter Information', textColor),
              CommonTextField1(
                lable: 'Full Name',
                hint: 'Enter your full name',
                controller: fullNameController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Full name required' : null,
              ),
              CommonTextField1(
                lable: 'ID Number',
                hint: 'Enter government issued ID number',
                controller: idController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'ID required' : null,
              ),
              CommonTextField1(
                lable: 'Phone Number',
                hint: 'Enter your phone number',
                controller: phoneController,
                color: textColor,
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.phone, color: textColor, size: 16),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Phone required' : null,
              ),

              _sectionTitle('Delivery & Payment', textColor),
              CommonTextField1(
                prefixIcon: Icon(Icons.location_on, color: textColor, size: 16),
                lable: 'Delivery Address',
                hint: 'Enter delivery address',
                controller: addressController,
                color: textColor,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Address required' : null,
              ),
              CommonTextField1(
                maxLines: 3,
                lable: 'Delivery Instructions',
                hint: 'Any specific delivery instructions',
                controller: instructionsController,
                color: textColor,
              ),

              _sectionTitle('Payment Method', textColor),
              Wrap(
                spacing: 12,
                children: [
                  _buildRadioOption('Cash', textColor),
                  _buildRadioOption('Card', textColor),
                ],
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
                    'Submitted: Category=$selectedCategory, Model=${modelController.text}, Condition=${conditionController.text}, Storage=${storageController.text}, Duration=$selectedDuration, Payment=$paymentMethod');
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: AppTextStyles.titleMedium(color)
            .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
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

  Widget _buildRadioOption(String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: paymentMethod,
          onChanged: (val) {
            setState(() {
              paymentMethod = val!;
            });
          },
          activeColor: color,
        ),
        Text(value, style: TextStyle(color: color)),
      ],
    );
  }
}
