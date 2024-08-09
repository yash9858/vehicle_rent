import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CancelBookingController extends GetxController {
  var isLoading = false.obs;
  var selectedOption = ''.obs;
  var cancelReason = ''.obs;

  List<String> reason = [
    'Schedule change',
    'Book Another Car',
    'Found a Better Alternative',
    'Want to Book another car',
    'My Reason is not listed',
    'Other'
  ];

  void selectReason(String value) {
    selectedOption.value = value;
    cancelReason.value = value;
  }

  Future<void> cancelBooking(String bookingId, String amount) async {
    if (cancelReason.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please provide a cancellation reason",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2);
      return;
    }

    try {
      isLoading.value = true;
      await FirebaseFirestore.instance.collection('Bookings').doc(bookingId).update({
        'Cancellation_Reason': cancelReason.value,
        'Refund_Amount': amount,
        'Refund_Status': 'Success',
        'Booking_Status': 'Cancel',
      });

      Fluttertoast.showToast(
          msg: "Booking Cancelled Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2);
    } finally {
      isLoading.value = false;
    }
  }
}

class CancelBookingUser extends StatelessWidget {
  final String? bid;
  final String amount;
  CancelBookingUser({Key? key, required this.bid, required this.amount}) : super(key: key);

  final CancelBookingController controller = Get.put(CancelBookingController());

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cancel Booking",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: mheight * 0.030),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: mheight * 0.01),
              const Padding(
                padding: EdgeInsets.only(left: 19),
                child: Text(
                  "Note: If you cancel the ride, 10% will be deducted from your refund amount.",
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: mheight * 0.04),
              const Padding(
                padding: EdgeInsets.only(left: 19),
                child: Text(
                  "Please select the reason for cancellation:",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
              SizedBox(height: mheight * 0.02),
              ...controller.reason.map((option) {
                return Obx(() => RadioListTile(
                  title: Text(option, style: const TextStyle(fontSize: 18)),
                  value: option,
                  groupValue: controller.selectedOption.value,
                  onChanged: (value) {
                    controller.selectReason(value.toString());
                  },
                ));
              }).toList(),
              Divider(height: mheight * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  controller: TextEditingController(text: controller.cancelReason.value),
                  maxLines: 4,
                  cursorColor: Colors.deepPurple.shade800,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: "Enter Your Reason",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple.shade800),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) => controller.cancelReason.value = value,
                ),
              ),
              SizedBox(height: mheight * 0.08),
            ],
          ),
        ),
      )),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        height: mheight * 0.08,
        width: mwidth,
        child: MaterialButton(
          color: Colors.deepPurple.shade800,
          onPressed: () {
            controller.cancelBooking(bid!, amount);
          },
          child: const Text(
            "Cancel Ride",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
