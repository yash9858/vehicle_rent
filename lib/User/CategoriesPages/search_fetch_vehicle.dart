import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../DetailsPages/car_details.dart';
import '../DetailsPages/bike_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchFetchController extends GetxController {
  var isLoading = true.obs;
  List<Map<String, dynamic>> vehicles = [];

  Future<void> fetchVehicles(String vehicle) async {
    try {
      isLoading(true);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Vehicles')
          .where('Vehicle_Name', isEqualTo: vehicle).get();
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

class SearchFetch extends StatelessWidget {
  final String vid;
  final String vName;
  final SearchFetchController controller = Get.put(SearchFetchController());
  SearchFetch({super.key, required this.vName, required this.vid}) {
    controller.fetchVehicles(vName);
  }

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Your Search Vehicle",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: mheight * 0.030),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple));
        }

        if (controller.vehicles.isEmpty) {
          return Center(child: Text("No vehicles found for '$vName'"));
        }

        return Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: mheight * 0.31,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5
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
                      description : vehicle["Vehicle_Description"],
                      price: vehicle["Rent_Price"].toString(),
                      image: vehicle["Vehicle_Image"],
                    ));
                  }
                },
                child: Card(
                  borderOnForeground: true,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
                                child: Text(
                                  vehicle["Cat_Name"],
                                  style:
                                  const TextStyle(color: Colors.blueGrey),
                                )),
                            const Icon(
                              Icons.info_outline,
                              color: Colors.blueGrey,
                            )
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                        child: Image.network(
                          vehicle["Vehicle_Image"],
                          fit: BoxFit.cover,
                          height: mheight * 0.16,
                          width: mwidth * 0.5,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 4, bottom: 2, right: 4),
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  vehicle["Vehicle_Name"],
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "₹ ${vehicle["Rent_Price"]} / Day",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
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
