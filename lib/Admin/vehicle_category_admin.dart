import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  dynamic catId;
  dynamic vId;
  final picker = ImagePicker();
  File? selectedImage;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() {
    try {
      isLoading(true);
      FirebaseFirestore.instance.collection('Categories').snapshots().listen((snapshot) {
        var categoryList = snapshot.docs.map((doc) => Category.fromDocument(doc)).toList();
        categories.assignAll(categoryList);
        isLoading(false);
      });
    }
    catch (e) {
      Fluttertoast.showToast(
          msg: "Failed To Fetch Categories",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
      isLoading(false);
    }
  }

  Future<void> deleteCategory(String categoryId, String catName, String imageUrl) async {
    try {
      isLoading(true);
      var vehiclesSnapshot = await FirebaseFirestore.instance.collection(
          'Vehicles')
          .where('Cat_Name', isEqualTo: catName).get();
      int numberOfVehicles = vehiclesSnapshot.size;
      for (var vehicle in vehiclesSnapshot.docs) {
        String vehicleImageUrl = vehicle.data()['Vehicle_Image'];
        if (vehicleImageUrl.isNotEmpty) {
          final vehicleImageRef = FirebaseStorage.instance.refFromURL(
              vehicleImageUrl);
          await vehicleImageRef.delete();
        }
        await FirebaseFirestore.instance.collection('Vehicles')
            .doc(vehicle.id).delete();
      }
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();
      await FirebaseFirestore.instance.collection('Categories')
          .doc(categoryId).delete();
      fetchCategories();

      var counterRef = FirebaseFirestore.instance.collection('Counter').doc('CatCounter');
      var counterSnapshot = await counterRef.get();
      if (counterSnapshot.exists) {
        int currentCount = counterSnapshot.data()?['latestId'] ?? 0;
        await counterRef.set({'latestId': currentCount - 1});

        var vehicleRef = FirebaseFirestore.instance.collection('Counter').doc('VehicleCounter');
        var vehicleSnapshot = await vehicleRef.get();
        if (vehicleSnapshot.exists) {
          vId = vehicleSnapshot.data()?['latestId'] - numberOfVehicles;
        }
        else {
          vId = 1;
        }
        await vehicleRef.set({'latestId': vId});
        Fluttertoast.showToast(
            msg: "Successfully Deleted Category",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2
        );
      }
    }
    catch (e) {
      Fluttertoast.showToast(
          msg: "Failed To Delete Category",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    }
    finally {
      isLoading(false);
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

      var counterRef = FirebaseFirestore.instance.collection('Counter').doc('CatCounter');
      var counterSnapshot = await counterRef.get();

      if (counterSnapshot.exists) {
        catId = counterSnapshot.data()?['latestId'] + 1;
      }
      else {
        catId = 1;
      }
      await counterRef.set({'latestId': catId});
      await FirebaseFirestore.instance.collection('Categories').doc(catId.toString()).set({
        'Cat_Id' : catId.toString(),
        'Cat_Name': categoryName,
        'Cat_Image': imageUrl,
      });

      fetchCategories();
      Fluttertoast.showToast(
          msg: "Category Uploaded Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    }
    catch (e) {
      Fluttertoast.showToast(
          msg: "Failed Uploaded Category",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    }
    finally {
      isLoading(false);
    }
  }
}

class AdminCategoryPage extends StatelessWidget {
  final controller = Get.put(AdminCategoryController());

  AdminCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
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
          return const Center(child: Text("No Categories Found."));
        }

        return RefreshIndicator(
          onRefresh: () async{
            controller.fetchCategories();
          },
          child: ListView.builder(
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: mheight * 0.01, vertical: mheight * 0.01),
                child: Card(
                  elevation: 5.0,
                  shadowColor: Colors.deepPurple.shade800,
                  child: Padding(
                    padding: EdgeInsets.all(mheight * 0.02),
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
                                height: mheight * 0.15,
                                width: mheight * 0.15,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: mheight * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Get.to(() => EditCategory(catId: category.id,))?.then((_) {
                                  controller.fetchCategories();
                                });
                              },
                              color: Colors.deepPurple.shade800,
                              padding: EdgeInsets.symmetric(horizontal: mheight * 0.02, vertical: mheight * 0.005),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Text(
                                'Edit Category',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(width: mheight * 0.01,),
                            MaterialButton(
                              onPressed: () {
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Do You Want To Remove This Category?',
                                  confirmBtnColor: Colors.red,
                                  onConfirmBtnTap: () {
                                    controller.deleteCategory(category.id,category.name,category.imageUrl);
                                    Get.back();
                                  },
                                  animType: CoolAlertAnimType.slideInDown,
                                  backgroundColor: Colors.red,
                                  cancelBtnTextStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                );
                              },
                              color: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: mheight * 0.015, vertical: mheight * 0.005),
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
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CategoryAdd())!.then((_) {
            controller.fetchCategories();
          });
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
      id: doc["Cat_Id"].toString(),
      name: doc['Cat_Name'],
      imageUrl: doc['Cat_Image'],
    );
  }
}