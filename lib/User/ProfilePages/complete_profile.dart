import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rentify/User/HomePages/user_dash_board.dart';

class CompleteProfileController extends GetxController {
  TextEditingController user = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController li = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  var gender = 'Male'.obs;

  final _picker = ImagePicker();
  var image = Rx<File?>(null);
  var isLoading = false.obs;

  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  Future<void> uploadImageMedia() async {
    if (image.value == null) {
      Fluttertoast.showToast(
        msg: "Please select an image",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      Fluttertoast.showToast(
        msg: "No user is signed in",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      final ref = FirebaseStorage.instance.ref().child('profile_images').child('${currentUser.email}.jpg');
      await ref.putFile(image.value!);
      final imageUrl = await ref.getDownloadURL();

      final userData = {
        'Name': user.text,
        'Dob': dob.text,
        'License': li.text,
        'Phone': phone.text,
        'Address': address.text,
        'Gender': gender.value,
        'Profile_Image': imageUrl,
      };

      await FirebaseFirestore.instance.collection('Users').doc(currentUser.email).set(userData);

      Fluttertoast.showToast(
        msg: "Profile Added Successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      isLoading.value = false;
      Get.offAll(() => const UserDashboard());
    } catch (e) {
      isLoading.value = false;
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  CompleteProfileState createState() => CompleteProfileState();
}

class CompleteProfileState extends State<CompleteProfile> {
  final CompleteProfileController controller = Get.put(CompleteProfileController());
  final _formKey = GlobalKey<FormState>();

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        controller.dob.text = date.toLocal().toString().split(' ')[0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.of(context).size.height;
    var mdwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Complete Profile",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(
        child: CircularProgressIndicator(color: Colors.deepPurple),
      )
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
                      child: controller.image.value == null
                          ? Image.asset(
                        "assets/img/Logo.jpg",
                        height: 150,
                        width: 150,
                        fit: BoxFit.fill,
                      )
                          : Image.file(
                        controller.image.value!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      left: 80,
                      bottom: 1,
                      child: CircleAvatar(
                        child: IconButton(
                          onPressed: controller.getImage,
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: mdheight * 0.04),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildTextFormField(controller.user, "Enter Your Name", "Name", mdheight),
                    SizedBox(height: mdheight * 0.025),
                    buildTextFormField(controller.address, "Enter Your Address", "Address", mdheight),
                    SizedBox(height: mdheight * 0.025),
                    buildTextFormFieldWithIcon(controller.dob, "Enter Your DOB", "Date Of Birth", Icons.calendar_month, mdheight, () => _showDatePicker(context)),
                    SizedBox(height: mdheight * 0.025),
                    buildTextFormField(controller.li, "Enter Your Licence Number", "Licence Number", mdheight),
                    SizedBox(height: mdheight * 0.025),
                    buildTextFormField(controller.phone, "Enter Your Phone No", "Phone No", mdheight),
                    SizedBox(height: mdheight * 0.025),
                  ],
                ),
              ),
              buildGenderRadioButtons(mdheight),
              SizedBox(height: mdheight * 0.03),
              buildSaveButton(mdheight, mdwidth),
            ],
          ),
        ),
      )),
    );
  }

  Widget buildTextFormField(TextEditingController controller, String hintText, String labelText, double mdheight) {
    return TextFormField(
      validator: (val) {
        if (val!.isEmpty) {
          return "Please Enter $labelText";
        }
        return null;
      },
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade100,
        filled: true,
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mdheight * 0.02),
        ),
      ),
    );
  }

  Widget buildTextFormFieldWithIcon(TextEditingController controller, String hintText, String labelText, IconData icon, double mdheight, VoidCallback onPressed) {
    return TextFormField(
      validator: (val) {
        if (val!.isEmpty) {
          return "Please Enter $labelText";
        }
        return null;
      },
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade100,
        filled: true,
        hintText: hintText,
        labelText: labelText,
        prefixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mdheight * 0.02),
        ),
      ),
    );
  }

  Widget buildGenderRadioButtons(double mdheight) {
    return Row(
      children: [
        Radio(
          value: "Male",
          groupValue: controller.gender.value,
          onChanged: (value) {
            controller.gender.value = value!;
          },
        ),
        const Text('Male', style: TextStyle(fontSize: 18)),
        Radio(
          value: "Female",
          groupValue: controller.gender.value,
          onChanged: (value) {
            controller.gender.value = value!;
          },
        ),
        const Text('Female', style: TextStyle(fontSize: 18)),
        Radio(
          value: "Other",
          groupValue: controller.gender.value,
          onChanged: (value) {
            controller.gender.value = value!;
          },
        ),
        const Text('Other', style: TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget buildSaveButton(double mdheight, double mdwidth) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mdheight * 0.02),
        color: Colors.deepPurple.shade800,
      ),
      height: mdheight * 0.07,
      width: mdwidth,
      child: MaterialButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (controller.image.value == null) {
              Fluttertoast.showToast(
                msg: "Please select an image",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
              );
            } else {
              controller.uploadImageMedia();
            }
          }
        },
        child: Text(
          'Save Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: mdheight * 0.025,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
