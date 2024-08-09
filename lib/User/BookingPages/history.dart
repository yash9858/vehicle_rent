import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentify/User/BookingPages/book_summary.dart';

class HistoryController extends GetxController {
  var currentBookings = [].obs;
  var pastBookings = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookingHistory();
  }

  Future<void> fetchBookingHistory() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      var bookingCollection = FirebaseFirestore.instance.collection('Bookings');

      var currentSnapshot = await bookingCollection
          .where('Login_Id', isEqualTo: currentUser?.email)
          .where('Booking_Status', isEqualTo: 'Paid')
          .get();

      var pastSnapshot = await bookingCollection
          .where('Login_Id', isEqualTo: currentUser?.email)
          .where('Booking_Status', isEqualTo: 'Cancel')
          .get();

      // Fetch vehicle data for current bookings
      await Future.wait(currentSnapshot.docs.map((doc) async {
        var vehicleData = await getVehicleData(doc['Vehicle_Id']);
        if (vehicleData != null) {
          currentBookings.add({
            ...doc.data(),
            'Vehicle_Data': vehicleData,
          });
        }
      }));

      // Fetch vehicle data for past bookings
      await Future.wait(pastSnapshot.docs.map((doc) async {
        var vehicleData = await getVehicleData(doc['Vehicle_Id']);
        if (vehicleData != null) {
          pastBookings.add({
            ...doc.data(),
            'Vehicle_Data': vehicleData,
          });
        }
      }));
    } catch (e) {
      print("Error fetching booking history: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>?> getVehicleData(dynamic vehicleId) async {
    try {
      if (vehicleId is DocumentReference) {
        var vehicleDoc = await vehicleId.get();
        return vehicleDoc.exists ? vehicleDoc.data() as Map<String, dynamic>? : null;
      }
      else if (vehicleId is String) {
        var vehicleDoc = await FirebaseFirestore.instance.collection('Vehicles').doc(vehicleId).get();
        return vehicleDoc.exists ? vehicleDoc.data() : null;
      }
    } catch (e) {
      print("Error fetching vehicle data: $e");
      return null;
    }
    return null;
  }
}


class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HistoryController());
    var mdheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Booking History",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: mdheight * 0.030,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: const TabBar(
            indicatorColor: Colors.deepPurple,
            indicatorWeight: 3,
            labelColor: Colors.black,
            tabs: [
              Tab(text: 'Current Booking'),
              Tab(text: 'Past Booking'),
            ],
          ),
        ),
        body: Obx(
              () => controller.isLoading.value
              ? const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          )
              : TabBarView(
            children: [
              buildBookingList(controller.currentBookings, mdheight, mwidth),
              buildBookingList(controller.pastBookings, mdheight, mwidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBookingList(RxList bookings, double mdheight, double mwidth) {
    return bookings.isEmpty
        ? Container(
      padding: const EdgeInsets.only(top: 5, left: 8, right: 8),
      child: const Center(child: Text('No Bookings')),
    )
        : Container(
      padding: const EdgeInsets.only(top: 5, left: 8, right: 8),
      child: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          var booking = bookings[index];
          var vehicleData = booking['Vehicle_Data'];
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            elevation: 6,
            child: Row(
              children: [
                Image.network(
                  vehicleData["Vehicle_Image"],
                  fit: BoxFit.contain,
                  height: mdheight * 0.15,
                  width: mwidth * 0.4,
                ),
                SizedBox(width: mwidth * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 2, bottom: 2),
                            decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(vehicleData["Cat_Name"]),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 5, right: 5, top: 2),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.bookmark,
                                  color: Colors.blueGrey,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: mdheight * 0.01),
                      Text(
                        vehicleData["Vehicle_Name"],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Text("₹",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    vehicleData["Rent_Price"].toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const Text("/day"),
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                Get.to(()=> BookSummary(
                                  index: index,
                                  vid: booking["Vehicle_Id"],
                                  image: vehicleData["Vehicle_Image"],
                                  name: vehicleData["Vehicle_Name"],
                                  catName: vehicleData["Cat_Name"],
                                  price : vehicleData["Rent_Price"].toString(),
                                ));
                              },
                              child: const Text("View"))
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
