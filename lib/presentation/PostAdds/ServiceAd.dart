import 'package:flutter/material.dart';
import '../../Components/CustomAppButton.dart';
import '../../Components/CutomAppBar.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonTextField.dart';
import '../../theme/AppTextStyles.dart';

class ServiceAd extends StatefulWidget {
  const ServiceAd({super.key});

  @override
  State<ServiceAd> createState() => _ServiceAdState();
}

class _ServiceAdState extends State<ServiceAd> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final rateController = TextEditingController();
  final locationController = TextEditingController();
  final sellerController = TextEditingController();
  final detailsController = TextEditingController();

  String selectedCategory = '';
  // ignore: unused_field
  String? uploadedImage; // simulate uploaded image path

  final List<Map<String, dynamic>> categories = [
    {'label': 'Cleaning', 'icon': Icons.cleaning_services},
    {'label': 'Pest Control', 'icon': Icons.bug_report},
    {'label': 'Legal', 'icon': Icons.gavel},
    {'label': 'Packers &Movers', 'icon': Icons.local_shipping},
    {'label': 'Home Renovation', 'icon': Icons.home_repair_service},
  ];

  @override
  void dispose() {
    titleController.dispose();
    rateController.dispose();
    locationController.dispose();
    sellerController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);

    return Scaffold(
      appBar: CustomAppBar1(title: 'Service Ad', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Service Image', textColor),
              GestureDetector(
                onTap: () {
                  // image picker logic here
                  debugPrint('Tapped to pick image');
                },
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFD1D5DB), width: 1),
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFFF9FAFB),
                  ),

                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: textColor.withOpacity(0.5),
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Upload service image\nTap to browse from gallery',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall(
                            textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              _sectionTitle('Service Category*', textColor),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  final isSelected = selectedCategory == cat['label'];
                  return ChoiceChip(
                    avatar: Icon(cat['icon'], size: 18, color: textColor),
                    label: Text(
                      cat['label'],
                      style: AppTextStyles.bodySmall(textColor),
                    ),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => selectedCategory = cat['label']);
                    },
                  );
                }).toList(),
              ),

              CommonTextField1(
                lable: 'Service Title*',
                hint: 'e.g. Professional Deep Cleaning Service',
                controller: titleController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Service title required'
                    : null,
              ),
              CommonTextField1(
                prefixIcon: Icon(
                  Icons.attach_money,
                  color: textColor,
                  size: 16,
                ),
                lable: 'Service Rate*',
                hint: '0.00',
                controller: rateController,
                color: textColor,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Service rate required'
                    : null,
              ),
              Text(
                'Enter base rate per service/hour',
                style: AppTextStyles.bodySmall(textColor.withOpacity(0.6)),
              ),
              const SizedBox(height: 12),

              CommonTextField1(
                prefixIcon: Icon(Icons.location_on, color: textColor, size: 16),
                lable: 'Location*',
                hint: 'Enter pickup location',
                controller: locationController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Location required'
                    : null,
              ),
              CommonTextField1(
                lable: 'Seller Name*',
                hint: 'Your name or company name',
                controller: sellerController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Seller name required'
                    : null,
              ),
              CommonTextField1(
                maxLines: 3,
                lable: 'Additional Details (Optional)',
                hint:
                    'Enter vehicle specifications, features, or rental conditions',
                controller: detailsController,
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
                  'Service: ${titleController.text}, Category: $selectedCategory, Rate: ${rateController.text}, Seller: ${sellerController.text}',
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
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.titleMedium(
          color,
        ).copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}
