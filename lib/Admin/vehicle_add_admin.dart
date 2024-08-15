import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddVehicleController extends GetxController {
  var isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();
  File? image;
  dynamic vehicleId;
  var selectedVehicleType = 'Car'.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      update();
    }
  }

  Future<void> uploadVehicleData(String categoryName) async {
    if (image == null) {
      Fluttertoast.showToast(msg: "Please select an image");
      return;
    }
    if (nameController.text.isEmpty ||
        numberController.text.isEmpty ||
        selectedVehicleType.value.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }

    isLoading.value = true;

    try {
      String fileName = nameController.text.trim().toLowerCase().replaceAll(" ", "_");
      final storageRef = FirebaseStorage.instance.ref().child('vehicle_images/$fileName.jpg');
      await storageRef.putFile(image!);
      String downloadUrl = await storageRef.getDownloadURL();

      var counterRef = FirebaseFirestore.instance.collection('Counter').doc('VehicleCounter');
      var counterSnapshot = await counterRef.get();

      if (counterSnapshot.exists) {
        vehicleId = counterSnapshot.data()?['latestId'] + 1;
      } else {
        vehicleId = 1;
      }

      await counterRef.set({'latestId': vehicleId});

      await FirebaseFirestore.instance.collection('Vehicles').doc(vehicleId.toString()).set({
        'Vehicle_Id': vehicleId,
        'Vehicle_Name': nameController.text,
        'Vehicle_Number': numberController.text,
        'Vehicle_Type': selectedVehicleType.value,
        'Rent_Price': int.parse(priceController.text),
        'Vehicle_Description': descriptionController.text,
        'Cat_Name': categoryName,
        'Vehicle_Image': downloadUrl,
      });
      Fluttertoast.showToast(
          msg: "Vehicle Added Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
      Get.back();
    }
    catch (e) {
      Fluttertoast.showToast(
          msg: "Failed To Add Vehicle",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    }
    finally {
      isLoading.value = false;
    }
  }
}

class AdminAddVehicle extends StatelessWidget {
  final String name;
  AdminAddVehicle({super.key, required this.name});

  final AdminAddVehicleController addVehicleController = Get.put(AdminAddVehicleController());

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.of(context).size.height;
    var mdwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text('Vehicle Details'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return addVehicleController.isLoading.value
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
                        child: addVehicleController.image == null
                            ? Image.asset(
                          "assets/img/Logo.jpg",
                          height: 150,
                          width: 150,
                          fit: BoxFit.fill,
                        )
                            : Image.file(
                          addVehicleController.image!,
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
                            onPressed: addVehicleController.getImage,
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: mdheight * 0.04),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: addVehicleController.nameController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please Enter Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Enter Vehicle Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(height: mdheight * 0.025),
                      TextFormField(
                        controller: addVehicleController.numberController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please Enter Vehicle Number";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Enter Vehicle Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(height: mdheight * 0.025),
                      DropdownButtonFormField<String>(
                        value: addVehicleController.selectedVehicleType.value,
                        items: ['Car', 'Bike'].map((String category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        )).toList(),
                        onChanged: (newValue) {
                          addVehicleController.selectedVehicleType.value = newValue!;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Select Vehicle Type',
                        ),
                      ),
                      SizedBox(height: mdheight * 0.025),
                      TextFormField(
                        controller: addVehicleController.descriptionController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please Enter Vehicle Description";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Enter Vehicle Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(height: mdheight * 0.025),
                      TextFormField(
                        controller: addVehicleController.priceController,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please Enter Vehicle Price";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Enter Rent Price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: mdheight * 0.04),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(mdheight * 0.02),
                    color: Colors.deepPurple.shade800,
                  ),
                  height: mdheight * 0.06,
                  width: mdwidth * 0.7,
                  child: MaterialButton(
                    onPressed: () {
                      addVehicleController.uploadVehicleData(name);
                    },
                    child: Text(
                      'Add Vehicle',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mdheight * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
