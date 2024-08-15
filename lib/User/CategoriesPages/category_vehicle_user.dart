import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rentify/User/DetailsPages/bike_details.dart';
import '../DetailsPages/car_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryVehicleController extends GetxController {
  var isLoading = true.obs;
  List<Map<String, dynamic>> vehicles = [];

  Future<void> fetchVehicles(String categoryName) async {
    try {
      isLoading(true);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Vehicles')
          .where('Cat_Name', isEqualTo: categoryName).get();
      vehicles = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['Vehicle_Id'] = doc.id;
        return data;
      }).toList();
      isLoading(false);
    }
    catch (e) {
      Fluttertoast.showToast(
        msg: "Failed To Fetching Vehicle Data",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    }
  }
}


class CategoryVehicleUser extends StatelessWidget {
  final String val;
  final String name;
  final CategoryVehicleController controller = Get.put(CategoryVehicleController());
  CategoryVehicleUser({super.key, required this.name, required this.val});

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    controller.fetchVehicles(name);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: mheight * 0.033,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          );
        }

        if (controller.vehicles.isEmpty) {
          return const Center(child: Text("No vehicles found."));
        }

        return Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: mheight * 0.31,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: controller.vehicles.length,
            itemBuilder: (BuildContext context, int index) {
              var vehicle = controller.vehicles[index];
              return GestureDetector(
                onTap: () {
                  if (vehicle["Vehicle_Type"] == "Car") {
                    Get.to(() => CarDetails(
                      index: index,
                      carId: vehicle["Vehicle_Id"].toString(),
                      catName: vehicle["Cat_Name"],
                      name: vehicle["Vehicle_Name"],
                      type: vehicle["Vehicle_Type"],
                      description: vehicle["Vehicle_Description"],
                      price: vehicle["Rent_Price"].toString(),
                      image: vehicle["Vehicle_Image"],
                    ));
                  }
                  else if (vehicle["Vehicle_Type"] == "Bike") {
                    Get.to(() => BikeDetail(
                      index: index,
                      bikeId: vehicle["Vehicle_Id"].toString(),
                      catName: vehicle["Cat_Name"],
                      name: vehicle["Vehicle_Name"],
                      type: vehicle["Vehicle_Type"],
                      description: vehicle["Vehicle_Description"],
                      price: vehicle["Rent_Price"].toString(),
                      image: vehicle["Vehicle_Image"],
                    ));
                  }
                },
                child: Card(
                  borderOnForeground: true,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 7, right: 7, top: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(name, style: const TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                            const Icon(Icons.info_outline, color: Colors.blueGrey),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          vehicle["Vehicle_Image"],
                          fit: BoxFit.cover,
                          height: mheight * 0.16,
                          width: mwidth * 0.5,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 2, right: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                vehicle["Vehicle_Name"],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "₹ ${vehicle["Rent_Price"]} /Day",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
