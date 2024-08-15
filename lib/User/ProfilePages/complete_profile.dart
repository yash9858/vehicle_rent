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
  var gender = 'Male'.obs;
  final _picker = ImagePicker();
  var image = Rx<File?>(null);
  var isLoading = false.obs;
  TextEditingController user = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController li = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  Future<void> uploadImageMedia() async {
    if (image.value == null) {
      Fluttertoast.showToast(
        msg: "Please Select An Image",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
      return;
    }

    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      Fluttertoast.showToast(
        msg: "No User Is Signed In",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
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
        'Licence': li.text,
        'Phone': phone.text,
        'Address': address.text,
        'Gender': gender.value,
        'Profile_Image': imageUrl,
        'Status' : "1",
        'Role' : "User"
      };

      await FirebaseFirestore.instance.collection('Users').doc(currentUser.email).set(userData);
      Fluttertoast.showToast(
        msg: "Profile Added Successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      isLoading.value = false;
      Get.offAll(() => UserDashboard());
    }
    catch (e) {
      isLoading.value = false;
      Fluttertoast.showToast(
        msg: "Failed To Added Profile",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}

class CompleteProfile extends StatelessWidget {
  final CompleteProfileController controller = Get.put(CompleteProfileController());
  final _formKey = GlobalKey<FormState>();
  CompleteProfile({super.key});

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        final formattedDate = "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
        controller.dob.text = formattedDate;
      }
    });
  }

  bool _isValidDOB(String dob) {
    final dateParts = dob.split("-");
    if (dateParts.length != 3) return false;

    final day = int.tryParse(dateParts[0]);
    final month = int.tryParse(dateParts[1]);
    final year = int.tryParse(dateParts[2]);

    if (day == null || month == null || year == null) return false;

    final now = DateTime.now();
    final age = now.year - year;
    if (age < 18 || (age == 18 && (now.month < month || (now.month == month && now.day < day)))) {
      return false;
    }
    return true;
  }

  bool _isValidPhoneNumber(String phone) {
    final regex = RegExp(r'^\+\d{1,3}\d{10}$');
    return regex.hasMatch(phone);
  }

  bool _isValidLicence(String licence) {
    final regex = RegExp(r'^[a-zA-Z0-9]+$');
    return regex.hasMatch(licence);
  }

  bool _isValidName(String name) {
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    return regex.hasMatch(name);
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
                    buildTextFormField(controller.user, "Enter Your Name", "Name", mdheight, _isValidName, "Name should not contain symbols or special characters."),
                    SizedBox(height: mdheight * 0.025),
                    buildTextFormField(controller.address, "Enter Your Address", "Address", mdheight, null, "Address must be between 50 and 100 characters", min: 10, max: 100),
                    SizedBox(height: mdheight * 0.025),
                    buildTextFormFieldWithIcon(controller.dob, "Enter Your DOB", "Date Of Birth", Icons.calendar_month, mdheight, () => _showDatePicker(context), _isValidDOB, "DOB must be in DD-MM-YYYY format and you must be 18+ years old."),
                    SizedBox(height: mdheight * 0.025),
                    buildTextFormField(controller.li, "Enter Your Licence Number", "Licence Number", mdheight, _isValidLicence, "Licence number should contain only alphabets and numbers."),
                    SizedBox(height: mdheight * 0.025),
                    buildTextFormField(controller.phone, "Enter Your Phone No", "Phone No", mdheight, _isValidPhoneNumber, "Phone number should start with + followed by country code and 10 digits."),
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

  Widget buildTextFormField(TextEditingController controller, String hintText, String labelText, double mdheight, bool Function(String)? validator, String errorMessage, {int min = 0, int max = 0}) {
    return TextFormField(
      validator: (val) {
        if (val!.isEmpty) {
          return "Please Enter $labelText";
        }
        if (validator != null && !validator(val)) {
          return errorMessage;
        }
        if (min > 0 && val.length < min || max > 0 && val.length > max) {
          return errorMessage;
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

  Widget buildTextFormFieldWithIcon(TextEditingController controller, String hintText, String labelText, IconData icon, double mdheight, VoidCallback onPressed, bool Function(String)? validator, String errorMessage) {
    return TextFormField(
      validator: (val) {
        if (val!.isEmpty) {
          return "Please Enter $labelText";
        }
        if (validator != null && !validator(val)) {
          return errorMessage;
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