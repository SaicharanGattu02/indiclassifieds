import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:indiclassifieds/Components/CustomAppButton.dart';
import 'package:indiclassifieds/Components/CutomAppBar.dart';
import 'package:indiclassifieds/data/cubit/City/city_cubit.dart';
import 'package:indiclassifieds/data/cubit/States/states_cubit.dart';
import 'package:indiclassifieds/data/cubit/States/states_state.dart';
import 'package:indiclassifieds/data/cubit/commomAd/common_ad_states.dart';
import '../../Components/ShakeWidget.dart';
import '../../data/cubit/City/city_state.dart';
import '../../data/cubit/commomAd/common_ad_cubit.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/ImageUtils.dart';
import '../../utils/color_constants.dart';
import '../../widgets/CommonTextField.dart';

class CommonAd extends StatefulWidget {
  final String catId;
  final String CatName;
  final String SubCatName;
  final String subCatId;
  const CommonAd({
    super.key,
    required this.catId,
    required this.CatName,
    required this.SubCatName,
    required this.subCatId,
  });

  @override
  State<CommonAd> createState() => _CommonAdState();
}

class _CommonAdState extends State<CommonAd> {
  final _formKey = GlobalKey<FormState>();
  bool negotiable = false;
  int? selectedStateId;
  int? selectedCityId;
  bool _showPaymentError = false;
  bool _showStateError = false;
  bool _showCityError = false;
  bool _showimagesError = false;
  final descriptionController = TextEditingController();
  final brandController = TextEditingController();
  final locationController = TextEditingController();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  List<String> selectedConditions = [];
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<SelectStatesCubit>().getSelectStates("");
    // });
    super.initState();
  }

  File? _image;
  String? imagePath;
  List<File> _images = [];
  final int _maxImages = 6;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: primarycolor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: primarycolor),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),

                // Camera Option
                ListTile(
                  leading: Icon(Icons.camera_alt, color: primarycolor),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromCamera();
                  },
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      File? compressedFile = await ImageUtils.compressImage(
        File(pickedFile.path),
      );
      if (compressedFile != null) {
        setState(() {
          if (_images.length < _maxImages) {
            _images.add(compressedFile); // ✅ add to list
          }
        });
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      File? compressedFile = await ImageUtils.compressImage(
        File(pickedFile.path),
      );
      if (compressedFile != null) {
        setState(() {
          if (_images.length < _maxImages) {
            _images.add(compressedFile); // ✅ add to list
          }
        });
      }
    }
  }


  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = ThemeHelper.textColor(context);
    final isDarkMode = ThemeHelper.isDarkMode(context);
    return Scaffold(
      appBar: CustomAppBar1(title: '${widget.CatName}', actions: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextField1(
                lable: ' Add Title',
                hint: 'Enter Title',
                controller: titleController,
                color: textColor,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required title' : null,
              ),
              CommonTextField1(
                lable: 'Description',
                hint: 'Enter  Upto  500 words',
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

              // _sectionTitle('Condition', textColor),
              // _buildChips(
              //   ['Brand New', 'Like New', 'Used', 'For Parts Only'],
              //   textColor,
              //   isDarkMode,
              // ),
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

              // SizedBox(height: 12),
              // BlocBuilder<SelectStatesCubit, SelectStates>(
              //   builder: (context, state) {
              //     final List<DropdownMenuItem<int>> items = [];
              //
              //     if (state is SelectStatesLoading) {
              //       items.add(
              //         const DropdownMenuItem<int>(
              //           enabled: false,
              //           child: Row(
              //             children: [
              //               SizedBox(
              //                 width: 18,
              //                 height: 18,
              //                 child: CircularProgressIndicator(strokeWidth: 2),
              //               ),
              //               SizedBox(width: 8),
              //               Text("Loading..."),
              //             ],
              //           ),
              //         ),
              //       );
              //     } else if (state is SelectStatesLoaded) {
              //       final states = state.selectStatesModel.data ?? [];
              //
              //       // ✅ Ensure selectedStateId is valid in new list
              //       if (selectedStateId != null &&
              //           !states.any((e) => e.id == selectedStateId)) {
              //         selectedStateId = null;
              //         // Reset city ID when state ID becomes invalid
              //         selectedCityId = null;
              //       }
              //
              //       items.addAll(states.map<DropdownMenuItem<int>>(
              //             (e) => DropdownMenuItem<int>(
              //           value: e.id,
              //           child: Text(
              //             e.name ?? "",
              //             style: AppTextStyles.titleLarge(textColor),
              //           ),
              //         ),
              //       ));
              //     }
              //
              //     return DropdownButtonHideUnderline(
              //       child: DropdownButton2<int>(
              //         isExpanded: true,
              //         hint: Text(
              //           'Select State',
              //           style: AppTextStyles.titleLarge(textColor),
              //         ),
              //         items: items,
              //         value: selectedStateId,
              //         onChanged: (value) {
              //           if (value == null) return;
              //           context.read<SelectCityCubit>().getSelectCity(value, "");
              //           setState(() {
              //             selectedStateId = value;
              //             selectedCityId = null; // Reset city when state changes
              //             _showStateError = false;
              //             _showCityError = false; // Reset city error as well
              //           });
              //         },
              //         buttonStyleData: ButtonStyleData(
              //           padding: const EdgeInsets.only(right: 8),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(8),
              //             border: Border.all(
              //               color: isDarkMode ? Colors.white54 : Colors.black54,
              //               width: 0.5,
              //             ),
              //             color: isDarkMode ? Colors.black : Colors.white,
              //           ),
              //         ),
              //         iconStyleData: IconStyleData(
              //           icon: const Icon(Icons.keyboard_arrow_down_sharp),
              //           iconSize: 24,
              //           iconEnabledColor: textColor,
              //         ),
              //         dropdownStyleData: DropdownStyleData(
              //           maxHeight: 250,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(8),
              //             color: isDarkMode ? Colors.grey[850] : Colors.white,
              //           ),
              //         ),
              //         dropdownSearchData: DropdownSearchData(
              //           searchController: TextEditingController(),
              //           searchInnerWidgetHeight: 50,
              //           searchInnerWidget: Container(
              //             height: 50,
              //             padding: const EdgeInsets.all(8),
              //             child: TextField(
              //               expands: true,
              //               maxLines: null,
              //               onChanged: (value) {
              //
              //                 context.read<SelectStatesCubit>().getSelectStates(value);
              //               },
              //               decoration: InputDecoration(
              //                 hintText: 'Search State...',
              //                 hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
              //                 border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(8),
              //                 ),
              //               ),
              //             ),
              //           ),
              //           searchMatchFn: (item, searchValue) {
              //             // Only local match if not fetching from API
              //             return (item.child as Text?)
              //                 ?.data
              //                 ?.toLowerCase()
              //                 .contains(searchValue.toLowerCase()) ??
              //                 false;
              //           },
              //         ),
              //       ),
              //     );
              //   },
              // ),
              //
              // if (_showStateError) ...[
              //   Padding(
              //     padding: const EdgeInsets.only(top: 5),
              //     child: ShakeWidget(
              //       key: Key(
              //         "dropdown_state_error_${DateTime.now().millisecondsSinceEpoch}",
              //       ),
              //       duration: const Duration(milliseconds: 700),
              //       child: const Text(
              //         'Please Select State',
              //         style: TextStyle(
              //           fontFamily: 'roboto_serif',
              //           fontSize: 12,
              //           color: Colors.red,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //     ),
              //   ),
              // ],
              // SizedBox(height: 12),
              // if (selectedStateId != null) ...[
              //   BlocBuilder<SelectCityCubit, SelectCity>(
              //     builder: (context, cityState) {
              //       final List<DropdownMenuItem<int>> cityItems = [];
              //
              //       if (cityState is SelectCityLoading) {
              //         cityItems.add(
              //           const DropdownMenuItem<int>(
              //             enabled: false,
              //             child: Row(
              //               children: [
              //                 SizedBox(
              //                   width: 18,
              //                   height: 18,
              //                   child: CircularProgressIndicator(strokeWidth: 2),
              //                 ),
              //                 SizedBox(width: 8),
              //                 Text("Loading..."),
              //               ],
              //             ),
              //           ),
              //         );
              //       } else if (cityState is SelectCityLoaded) {
              //         final cities = cityState.selectCityModel.data ?? [];
              //
              //         // ✅ Ensure selectedCityId is valid in new list
              //         if (selectedCityId != null &&
              //             !cities.any((e) => e.cityId == selectedCityId)) {
              //           selectedCityId = null;
              //         }
              //
              //         cityItems.addAll(cities.map<DropdownMenuItem<int>>(
              //               (e) => DropdownMenuItem<int>(
              //             value: e.cityId,
              //             child: Text(
              //               e.name ?? "",
              //               style: AppTextStyles.titleLarge(textColor),
              //             ),
              //           ),
              //         ));
              //       }
              //
              //       return DropdownButtonHideUnderline(
              //         child: DropdownButton2<int>(
              //           isExpanded: true,
              //           hint: Text(
              //             'Select City',
              //             style: AppTextStyles.titleLarge(textColor),
              //           ),
              //           items: cityItems,
              //           value: selectedCityId,
              //           onChanged: (value) {
              //             if (value == null) return;
              //             setState(() {
              //               selectedCityId = value;
              //               _showCityError = false;
              //             });
              //           },
              //           buttonStyleData: ButtonStyleData(
              //             padding: const EdgeInsets.only(right: 8),
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(8),
              //               border: Border.all(
              //                 color: isDarkMode ? Colors.white54 : Colors.black54,
              //                 width: 0.5,
              //               ),
              //               color: isDarkMode ? Colors.black : Colors.white,
              //             ),
              //           ),
              //           iconStyleData: IconStyleData(
              //             icon: const Icon(Icons.keyboard_arrow_down_sharp),
              //             iconSize: 24,
              //             iconEnabledColor: textColor,
              //           ),
              //           dropdownStyleData: DropdownStyleData(
              //             maxHeight: 250,
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(8),
              //               color: isDarkMode ? Colors.grey[850] : Colors.white,
              //             ),
              //           ),
              //           dropdownSearchData: DropdownSearchData(
              //             searchController: TextEditingController(),
              //             searchInnerWidgetHeight: 50,
              //             searchInnerWidget: Container(
              //               height: 50,
              //               padding: const EdgeInsets.all(8),
              //               child: TextField(
              //                 expands: true,
              //                 maxLines: null,
              //                 onChanged: (value) {
              //                   // 🔹 Trigger search API for cities
              //                   if (selectedStateId != null) {
              //                     context.read<SelectCityCubit>().getSelectCity(selectedStateId!, value);
              //                   }
              //                 },
              //                 decoration: InputDecoration(
              //                   hintText: 'Search City...',
              //                   hintStyle: TextStyle(
              //                     fontSize: 14,
              //                     color: textColor,
              //                   ),
              //                   border: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             searchMatchFn: (item, searchValue) {
              //               return (item.child as Text?)
              //                   ?.data
              //                   ?.toLowerCase()
              //                   .contains(searchValue.toLowerCase()) ??
              //                   false;
              //             },
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ],
              //
              // if (_showCityError) ...[
              //   Padding(
              //     padding: const EdgeInsets.only(top: 5),
              //     child: ShakeWidget(
              //       key: Key(
              //         "dropdown_city_error_${DateTime.now().millisecondsSinceEpoch}",
              //       ),
              //       duration: const Duration(milliseconds: 700),
              //       child: const Text(
              //         'Please Select City',
              //         style: TextStyle(
              //           fontFamily: 'roboto_serif',
              //           fontSize: 12,
              //           color: Colors.red,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //     ),
              //   ),
              // ],
              _sectionTitle('Upload Product Images', textColor),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x0D000000),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: _images.isEmpty
                    ? InkWell(
                        onTap: _pickImage,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.photo_camera,
                                color: textColor.withOpacity(0.6),
                                size: 40,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '+ Add Photos ${_maxImages}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: textColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.8,
                        ),
                        itemCount: _images.length < _maxImages
                            ? _images.length + 1
                            : _images.length,
                        itemBuilder: (context, index) {
                          if (index == _images.length &&
                              _images.length < _maxImages) {
                            return InkWell(
                              onTap: _pickImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFE5E7EB),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate,
                                      color: textColor.withOpacity(0.6),
                                      size: 24,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Add Photo',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: textColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _images[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              if (_showimagesError && _images.isEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ShakeWidget(
                    key: Key("images_error_${DateTime.now().millisecondsSinceEpoch}"),
                    duration: const Duration(milliseconds: 700),
                    child: const Text(
                      'Please upload at least one image',
                      style: TextStyle(
                        fontFamily: 'roboto_serif',
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],

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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                color: textColor,
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.call, color: textColor, size: 16),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Phone required' : null,
              ),
              // CommonTextField1(
              //   lable: 'Email (Optional)',
              //   hint: 'Enter email',
              //   controller: emailController,
              //   color: textColor,
              //   prefixIcon: Icon(Icons.mail, color: textColor, size: 16),
              // ),
              CommonTextField1(
                lable: 'Address',
                hint: 'Enter Location',
                controller: locationController,
                color: textColor,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Required location'
                    : null,
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //
              //         ],
              //       ),
              //     ),
              //
              //     SizedBox(width: 8),
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //
              //         ],
              //       ),
              //     ),
              //
              //   ],
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: BlocConsumer<CommonAdCubit,CommonAdStates>(listener: (context, state) {
            if(state is CommonAdSuccess){
              context.pop();
            }

          },builder: (context, state) {
            return  CustomAppButton1(
              text: 'Submit Ad',
              onPlusTap: () {
                if (_formKey.currentState?.validate() ?? false) {}
              },
            );
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
}
