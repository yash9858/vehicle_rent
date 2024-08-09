import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rentify/User/HomePages/user_dash_board.dart';

class EditProfileController extends GetxController {
  final TextEditingController user = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController li = TextEditingController();
  final TextEditingController address = TextEditingController();
  final _picker = ImagePicker();

  var isLoading = true.obs;
  var userData = {}.obs;
  var profileImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    isLoading(true);
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        var response = await FirebaseFirestore.instance.collection('Users').doc(currentUser.email).get();
        if (response.exists) {
          userData.value = response.data()!;
          user.text = userData["Name"] ?? "";
          dob.text = userData["Dob"] ?? "";
          li.text = userData["License"] ?? "";
          address.text = userData["Address"] ?? "";
        }
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error fetching user data: $error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  Future<void> uploadImageMedia() async {
    isLoading(true);
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        Map<String, dynamic> updateData = {
          'Name': user.text,
          'Dob': dob.text,
          'License': li.text,
          'Address': address.text,
        };

        if (profileImage.value != null) {
          String fileName = 'profiles_images/${currentUser.uid}/${profileImage.value!.path.split('/').last}';
          final storageRef = FirebaseStorage.instance.ref().child(fileName);
          await storageRef.putFile(profileImage.value!);

          String imageUrl = await storageRef.getDownloadURL();
          updateData['Profile_Image'] = imageUrl;
        }

        await FirebaseFirestore.instance.collection('Users').doc(currentUser.email).update(updateData);

        Fluttertoast.showToast(
          msg: "Profile updated successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        Get.offAll(() => const UserDashboard());
      } else {
        Fluttertoast.showToast(
          msg: "User not found",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Something went wrong: $error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}


class EditProfile extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final EditProfileController controller = Get.put(EditProfileController());

  EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(mdheight * 0.02),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: controller.profileImage.value == null
                          ? NetworkImage(controller.userData['Profile_Image'] ?? '')
                          : FileImage(controller.profileImage.value!) as ImageProvider,
                    ),
                    Positioned(
                      left: 80,
                      bottom: 1,
                      child: CircleAvatar(
                        child: IconButton(
                          onPressed: () => controller.selectImage(),
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: mdheight * 0.04),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextField(
                      controller: controller.user,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: "Enter Your Name",
                        labelText: "Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(mdheight * 0.02)),
                      ),
                    ),
                    SizedBox(height: mdheight * 0.025),
                    TextField(
                      controller: controller.address,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Enter Your Address',
                        labelText: "Address",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(mdheight * 0.02)),
                      ),
                    ),
                    SizedBox(height: mdheight * 0.025),
                    TextField(
                      controller: controller.dob,
                      keyboardType: TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'YYYY-MM-DD',
                        labelText: "Date Of Birth",
                        prefixIcon: const Icon(Icons.calendar_month),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(mdheight * 0.02)),
                      ),
                    ),
                    SizedBox(height: mdheight * 0.025),
                    TextFormField(
                      controller: controller.li,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Enter Your Licence Number',
                        labelText: "Licence Number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(mdheight * 0.02)),
                      ),
                    ),
                    SizedBox(height: mdheight * 0.025),
                  ],
                ),
              ),
              Row(children: [
                Radio(
                  value: "Male",
                  groupValue: controller.userData['Gender'],
                  onChanged: (value) {
                    controller.userData['Gender'] = value;
                  },
                ),
                const Text('Male', style: TextStyle(fontSize: 18)),
                Radio(
                  value: "Female",
                  groupValue: controller.userData['Gender'],
                  onChanged: (value) {
                    controller.userData['Gender'] = value;
                  },
                ),
                const Text('Female', style: TextStyle(fontSize: 18)),
                Radio(
                  value: "Other",
                  groupValue: controller.userData['Gender'],
                  onChanged: (value) {
                    controller.userData['Gender'] = value;
                  },
                ),
                const Text('Other', style: TextStyle(fontSize: 18)),
              ]),
              SizedBox(height: mdheight * 0.03),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(mdheight * 0.02),
                  color: Colors.deepPurple.shade800,
                ),
                height: mdheight * 0.07,
                width: mdwidth,
                child: MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      controller.uploadImageMedia();
                    }
                  },
                  child: Text('Save Details',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: mdheight * 0.025,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
