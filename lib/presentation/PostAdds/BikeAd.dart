import 'package:flutter/material.dart';
import '../../Components/CustomAppButton.dart';
import '../../Components/CutomAppBar.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonTextField.dart';

class BikeAd extends StatefulWidget {
  final String catId;
  final String CatName;
  final String SubCatName;
  final String subCatId;
  const BikeAd({
    super.key,
    required this.catId,
    required this.CatName,
    required this.SubCatName,
    required this.subCatId,
  });

  @override
  State<BikeAd> createState() => _BikeAdState();
}

class _BikeAdState extends State<BikeAd> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final variantController = TextEditingController();
  final kmsController = TextEditingController();
  final colorController = TextEditingController();
  final priceController = TextEditingController();
  final localityController = TextEditingController();

  // Ownership states
  final List<String> ownershipOptions = [
    '1st Owner',
    '2nd Owner',
    '3rd Owner',
    '4+ Owner',
  ];
  final Set<String> selectedOwnership = {};

  // Selection states
  String selectedFuel = '';
  String selectedTransmission = '';
  String selectedBikeType = '';
  String availability = 'Available';

  @override
  void dispose() {
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    variantController.dispose();
    kmsController.dispose();
    colorController.dispose();
    priceController.dispose();
    localityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);

    return Scaffold(
      appBar: CustomAppBar1(title: 'Bike Ad', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Basic Motorcycle Information', textColor),
              CommonTextField1(
                lable: 'Make',
                hint: 'Eg. Honda, Bajaj, Yamaha',
                controller: makeController,
                color: textColor,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Make required' : null,
              ),
              CommonTextField1(
                lable: 'Model',
                hint: 'Eg. CBR, YZF, Classic 350',
                controller: modelController,
                color: textColor,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Model required' : null,
              ),
              CommonTextField1(
                lable: 'Year of Manufacture',
                hint: 'Eg. 2020',
                controller: yearController,
                color: textColor,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Year required' : null,
              ),
              CommonTextField1(
                lable: 'Variant/Trim',
                hint: 'Eg. Standard, Deluxe',
                controller: variantController,
                color: textColor,
              ),
              CommonTextField1(
                lable: 'Kilometers Driven',
                hint: 'Eg. 50000',
                suffixIcon: Text('Kms', style: TextStyle(color: textColor)),
                controller: kmsController,
                color: textColor,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Kms required' : null,
              ),
              CommonTextField1(
                lable: 'Color',
                hint: 'Eg. Red, Black',
                controller: colorController,
                color: textColor,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Color required' : null,
              ),

              _sectionTitle('Ownership', textColor),
              Wrap(
                spacing: 8,
                children: ownershipOptions.map((option) {
                  final isSelected = selectedOwnership.contains(option);
                  return ChoiceChip(
                    label: Text(
                      option,
                      style: AppTextStyles.bodySmall(textColor),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedOwnership.add(option);
                        } else {
                          selectedOwnership.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              _sectionTitle('Fuel Type', textColor),
              _buildSelectableChips(
                ['Petrol', 'Diesel', 'Electric'],
                selectedFuel,
                (val) => setState(() => selectedFuel = val),
                textColor,
              ),

              _sectionTitle('Transmission', textColor),
              _buildSelectableChips(
                ['Manual', 'Automatic'],
                selectedTransmission,
                (val) => setState(() => selectedTransmission = val),
                textColor,
              ),

              _sectionTitle('Bike Type', textColor),
              _buildSelectableChips(
                [
                  'Sport',
                  'Cruiser',
                  'Standard',
                  'Adventure',
                  'Touring',
                  'Scooter',
                ],
                selectedBikeType,
                (val) => setState(() => selectedBikeType = val),
                textColor,
              ),

              _sectionTitle('Pricing & Availability', textColor),
              CommonTextField1(
                lable: 'Selling Price',
                hint: 'Eg. 45000',
                controller: priceController,
                color: textColor,
                keyboardType: TextInputType.number,
                prefixIcon: Icon(
                  Icons.currency_rupee,
                  color: textColor,
                  size: 16,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Price required' : null,
              ),
              CommonTextField1(
                lableFontSize: 12,
                lableFontWeight: FontWeight.w500,
                lable: 'Locality / City',
                hint: 'Enter locality or area',
                controller: localityController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Locality required'
                    : null,
              ),

              const SizedBox(height: 20),
              Text(
                "Availability Status",
                style: AppTextStyles.titleSmall(
                  textColor,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
              Wrap(
                spacing: 12,
                children: [
                  _buildRadioOption('Available', textColor),
                  _buildRadioOption('Sold', textColor),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Motorcycle Preview",
                style: AppTextStyles.bodyLarge(
                  textColor,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: CustomAppButton1(
            text: 'Submit Ad',
            onPlusTap: () {
              if (_formKey.currentState?.validate() ?? false) {
                debugPrint(
                  'Submitted with: Fuel=$selectedFuel, Transmission=$selectedTransmission, Type=$selectedBikeType, Availability=$availability, Ownership=${selectedOwnership.join(',')}',
                );
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
        style: AppTextStyles.titleMedium(
          color,
        ).copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildSelectableChips(
    List<String> options,
    String selected,
    Function(String) onSelected,
    Color color,
  ) {
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
          groupValue: availability,
          onChanged: (val) {
            setState(() {
              availability = val!;
            });
          },
          activeColor: color,
        ),
        Text(value, style: TextStyle(color: color)),
      ],
    );
  }
}
