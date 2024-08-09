import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentify/Admin/category_add_admin.dart';
import 'package:rentify/Admin/edit_category.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AdminCategoryController extends GetxController {
  var isLoading = false.obs;
  var categories = <Category>[].obs;

  final picker = ImagePicker();
  File? selectedImage;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      var snapshot = await FirebaseFirestore.instance.collection('Categories').get();
      var categoryList = snapshot.docs.map((doc) => Category.fromDocument(doc)).toList();
      categories.assignAll(categoryList);
    }
    catch (e) {
      Get.snackbar("Error", "Failed to fetch categories: $e");
    }
    finally {
      isLoading(false);
    }
  }

  Future<void> deleteCategory(String categoryId, String imageUrl) async {
    try {
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();

      await FirebaseFirestore.instance.collection('Categories').doc(categoryId).delete();
      fetchCategories();
    } catch (e) {
      Get.snackbar("Error", "Failed to delete category: $e");
    }
  }

  Future<void> selectImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
    }
  }

  Future<void> uploadCategory(String categoryName) async {
    if (selectedImage == null) return;

    try {
      isLoading(true);
      final storageRef = FirebaseStorage.instance.ref().child('Categories').child(categoryName);
      await storageRef.putFile(selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('Categories').add({
        'Cat_Name': categoryName,
        'Cat_Image': imageUrl,
      });

      fetchCategories();
      Get.back();
    } catch (e) {
      Get.snackbar("Error", "Failed to upload category: $e");
    } finally {
      isLoading(false);
    }
  }
}

class AdminCategoryPage extends StatelessWidget {
  final controller = Get.put(AdminCategoryController());

  AdminCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
        backgroundColor: Colors.deepPurple.shade800,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
        }

        if (controller.categories.isEmpty) {
          return const Center(child: Text("No categories found."));
        }

        return ListView.builder(
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Card(
                elevation: 5.0,
                shadowColor: Colors.deepPurple.shade800,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Category Name: ${category.name}'),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              category.imageUrl,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              Get.to(() => EditCategory(val: index));
                            },
                            color: Colors.deepPurple.shade800,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              'Edit Category',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.confirm,
                                text: 'Do you want to remove this category?',
                                confirmBtnColor: Colors.red,
                                onConfirmBtnTap: () {
                                  controller.deleteCategory(category.id, category.imageUrl).whenComplete(() {
                                    Get.back();
                                  });
                                },
                                animType: CoolAlertAnimType.slideInDown,
                                backgroundColor: Colors.red,
                                cancelBtnTextStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                              );
                            },
                            color: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              'Delete Category',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CategoryAdd(controller: controller));
        },
        backgroundColor: Colors.deepPurple.shade800,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class Category {
  final String id;
  final String name;
  final String imageUrl;

  Category({required this.id, required this.name, required this.imageUrl});

  factory Category.fromDocument(DocumentSnapshot doc) {
    return Category(
      id: doc.id,
      name: doc['Cat_Name'],
      imageUrl: doc['Cat_Image'],
    );
  }
}
