import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentify/User/CategoriesPages/search_fetch_vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchController extends GetxController {
  var isLoading = true.obs;
  List<Map<String, dynamic>> vehicle = [];

  @override
  void onInit() {
    super.onInit();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    try {
      isLoading(true);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Vehicles').get();
      vehicle = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['Vehicle_Id'] = doc.id;
        return data;
      }).toList();
      isLoading(false);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch vehicles: $e");
    }
  }
}

class SearchPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final SearchController controller = Get.put(SearchController());

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          final searchText = _controller.text;
                          if (searchText.isNotEmpty) {
                            var vehicle = controller.vehicle.firstWhere(
                                  (vehicle) => vehicle["Vehicle_Name"] == searchText,
                            );
                              Get.to(() => SearchFetch(
                                vid : vehicle["Vehicle_Id"].toString(),
                                vName: vehicle["Vehicle_Name"],
                              ));
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.vehicle.length,
                    itemBuilder: (context, index) {
                      var vehicle = controller.vehicle[index];
                      return ListTile(
                        onTap: () {
                          _controller.text = vehicle["Vehicle_Name"];
                          _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: _controller.text.length),
                          );
                        },
                        title: Text(vehicle["Vehicle_Name"]),
                      );
                    },
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
