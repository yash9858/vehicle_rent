import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AdminEditCategoryController extends GetxController {
  final RxMap<String, dynamic> category = RxMap();
  final TextEditingController nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? image;

  Future<void> fetchCategoryById(String catId) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('Categories').doc(catId).get();
      if (doc.exists) {
        category.value = {
          'id': doc.id,
          'Cat_Name': doc['Cat_Name'],
          'Cat_Image': doc['Cat_Image'],
        };
        nameController.text = doc['Cat_Name'];
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed To Fetch Category",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2
      );
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      update();
    }
  }

  Future<void> updateCategory(String catId) async {
    try {
      String? imageUrl;
      if (image != null) {
        final storageRef = FirebaseStorage.instance.ref().child('Categories').child(nameController.text);
        await storageRef.putFile(image!);
        imageUrl = await storageRef.getDownloadURL();
      }
      await FirebaseFirestore.instance.collection('Categories').doc(catId).update({
        'Cat_Name': nameController.text,
        if (imageUrl != null) 'Cat_Image': imageUrl,
      });
      Fluttertoast.showToast(
        msg: "Category Updated Successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
      Get.back();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed To Update Category",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    }
  }
}

class EditCategory extends StatelessWidget {
  final String catId;
  const EditCategory({super.key, required this.catId});

  @override
  Widget build(BuildContext context) {
    final AdminEditCategoryController controller = Get.put(AdminEditCategoryController());
    controller.fetchCategoryById(catId);
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text('Edit Category'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.category.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.03),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: mdheight * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: mdwidth * 0.05,
                        right: mdwidth * 0.01,
                      ),
                      child : Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            child: controller.image == null
                                ? Image.network(
                              controller.category['Cat_Image'],
                              height: 150,
                              width: 150,
                              fit: BoxFit.fill,
                            ) : Image.file(
                              controller.image!,
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
                                onPressed: controller.pickImage,
                                icon: const Icon(Icons.edit),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                    SizedBox(height: mdheight * 0.02),
                    Form(
                      child: TextFormField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Enter A Category Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: mdheight * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mdheight * 0.015),
                child: SizedBox(
                  width: double.infinity,
                  height: mdheight * 0.07,
                  child: MaterialButton(
                    onPressed: () => controller.updateCategory(catId),
                    color: Colors.deepPurple.shade800,
                    elevation: 5.0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Text(
                      'Update Category',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ),
              SizedBox(height: mdheight * 0.01),
            ],
          ),
        );
      }),
    );
  }
}
