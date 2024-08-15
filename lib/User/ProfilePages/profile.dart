import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/User/ProfilePages/about_us.dart';
import 'package:rentify/User/ProfilePages/edit_profile.dart';
import 'package:rentify/User/ProfilePages/help_center.dart';
import 'package:rentify/User/BookingPages/history.dart';
import 'package:rentify/User/ProfilePages/privacy_policy.dart';
import 'package:rentify/AuthPages/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileController extends GetxController {
  var data = {}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading(true);
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        var response = await FirebaseFirestore.instance.collection('Users').doc(currentUser.email).get();
        if (response.exists) {
          var userData = response.data()!;
          String? imageUrl = userData['Profile_Image'];
          if (imageUrl != null) {
            userData['profile_image_url'] = imageUrl;
          }
          data.value = userData;
        }
      }
      catch (e) {
        Fluttertoast.showToast(
            msg: "Failed To Fetch User Data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2
        );
      }
    }
    isLoading(false);
  }

  Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    await pref.setBool('seen', true);
    Get.offAll(() => LoginPage());
  }
}

class Profile extends StatelessWidget {
  Profile({super.key});
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          );
        }
        else {
          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchProfile();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: mHeight * 0.02),
                    child: Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                              controller.data["Profile_Image"],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: mHeight * 0.032,),
                  Text(
                    controller.data["Name"],
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: mHeight * 0.05,),
                  Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          await Get.to(() => EditProfile());
                          controller.fetchProfile();
                        },
                        child: ListTile(
                          leading: const Icon(
                            Icons.account_circle_outlined,
                            color: Colors.deepPurple,
                          ),
                          title: const Text(
                            "Edit Profile",
                            style: TextStyle(fontSize: 20),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await Get.to(() => EditProfile());
                              controller.fetchProfile();
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      InkWell(
                        onTap: () {
                          Get.to(() => const HistoryPage());
                        },
                        child: ListTile(
                          leading: const Icon(LineIcons.car, color: Colors.deepPurple),
                          title: const Text("My Bookings", style: TextStyle(fontSize: 20)),
                          trailing: IconButton(
                            onPressed: () {
                              Get.to(() => const HistoryPage());
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      InkWell(
                        onTap: () {
                          Get.to(() => HelpCenter());
                        },
                        child: ListTile(
                          leading: const Icon(
                            Icons.headset_mic_outlined,
                            color: Colors.deepPurple,
                          ),
                          title: const Text(
                            "Help Center",
                            style: TextStyle(fontSize: 20),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Get.to(() => HelpCenter());
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      InkWell(
                        onTap: () {
                          Get.to(() => const PrivacyPolicyPage());
                        },
                        child: ListTile(
                          leading: const Icon(
                            Icons.policy_outlined,
                            color: Colors.deepPurple,
                          ),
                          title: const Text(
                            "Privacy Policy",
                            style: TextStyle(fontSize: 20),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Get.to(() => const PrivacyPolicyPage());
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      InkWell(
                        onTap: () {
                          Get.to(() => const AboutUs());
                        },
                        child: ListTile(
                          leading: const Icon(
                            Icons.info_outline_rounded,
                            color: Colors.deepPurple,
                          ),
                          title: const Text(
                            "About Us",
                            style: TextStyle(fontSize: 20),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Get.to(() => const AboutUs());
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      InkWell(
                        onTap: () async {
                          await controller.logout();
                        },
                        child: const ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: Colors.deepPurple,
                          ),
                          title: Text(
                            "Log Out",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
