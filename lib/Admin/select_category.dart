import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rentify/Admin/vehicle_add_admin.dart';

class CategoryController extends GetxController {
  var isLoading = false.obs;
  var categories = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    getdata();
  }

  Future<void> getdata() async {
    isLoading(true);
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Categories').get();
      categories.assignAll(querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>).toList());
    }
    catch (e) {
      Fluttertoast.showToast(
          msg: "Failed To Load Categories",
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

class Category extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());
  Category({super.key});

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade800,
        title: Text(
          "Select Category",
          style: TextStyle(
            color: Colors.white,
            fontSize: mheight * 0.025,
          ),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple))
            : Container(
          padding: const EdgeInsets.only(top: 20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 5,
              crossAxisCount: 3,
              crossAxisSpacing: 5,
            ),
            itemCount: controller.categories.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => AdminAddVehicle(
                    name: controller.categories[index]["Cat_Name"],
                  ));
                },
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          controller.categories[index]["Cat_Image"],
                          fit: BoxFit.cover,
                          height: mwidth * 0.17,
                        ),
                      ),
                    ),
                    Text(
                      controller.categories[index]["Cat_Name"],
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
