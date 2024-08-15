import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AdminPaymentController extends GetxController {
  var paymentList = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPayments();
  }

  void fetchPayments() async {
    try {
      isLoading(true);
      QuerySnapshot paymentSnapshot = await FirebaseFirestore.instance.collection('Payments').get();
      for (var paymentDoc in paymentSnapshot.docs) {
        var paymentData = paymentDoc.data() as Map<String, dynamic>;
        var bookingId = paymentData['Booking_Id'];
        DocumentSnapshot bookingSnapshot = await FirebaseFirestore.instance.collection('Bookings')
            .doc(bookingId).get();

        if (bookingSnapshot.exists) {
          var bookingData = bookingSnapshot.data() as Map<String, dynamic>;
          var vehicleId = bookingData['Vehicle_Id'];
          var loginId = bookingData['Login_Id'];
          DocumentSnapshot vehicleSnapshot = await FirebaseFirestore.instance.collection('Vehicles')
              .doc(vehicleId).get();

          if (vehicleSnapshot.exists) {
            paymentData['Vehicle_Name'] = vehicleSnapshot['Vehicle_Name'];
          }

          DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Users')
              .doc(loginId).get();

          if (userSnapshot.exists) {
            paymentData['Name'] = userSnapshot['Name'];
          }
        }
        paymentList.add(paymentData);
      }
    }
    catch(e){
      Fluttertoast.showToast(
          msg: "Failed To Fetch Payments",
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

class AdminPaymentPage extends StatelessWidget {
  const AdminPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminPaymentController controller = Get.put(AdminPaymentController());
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text('Payment List'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          );
        }

        if (controller.paymentList.isEmpty) {
          return Center(
            child: Text(
              'No Payments Available',
              style: TextStyle(
                color: Colors.deepPurple.shade800,
                fontSize: mdheight * 0.02,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async{
            controller.fetchPayments();
          },
          child: ListView.builder(
            itemCount: controller.paymentList.length,
            itemBuilder: (BuildContext context, int index) {
              var payment = controller.paymentList[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.025, vertical: mdheight * 0.005),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(mdheight * 0.01),
                  shadowColor: Colors.deepPurple.shade800,
                  child: Padding(
                    padding: EdgeInsets.all(mdheight * 0.017),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User Name : ${payment['Name']}', style: TextStyle(fontSize: mdheight * 0.024,fontWeight: FontWeight.bold),),
                        SizedBox(height: mdheight * 0.01),
                        Text('Booking Id : ${payment['Booking_Id'].toString()}'),
                        Text('Vehicle Name : ${payment['Vehicle_Name']}'),
                        Text('Payment Mode : ${payment['Payment_Mode']}'),
                        Text('Payment Time : ${payment['Payment_Time']}'),
                        Text('Total Price : ₹${payment['Total_Price'].toString()}'),
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
