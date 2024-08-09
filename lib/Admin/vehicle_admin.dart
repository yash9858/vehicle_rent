import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:rentify/Admin/select_category.dart';
import 'package:rentify/Admin/update_vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleController extends GetxController {
  var isLoading = true.obs;
  var vehicleList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVehicleData();
  }

  void fetchVehicleData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Vehicles').get();
      vehicleList.value = snapshot.docs.map((doc) => doc.data()).toList();
    }
    catch (e) {
      e.toString();
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    try {
      await FirebaseFirestore.instance.collection('Vehicles').doc(vehicleId).delete();
      fetchVehicleData();
    }
    catch (e) {
      e.toString();
    }
  }
}


class AdminVehiclePage extends StatelessWidget {
  final VehicleController vehicleController = Get.put(VehicleController());

  AdminVehiclePage({super.key});

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
        title: const Text('Vehicle List'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (vehicleController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          );
        }

        return ListView.builder(
          itemCount: vehicleController.vehicleList.length,
          itemBuilder: (BuildContext context, int index) {
            var vehicle = vehicleController.vehicleList[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.025, vertical: mdheight * 0.005),
              child: Card(
                elevation: 5.0,
                shadowColor: Colors.deepPurple.shade800,
                semanticContainer: true,
                surfaceTintColor: Colors.deepPurple.shade800,
                child: Padding(
                  padding: EdgeInsets.all(mdheight * 0.017),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('Category Name: '),
                                    Text(vehicle["Cat_Name"]),
                                  ],
                                ),
                                SizedBox(height: mdheight * 0.01),
                                Row(
                                  children: [
                                    const Text('Vehicle Name: '),
                                    Text(vehicle["Vehicle_Name"]),
                                  ],
                                ),
                                SizedBox(height: mdheight * 0.01),
                                Row(
                                  children: [
                                    const Text('Vehicle Type: '),
                                    Text(vehicle["Vehicle_Type"]),
                                  ],
                                ),
                                SizedBox(height: mdheight * 0.01),
                                Row(
                                  children: [
                                    const Text('Rent Price: '),
                                    Text('${vehicle["Rent_Price"]}/day'),
                                  ],
                                ),
                                SizedBox(height: mdheight * 0.01),
                                const Row(
                                  children: [
                                    Text('Vehicle Description: '),
                                  ],
                                ),
                                Text(vehicle["Vehicle_Description"], maxLines: 3),
                                SizedBox(height: mdheight * 0.01),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.network(
                                  vehicle["Vehicle_Image"],
                                  height: mdheight * 0.15,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: mdheight * 0.015),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              Get.to(() => UpdateVehicle(val: index));
                            },
                            color: Colors.deepPurple.shade800,
                            padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                            ),
                            child: const Text(
                              'Edit Vehicle',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.confirm,
                                text: 'Do you want to remove the vehicle?',
                                confirmBtnColor: Colors.red,
                                onConfirmBtnTap: () {
                                  vehicleController.deleteVehicle(vehicle["Vehicle_Id"]);
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
                            padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                            ),
                            child: const Text(
                              'Delete Vehicle',
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
          Get.to(() => const Category());
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
