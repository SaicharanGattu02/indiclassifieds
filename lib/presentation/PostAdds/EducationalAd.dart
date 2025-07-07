import 'package:flutter/material.dart';
import '../../Components/CustomAppButton.dart';
import '../../Components/CutomAppBar.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonTextField.dart';
import '../../theme/AppTextStyles.dart';

class EducationalAd extends StatefulWidget {
  const EducationalAd({super.key});

  @override
  State<EducationalAd> createState() => _EducationalAdState();
}

class _EducationalAdState extends State<EducationalAd> {
  final _formKey = GlobalKey<FormState>();

  final serviceNameController = TextEditingController();
  final instructorController = TextEditingController();
  final experienceController = TextEditingController();
  final descriptionController = TextEditingController();
  final feeController = TextEditingController();
  final locationController = TextEditingController();

  // Selections
  final Set<String> selectedAgeGroups = {};
  final Set<String> selectedDurations = {};
  final Set<String> selectedSchedules = {};
  String selectedMode = '';
  String batchStatus = 'Enrolling Now';

  @override
  void dispose() {
    serviceNameController.dispose();
    instructorController.dispose();
    experienceController.dispose();
    descriptionController.dispose();
    feeController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);

    return Scaffold(
      appBar: CustomAppBar1(title: 'Education Ad', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Service Information', textColor),
              CommonTextField1(
                lable: 'Service Name',
                hint: 'e.g., Little Stars Preschool, Guitar Master Class',
                controller: serviceNameController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Service name required'
                    : null,
              ),
              CommonTextField1(
                lable: 'Instructor/Teacher Name',
                hint: 'e.g., Sarah Johnson',
                controller: instructorController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Instructor name required'
                    : null,
              ),
              CommonTextField1(
                lable: 'Years of Experience',
                hint: 'e.g., 5',
                controller: experienceController,
                color: textColor,
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Experience required'
                    : null,
              ),

              _sectionTitle('Age Group', textColor),
              _buildMultiSelectChips(
                [
                  '2-5 years',
                  '6-12 years',
                  '13-17 years',
                  '18+ years',
                  'All ages',
                ],
                selectedAgeGroups,
                textColor,
              ),

              _sectionTitle('Course Duration', textColor),
              _buildMultiSelectChips(
                ['1-3 months', '3-6 months', '6-12 months', '1+ year'],
                selectedDurations,
                textColor,
              ),

              _sectionTitle('Class Schedule', textColor),
              _buildMultiSelectChips(
                ['Weekday Morning', 'Weekday Evening', 'Weekend', 'Flexible'],
                selectedSchedules,
                textColor,
              ),

              _sectionTitle('Mode of Teaching', textColor),
              _buildSingleSelectChips(
                ['In Person', 'Online', 'Hybrid'],
                selectedMode,
                (val) => setState(() => selectedMode = val),
                textColor,
              ),

              CommonTextField1(
                maxLines: 5,
                lable: 'Course Description',
                hint:
                    'Describe your course, teaching methodology, and expected outcomes',
                controller: descriptionController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Description required'
                    : null,
              ),

              _sectionTitle('Pricing & Location', textColor),
              CommonTextField1(
                lable: 'Course Fee (per month)',
                hint: '₹ e.g., 2500',
                controller: feeController,
                color: textColor,
                keyboardType: TextInputType.number,
                prefixIcon: Icon(
                  Icons.currency_rupee,
                  color: textColor,
                  size: 16,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Fee required' : null,
              ),
              CommonTextField1(
                prefixIcon: Icon(Icons.location_on, color: textColor, size: 16),
                lable: 'Location/City',
                hint: 'e.g., Mumbai, Bengaluru, Delhi',
                controller: locationController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Location required'
                    : null,
              ),

              _sectionTitle('Batch Status', textColor),
              Wrap(
                spacing: 12,
                children: [
                  _buildRadioOption('Enrolling Now', textColor),
                  _buildRadioOption('Batch Full', textColor),
                ],
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
                  'Service: ${serviceNameController.text}, Instructor: ${instructorController.text}, Years: ${experienceController.text}, Age: ${selectedAgeGroups.join(',')}, Duration: ${selectedDurations.join(',')}, Schedule: ${selectedSchedules.join(',')}, Mode: $selectedMode, Fee: ${feeController.text}, Location: ${locationController.text}, Batch: $batchStatus',
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

  Widget _buildMultiSelectChips(
    List<String> options,
    Set<String> selectedItems,
    Color color,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedItems.contains(option);
        return ChoiceChip(
          label: Text(option, style: AppTextStyles.bodySmall(color)),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedItems.add(option);
              } else {
                selectedItems.remove(option);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSingleSelectChips(
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
          groupValue: batchStatus,
          onChanged: (val) {
            setState(() {
              batchStatus = val!;
            });
          },
          activeColor: color,
        ),
        Text(value, style: TextStyle(color: color)),
      ],
    );
  }
}
