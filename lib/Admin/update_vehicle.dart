import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminUpdateVehicleController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  RxBool isLoading = false.obs;
  RxMap<String, dynamic> vehicleData = <String, dynamic>{}.obs;
  var selectedVehicleType = 'Car'.obs;

  Future<void> getVehicleData(String vehicleId) async {
    isLoading.value = true;
    try {
      DocumentSnapshot doc = await _firestore.collection('Vehicles').doc(vehicleId).get();
      if (doc.exists) {
        vehicleData.value = doc.data() as Map<String, dynamic>;
      }
    }
    catch (e) {
      Fluttertoast.showToast(
        msg: "Failed To Load Vehicle Data",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> updateVehicleData(File? imageFile, String vehicleId, Map<String, dynamic> updatedData) async {
    isLoading.value = true;
    try {
      if (imageFile != null) {
        String fileName = 'vehicle_images/$vehicleId.jpg';
        Reference ref = _storage.ref().child(fileName);
        UploadTask uploadTask = ref.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        updatedData['Vehicle_Image'] = downloadUrl;
      }
      await _firestore.collection('Vehicles').doc(vehicleId).update(updatedData);
      Fluttertoast.showToast(
        msg: "Vehicle Details Updated Successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    }
    catch (e) {
      Fluttertoast.showToast(
        msg: "Failed To Update Vehicle Data",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    }
    finally {
      isLoading.value = false;
    }
  }
}

class UpdateVehicle extends StatelessWidget {
  final String vehicleId;
  final AdminUpdateVehicleController _vehicleController = Get.put(AdminUpdateVehicleController());

  UpdateVehicle({super.key, required this.vehicleId}) {
    _vehicleController.getVehicleData(vehicleId);
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    _image = pickedFile != null ? File(pickedFile.path) : null;
  }

  void _updateVehicleDetails() {
    Map<String, dynamic> updatedData = {
      'Vehicle_Name': nameController.text,
      'Vehicle_Number': numberController.text,
      'Vehicle_Type': _vehicleController.selectedVehicleType.value,
      'Vehicle_Description': descriptionController.text,
      'Rent_Price': int.parse(priceController.text),
    };
    _vehicleController.updateVehicleData(_image, vehicleId, updatedData);
  }

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
        title: const Text('Update Vehicle Details'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_vehicleController.vehicleData.isNotEmpty) {
          nameController.text = _vehicleController.vehicleData['Vehicle_Name'] ?? '';
          numberController.text = _vehicleController.vehicleData['Vehicle_Number'] ?? '';
          descriptionController.text = _vehicleController.vehicleData['Vehicle_Description'] ?? '';
          priceController.text = _vehicleController.vehicleData['Rent_Price'].toString();
        }

        return _vehicleController.isLoading.value
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
                        backgroundImage: _image == null
                            ? NetworkImage(_vehicleController.vehicleData['Vehicle_Image'] ?? '')
                            : FileImage(_image!) as ImageProvider,
                      ),
                      Positioned(
                        left: 80,
                        bottom: 1,
                        child: CircleAvatar(
                          child: IconButton(
                            onPressed: _getImage,
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: mdheight * 0.04),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
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
                        controller: numberController,
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
                        value: _vehicleController.selectedVehicleType.value,
                        items: ['Car', 'Bike']
                            .map((String category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        )).toList(),
                        onChanged: (newValue) {
                          _vehicleController.selectedVehicleType.value = newValue!;
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
                        controller: descriptionController,
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
                        controller: priceController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Enter Rent Price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        keyboardType: TextInputType.number,
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
                    onPressed: _updateVehicleDetails,
                    child: Text(
                      'Update Details',
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
