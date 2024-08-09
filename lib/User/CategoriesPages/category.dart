import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentify/User/CategoriesPages/category_vehicle_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryController extends GetxController {
  var isLoading = true.obs;
  var categories = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      var snapshot = await FirebaseFirestore.instance.collection('Categories').get();
      categories.assignAll(snapshot.docs.map((doc) => doc.data()).toList());
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch categories: $e");
    } finally {
      isLoading(false);
    }
  }
}



class Category extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());

  Category({super.key});

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Category",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: mheight * 0.033,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          );
        }

        if (controller.categories.isEmpty) {
          return const Center(child: Text("No categories found."));
        }

        return Container(
          padding: const EdgeInsets.only(top: 20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 5,
              crossAxisCount: 3,
              crossAxisSpacing: 5,
            ),
            itemCount: controller.categories.length,
            itemBuilder: (BuildContext context, int index) {
              var category = controller.categories[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => CategoryVehicleUser(
                    name: category['Cat_Name'],
                    val: category["Vehicle_Id"].toString(),
                  ));
                },
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          category["Cat_Image"],
                          fit: BoxFit.cover,
                          height: mwidth * 0.17,
                        ),
                      ),
                    ),
                    Text(
                      category["Cat_Name"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
