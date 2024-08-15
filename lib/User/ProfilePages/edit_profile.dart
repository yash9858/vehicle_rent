import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileController extends GetxController {
  final TextEditingController user = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController li = TextEditingController();
  final TextEditingController address = TextEditingController();
  final _picker = ImagePicker();
  var isLoading = true.obs;
  var userData = {}.obs;
  var profileImage = Rxn<File>();
  var gender = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        final formattedDate = "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
        dob.text = formattedDate;
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

  bool _isValidLicence(String licence) {
    final regex = RegExp(r'^[a-zA-Z0-9]+$');
    return regex.hasMatch(licence);
  }

  bool _isValidName(String name) {
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    return regex.hasMatch(name);
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
          li.text = userData["Licence"] ?? "";
          address.text = userData["Address"] ?? "";
          gender.value = userData["Gender"] ?? ""; // Set gender value
        }
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Failed To Fetching User Data",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
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
          'Licence': li.text,
          'Address': address.text,
          'Gender': gender.value, 
        };

        if (profileImage.value != null) {
          String fileName = 'profile_images/${currentUser.uid}/${profileImage.value!.path.split('/').last}';
          final storageRef = FirebaseStorage.instance.ref().child(fileName);
          await storageRef.putFile(profileImage.value!);

          String imageUrl = await storageRef.getDownloadURL();
          updateData['Profile_Image'] = imageUrl;
        }

        await FirebaseFirestore.instance.collection('Users').doc(currentUser.email).update(updateData);
        Fluttertoast.showToast(
          msg: "Profile Updated Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
        );
        getData();
      } else {
        Fluttertoast.showToast(
          msg: "User Not Found",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Failed To Update Profile",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    } finally {
      isLoading(false);
    }
  }

  void updateGender(String value) {
    gender.value = value;
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
                    TextFormField(
                      validator: (value) => controller._isValidName('Please Enter Valid Name').toString(),
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
                    TextFormField(
                      validator: (value){
                        if(value!.length < 10 || value.length > 50){
                          return "PLease Enter A Valid Range Of Address";
                        }
                        return null;
                      },
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
                    TextFormField(
                      validator: (value) => controller._isValidDOB("PLease Enter Valid DOB").toString(),
                      controller: controller.dob,
                      keyboardType: TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'YYYY-MM-DD',
                        labelText: "Date Of Birth",
                        prefixIcon: IconButton(
                            onPressed: () => controller._showDatePicker(context),
                            icon: const Icon(Icons.calendar_month)
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(mdheight * 0.02)),
                      ),
                    ),
                    SizedBox(height: mdheight * 0.025),
                    TextFormField(
                      validator: (value) => controller._isValidLicence('PLease Enter Valid Licence Number').toString(),
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
              Row(
                children: [
                  Obx(() => Radio(
                    value: "Male",
                    groupValue: controller.gender.value,
                    onChanged: (value) {
                      controller.updateGender(value!);
                    },
                  )),
                  const Text('Male', style: TextStyle(fontSize: 18)),
                  Obx(() => Radio(
                    value: "Female",
                    groupValue: controller.gender.value,
                    onChanged: (value) {
                      controller.updateGender(value!);
                    },
                  )),
                  const Text('Female', style: TextStyle(fontSize: 18)),
                  Obx(() => Radio(
                    value: "Other",
                    groupValue: controller.gender.value,
                    onChanged: (value) {
                      controller.updateGender(value!);
                    },
                  )),
                  const Text('Other', style: TextStyle(fontSize: 18)),
                ],
              ),
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
                  child: Text(
                    'Save Details',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: mdheight * 0.025,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
