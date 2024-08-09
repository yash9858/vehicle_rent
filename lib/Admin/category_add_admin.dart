import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rentify/Admin/vehicle_category_admin.dart';


class CategoryAddController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;
  var image = Rxn<File>();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  Future<void> addCategory() async {
    if (formKey.currentState!.validate() && image.value != null) {
      isLoading(true);
      try {
        String categoryName = nameController.text.trim();
        final querySnapshot = await FirebaseFirestore.instance.collection('Categories').where('Cat_Name', isEqualTo: categoryName).get();

        if (querySnapshot.docs.isNotEmpty) {
          Fluttertoast.showToast(
            msg: "Category Name Already Exists",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
          isLoading(false);
          return;
        }

        String fileName = 'categories/$categoryName';
        final storageRef = FirebaseStorage.instance.ref().child(fileName);
        await storageRef.putFile(image.value!);
        String imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('Categories').add({
          'Cat_Name': categoryName,
          'Cat_Image': imageUrl,
        });

        Fluttertoast.showToast(
          msg: "Category added successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        Get.back();
      }
      catch (error) {
        Fluttertoast.showToast(
          msg: "Something went wrong: $error",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
      finally {
        isLoading(false);
      }
    } else if (image.value == null) {
      Fluttertoast.showToast(
        msg: "Please select an image",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}

class CategoryAdd extends StatefulWidget {
  const CategoryAdd({super.key, required AdminCategoryController controller});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final CategoryAddController controller = Get.put(CategoryAddController());

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text('Add Category'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.03),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: mdheight * 0.02),
            Padding(
              padding: EdgeInsets.only(left: mdwidth * 0.05, right: mdwidth * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Obx(() {
                          return CircleAvatar(
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
                          );
                        }),
                        Positioned(
                          left: 80,
                          bottom: 1,
                          child: CircleAvatar(
                            child: IconButton(
                                onPressed: controller.pickImage,
                                icon: const Icon(Icons.edit)),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: mdheight * 0.02),
                  Form(
                    key: controller.formKey,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: mdheight * 0.02),
            Obx(() {
              return MaterialButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.addCategory(),
                color: Colors.deepPurple.shade800,
                elevation: 5.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  'Add Category',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }),
            SizedBox(height: mdheight * 0.01),
          ],
        ),
      ),
    );
  }
}
