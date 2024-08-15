import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminBookingController extends GetxController {
  var isLoading = false.obs;
  var bookings = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  void fetchBookings() async {
    try {
      isLoading(true);
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Bookings')
          .where('Booking_Status', isEqualTo: 'Paid').get();

      List<Map<String, dynamic>> fetchedBookings = [];
      for (var doc in snapshot.docs) {
        var bookingData = doc.data() as Map<String, dynamic>;
        DocumentSnapshot vehicleSnapshot = await FirebaseFirestore.instance.collection('Vehicles')
            .doc(bookingData['Vehicle_Id']).get();
        String vehicleName = vehicleSnapshot['Vehicle_Name'];

        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Users')
            .doc(bookingData['Login_Id']).get();
        String userName = userSnapshot['Name'];
        String address = userSnapshot['Address'];

        bookingData['Vehicle_Name'] = vehicleName;
        bookingData['Name'] = userName;
        bookingData['Address'] = address;
        fetchedBookings.add(bookingData);
      }
      bookings.value = fetchedBookings;
    }
    catch (e) {
      Fluttertoast.showToast(
          msg: "Failed To Fetch Bookings",
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

class AdminBookingPage extends StatelessWidget {
  AdminBookingPage({super.key});
  final AdminBookingController controller = Get.put(AdminBookingController());

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text('All Bookings'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
        }

        if (controller.bookings.isEmpty) {
          return Center(
            child: Text(
              'No Bookings Available',
              style: TextStyle(
                color: Colors.deepPurple.shade800,
                fontSize: mdheight * 0.02,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: ()async{
            controller.fetchBookings();
          },
          child: ListView.builder(
            itemCount: controller.bookings.length,
            itemBuilder: (BuildContext context, int index) {
              var booking = controller.bookings[index];
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
                      children: [
                        Text("User Name: ${booking["Name"]}", style: TextStyle(fontSize: mdheight * 0.024,fontWeight: FontWeight.bold),),
                        SizedBox(height: mdheight * 0.01),
                        Text("Vehicle Name: ${booking["Vehicle_Name"]}"),
                        Text('Start Date : ${booking["Start_Date"]}'),
                        Text('Start Time : ${booking["Start_Time"]}'),
                        Text('Return Date : ${booking["Return_Date"]}'),
                        Text('Return Time : ${booking["Return_Time"]}'),
                        Text('Booking Status : ${booking["Booking_Status"]}'),
                        Text('Address : ${booking["Address"]}'),
                        SizedBox(height: mdheight * 0.01),
                      ],
                    ),
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