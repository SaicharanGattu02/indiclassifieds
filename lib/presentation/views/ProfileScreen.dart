import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/data/cubit/Profile/profile_cubit.dart';
import 'package:indiclassifieds/data/cubit/Profile/profile_states.dart';
import '../../Components/CustomAppButton.dart';
import '../../services/AuthService.dart';
import '../../theme/AppTextStyles.dart';
import '../../theme/ThemeHelper.dart';
import '../../utils/color_constants.dart';
import '../../utils/spinkittsLoader.dart';
import '../../widgets/CommonLoader.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeHelper.isDarkMode(context);
    final bgColor = ThemeHelper.backgroundColor(context);
    final textColor = ThemeHelper.textColor(context);
    var height = MediaQuery.sizeOf(context).height;
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
        child: BlocBuilder<ProfileCubit, ProfileStates>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return SizedBox(
                height: height*0.75,
                  child: Center(child: DottedProgressWithLogo()));
            } else if (state is ProfileLoaded) {
              final user_data = state.profileModel.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: user_data?.image ?? "",
                          imageBuilder: (context, imageProvider) => Container(
                            padding: EdgeInsets.all(12),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            width: 120,
                            height: 120,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Center(
                              child: spinkits.getSpinningLinespinkit(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage("assets/images/profile.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user_data?.name ?? "",
                    style: AppTextStyles.headlineSmall(textColor),
                  ),
                  Text(
                    user_data?.email ?? "",
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
                    onPressed: () {
                      context.push('/edit_profile_screen');
                    },
                    child: const Text('Edit Profile',style: TextStyle(color: Colors.white),),
                  ),
                  const SizedBox(height: 20),
                  _settingsTile(
                    Icons.unsubscribe_outlined,
                    Colors.blue.shade100,
                    'Subscription',
                    isDark,
                    textColor,
                    trailing: Icons.arrow_forward_ios,
                    onTap: () {
                      context.push("/plans");
                    },
                  ),
                  // _settingsTile(
                  //   Icons.unsubscribe_outlined,
                  //   Colors.blue.shade100,
                  //   'Advertisements',
                  //   isDark,
                  //   textColor,
                  //   trailing: Icons.arrow_forward_ios,
                  //   onTap: () {
                  //     context.push("/advertisements");
                  //   },
                  // ),
                  _settingsTile(onTap: (){
                    context.push('/wish_list');
                  },
                    Icons.favorite,
                    Colors.red.shade100,
                    'Wishlist',
                    isDark,
                    textColor,
                    trailing: Icons.arrow_forward_ios,
                  ),
                  _settingsTile(
                    Icons.nightlight_round,
                    Colors.purple.shade100,
                    'Dark Theme',
                    isDark,
                    textColor,
                    isSwitch: true,
                  ),
                  _settingsTile(
                    Icons.share,
                    Colors.orange.shade100,
                    'Share this App',
                    isDark,
                    textColor,
                    trailing: Icons.arrow_forward_ios,
                  ),
                  _settingsTile(
                    Icons.star_rate,
                    Colors.yellow.shade100,
                    'Rate us',
                    isDark,
                    textColor,
                    trailing: Icons.arrow_forward_ios,
                  ),
                  _settingsTile(
                    Icons.headset_mic,
                    Colors.lightBlue.shade100,
                    'Contact us',
                    isDark,
                    textColor,
                    trailing: Icons.arrow_forward_ios,
                  ),
                  _settingsTile(
                    Icons.info,
                    Colors.purple.shade100,
                    'About us',
                    isDark,
                    textColor,
                    trailing: Icons.arrow_forward_ios,
                  ),

                  const SizedBox(height: 20),

                  CustomAppButton1(
                    text: "Log Out",
                    onPlusTap: () {
                      showLogoutDialog(context);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              );
            } else {
              return Center(child: Text("No data Found!"));
            }
          },
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 4.0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SizedBox(
            width: 300.0,
            height: 230.0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Power Icon Positioned Above Dialog
                Positioned(
                  top: -35.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 6.0, color: Colors.white),
                      shape: BoxShape.circle,
                      color: Colors.red.shade100, // Light red background
                    ),
                    child: const Icon(
                      Icons.power_settings_new,
                      size: 40.0,
                      color: Colors.red, // Power icon color
                    ),
                  ),
                ),

                // Dialog Content
                Positioned.fill(
                  top: 30.0, // Moves content down
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15.0),
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                            color: primarycolor,
                            fontFamily: "roboto_serif",
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Text(
                          "Are you sure you want to logout?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                            fontFamily: "roboto_serif",
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Buttons Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // No Button (Filled)
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      primarycolor, // Filled button color
                                  foregroundColor: Colors.white, // Text color
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                child: const Text(
                                  "No",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "roboto_serif",
                                  ),
                                ),
                              ),
                            ),

                            // Yes Button (Outlined)
                            SizedBox(
                              width: 100,
                              child: OutlinedButton(
                                onPressed: () async {
                                  await AuthService.logout();
                                  context.go("/login");
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primarycolor, // Text color
                                  side: BorderSide(
                                    color: primarycolor,
                                  ), // Border color
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "roboto_serif",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _settingsTile(
    IconData icon,
    Color iconBg,
    String label,
    bool isDark,
    Color textcolor, {
    IconData? trailing,
    String? trailingText,
    bool isSwitch = false,
    VoidCallback? onTap, // <-- add onTap
  }) {
    return InkWell(
      onTap: onTap, // <-- handle tap
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: isDark
              ? LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.8),
                  ],
                )
              : LinearGradient(
                  colors: [
                    const Color(0xffF9FAFB).withOpacity(0.8),
                    const Color(0xffFFFFFF).withOpacity(0.8),
                  ],
                ),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 6),
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
      ),
    );
  }
}
