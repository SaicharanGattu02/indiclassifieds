import 'package:flutter/material.dart';
import 'package:indiclassifieds/Components/CustomAppButton.dart';
import 'package:indiclassifieds/Components/CutomAppBar.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonTextField.dart';

class AdElectronics extends StatefulWidget {
  const AdElectronics({super.key});

  @override
  State<AdElectronics> createState() => _AdElectronicsState();
}

class _AdElectronicsState extends State<AdElectronics> {
  final _formKey = GlobalKey<FormState>();
  bool negotiable = false;

  final descriptionController = TextEditingController();
  final brandController = TextEditingController();
  final locationController = TextEditingController();
  final priceController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  List<String> selectedConditions = [];

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final isDarkMode = ThemeHelper.isDarkMode(context);

    return Scaffold(
      appBar: CustomAppBar1(title: 'Ad Electronics', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Select Category', textColor),
              _buildCategoryGrid(textColor),
              CommonTextField1(
                lable: 'Description',
                hint: 'Include details',
                controller: descriptionController,
                color: textColor,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description required';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonTextField1(
                      lable: 'Brand',
                      hint: 'e.g. Apple, Samsung',
                      controller: brandController,
                      color: textColor,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required brand'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CommonTextField1(
                      lable: 'Location',
                      hint: 'Hyderabad',
                      controller: locationController,
                      color: textColor,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Required location'
                          : null,
                    ),
                  ),
                ],
              ),

              _sectionTitle('Condition', textColor),
              _buildChips(
                ['Brand New', 'Like New', 'Used', 'For Parts Only'],
                textColor,
                isDarkMode,
              ),

              CommonTextField1(
                lable: 'Price',
                hint: 'Enter price',
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
              SizedBox(height: 8),
              _buildSwitchRow('Is it negotiable?', Color(0xff00000040)),

              _sectionTitle('Upload Product Images', textColor),
              _buildUploadImagesSection(textColor),

              _sectionTitle('Contact Information', textColor),
              CommonTextField1(
                lable: 'Name',
                hint: 'Enter name',
                controller: nameController,
                color: textColor,
                prefixIcon: Icon(Icons.person, color: textColor, size: 16),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name required' : null,
              ),
              CommonTextField1(
                lable: 'Phone Number',
                hint: 'Enter phone number',
                controller: phoneController,
                color: textColor,
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.call, color: textColor, size: 16),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Phone required' : null,
              ),
              CommonTextField1(
                lable: 'Email (Optional)',
                hint: 'Enter email',
                controller: emailController,
                color: textColor,
                prefixIcon: Icon(Icons.mail, color: textColor, size: 16),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: CustomAppButton1(
            text: 'Submit Ad',
            onPlusTap: () {
              if (_formKey.currentState?.validate() ?? false) {}
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

  Widget _buildCategoryGrid(Color color) {
    final categories = [
      'Mobiles',
      'Laptops',
      'TVs',
      'Cameras',
      'Headphones',
      'Watches',
    ];
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1,
      children: categories
          .map(
            (c) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                c,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium(color),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildChips(List<String> items, Color color, bool isDark) {
    return Wrap(
      spacing: 8,
      children: items
          .map(
            (e) => FilterChip(
              selected: selectedConditions.contains(e),
              label: Text(e, style: AppTextStyles.bodySmall(color)),
              selectedColor: Colors.blue.withOpacity(0.2),
              backgroundColor: isDark ? Colors.black : Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
                side: BorderSide(
                  color: selectedConditions.contains(e)
                      ? Colors.blue
                      : (isDark
                            ? const Color(0xff666666)
                            : const Color(0xffD9D9D9)),
                ),
              ),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    selectedConditions.add(e);
                  } else {
                    selectedConditions.remove(e);
                  }
                });
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildSwitchRow(String label, Color color) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.8,
          child: Switch(
            inactiveTrackColor: color.withOpacity(0.2),
            value: negotiable,
            onChanged: (v) => setState(() => negotiable = v),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.bodyMedium(color)),
      ],
    );
  }

  Widget _buildUploadImagesSection(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.photo_camera, color: color.withOpacity(0.6), size: 40),
            const SizedBox(height: 8),
            Text(
              '+ Add Photos (Max 8)',
              style: AppTextStyles.bodyMedium(color.withOpacity(0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
