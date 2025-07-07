import 'package:flutter/material.dart';
import '../../Components/CustomAppButton.dart';
import '../../Components/CutomAppBar.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonTextField.dart';

class JobAd extends StatefulWidget {
  const JobAd({super.key});

  @override
  State<JobAd> createState() => _JobAdState();
}

class _JobAdState extends State<JobAd> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final companyNameController = TextEditingController();
  final websiteController = TextEditingController();
  final employmentTypeController = TextEditingController();
  final workTypeController = TextEditingController();
  final locationController = TextEditingController();
  final salaryRangeController = TextEditingController();
  final descriptionController = TextEditingController();
  final requirementsController = TextEditingController();
  final benefitsController = TextEditingController();
  final responsibilitiesController = TextEditingController();
  final applicationDeadlineController = TextEditingController();

  String selectedDocument = 'Resume/CV';

  @override
  void dispose() {
    titleController.dispose();
    companyNameController.dispose();
    websiteController.dispose();
    employmentTypeController.dispose();
    workTypeController.dispose();
    locationController.dispose();
    salaryRangeController.dispose();
    descriptionController.dispose();
    requirementsController.dispose();
    benefitsController.dispose();
    responsibilitiesController.dispose();
    applicationDeadlineController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        applicationDeadlineController.text =
            "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);

    return Scaffold(
      appBar: CustomAppBar1(title: 'Job Ad', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextField1(
                lable: 'Job Title',
                hint: 'Eg. software engineer',
                controller: titleController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Job title required'
                    : null,
              ),
              CommonTextField1(
                lable: 'Company Name',
                hint: 'Name of the company',
                controller: companyNameController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Company name required'
                    : null,
              ),
              _sectionTitle('Company Logo', textColor),
              _buildUploadImagesSection(textColor),

              CommonTextField1(
                lable: 'Company Website',
                hint: 'Website',
                controller: websiteController,
                color: textColor,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Website required' : null,
              ),
              CommonTextField1(
                lable: 'Employment Type',
                hint: 'Eg. Full-time, Part-time',
                controller: employmentTypeController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Employment type required'
                    : null,
              ),
              CommonTextField1(
                lable: 'Work Type',
                hint: 'Eg. On-site, Remote',
                controller: workTypeController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Work type required'
                    : null,
              ),
              CommonTextField1(
                prefixIcon: Icon(
                  Icons.location_pin,
                  color: textColor,
                  size: 16,
                ),
                lable: 'Location',
                hint: 'Job location',
                controller: locationController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Location required'
                    : null,
              ),
              CommonTextField1(
                lable: 'Salary Range',
                hint: 'Eg. 30,000 - 50,000',
                controller: salaryRangeController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Salary range required'
                    : null,
              ),

              CommonTextField1(
                maxLines: 5,
                lable: 'Job Description',
                hint: 'Describe the job role in detail',
                controller: descriptionController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Description required'
                    : null,
              ),
              CommonTextField1(
                maxLines: 3,
                lable: 'Requirements',
                hint: 'Enter requirements',
                controller: requirementsController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Requirements required'
                    : null,
              ),
              CommonTextField1(
                maxLines: 3,
                lable: 'Benefits',
                hint: 'Enter benefits',
                controller: benefitsController,
                color: textColor,
              ),
              CommonTextField1(
                maxLines: 3,
                lable: 'Responsibilities',
                hint: 'Enter responsibilities',
                controller: responsibilitiesController,
                color: textColor,
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: CommonTextField1(
                    suffixIcon: Icon(
                      Icons.date_range,
                      color: textColor,
                      size: 16,
                    ),
                    lable: 'Application Deadline Date',
                    hint: 'Select date',
                    controller: applicationDeadlineController,
                    color: textColor,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Application deadline required'
                        : null,
                  ),
                ),
              ),

              _sectionTitle('Required Documents', textColor),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  _buildRadioOption('Resume/CV', textColor),
                  _buildRadioOption('Cover Letter', textColor),
                  _buildRadioOption('Portfolio', textColor),
                  _buildRadioOption('References', textColor),
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
            text: 'Submit Ad',
            onPlusTap: () {
              if (_formKey.currentState?.validate() ?? false) {
                debugPrint('Job Ad Submitted');
                debugPrint('Required Document: $selectedDocument');
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xffEFF6FF),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.cloud_upload_sharp,
                color: color.withOpacity(0.6),
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Click or drag company logo to upload',
              style: AppTextStyles.bodyMedium(color.withOpacity(0.6)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: selectedDocument,
          onChanged: (val) {
            setState(() {
              selectedDocument = val!;
            });
          },
          activeColor: color,
        ),
        Text(value, style: TextStyle(color: color)),
      ],
    );
  }
}
