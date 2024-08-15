import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:rentify/Admin/select_category.dart';
import 'package:rentify/Admin/update_vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminVehicleController extends GetxController {
  var isLoading = true.obs;
  var vehicleList = [].obs;


  @override
  void onInit() {
    super.onInit();
    fetchVehicleData();
  }

  Future<void> fetchVehicleData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
          'Vehicles').get();
      vehicleList.value = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['Vehicle_Id'] = doc.id;
        return data;
      }).toList();
    }
    catch (e) {
      Fluttertoast.showToast(
          msg: "Failed To Fetch Vehicles",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteVehicle(String docId) async {
    try {
      var bookingsSnapshot = await FirebaseFirestore.instance
          .collection('Bookings')
          .where('Vehicle_Id', isEqualTo: docId)
          .get();
      for (var booking in bookingsSnapshot.docs) {
        await FirebaseFirestore.instance.collection('Bookings')
            .doc(booking.id)
            .delete();
      }
      await _updateCounter('bookingCounter', -bookingsSnapshot.size);

      var paymentsSnapshot = await FirebaseFirestore.instance
          .collection('Payments')
          .where('Vehicle_Id', isEqualTo: docId)
          .get();
      for (var payment in paymentsSnapshot.docs) {
        await FirebaseFirestore.instance.collection('Payments')
            .doc(payment.id)
            .delete();
      }
      await _updateCounter('paymentCounter', -paymentsSnapshot.size);

      var feedbackSnapshot = await FirebaseFirestore.instance
          .collection('Feedbacks')
          .where('Vehicle_Id', isEqualTo: docId)
          .get();
      for (var feedback in feedbackSnapshot.docs) {
        await FirebaseFirestore.instance.collection('Feedbacks').doc(
            feedback.id).delete();
      }
      await _updateCounter('FeedbackCounter', -feedbackSnapshot.size);

      var complaintsSnapshot = await FirebaseFirestore.instance
          .collection('Complains')
          .where('Vehicle_Id', isEqualTo: docId)
          .get();
      for (var complaint in complaintsSnapshot.docs) {
        await FirebaseFirestore.instance.collection('Complains').doc(
            complaint.id).delete();
      }
      await _updateCounter('ComplainCounter', -complaintsSnapshot.size);

      await FirebaseFirestore.instance.collection('Vehicles')
          .doc(docId)
          .delete();
      await _updateCounter('VehicleCounter', -1);

      fetchVehicleData();

      Fluttertoast.showToast(
          msg: "Vehicle Deleted Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed To Delete Vehicle",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    }
  }

  Future<void> _updateCounter(String counterName, int change) async {
    var counterRef = FirebaseFirestore.instance.collection('Counter').doc(counterName);
    var counterSnapshot = await counterRef.get();
    if (counterSnapshot.exists) {
      int currentCount = counterSnapshot.data()?['latestId'] ?? 0;
      await counterRef.update({'latestId': currentCount + change});
    }
  }
}

  class AdminVehiclePage extends StatelessWidget {
  final AdminVehicleController vehicleController = Get.put(AdminVehicleController());

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

        if (vehicleController.vehicleList.isEmpty) {
          return const Center(child: Text("No Vehicles Found."));
        }

        return RefreshIndicator(
          onRefresh: () async{
            await vehicleController.fetchVehicleData();
          },
          child: ListView.builder(
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
                                    Text("Category Name: ${vehicle["Cat_Name"]}"),
                                    SizedBox(height: mdheight * 0.01),
                                    Text("Vehicle Name: ${vehicle["Vehicle_Name"]}"),
                                    SizedBox(height: mdheight * 0.01),
                                    Text("Vehicle Type: ${vehicle["Vehicle_Type"]}"),
                                    SizedBox(height: mdheight * 0.01),
                                    Text('Rent Price: ₹${vehicle["Rent_Price"].toString()}/day'),
                                    SizedBox(height: mdheight * 0.01),
                                    Text("Vehicle Description: ${vehicle["Vehicle_Description"]}"),
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
                                  Get.to(() => UpdateVehicle(vehicleId: vehicle.id));
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
                                      vehicleController.deleteVehicle(vehicle["Vehicle_Id"].toString());
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
            ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => Category());
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
