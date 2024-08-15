import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentify/User/PaymentPages/wait_payment.dart';

class PaymentPage extends StatefulWidget {
  final String vid;
  final String price;
  final String starty;
  final String startm;
  final String startd;
  final String startt;
  final String returny;
  final String returnm;
  final String returnd;
  final String returnt;

  const PaymentPage({
    Key? key,
    required this.vid,
    required this.price,
    required this.starty,
    required this.startm,
    required this.startd,
    required this.startt,
    required this.returny,
    required this.returnm,
    required this.returnd,
    required this.returnt,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = true;
  double totalPrice = 0.0;
  dynamic selectedOption;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String? bookingId;
  dynamic paymentId;

  @override
  void initState() {
    super.initState();
    fetchBookingId();
    totalPrice = calculateTotalPrice(
      DateTime(int.parse(widget.starty), int.parse(widget.startm), int.parse(widget.startd)),
      double.parse(widget.startt),
      DateTime(int.parse(widget.returny), int.parse(widget.returnm), int.parse(widget.returnd)),
      double.parse(widget.returnt),
    );
  }

  double calculateTotalPrice(DateTime startDate, double startHour, DateTime endDate, double endHour) {
    double pricePerDate = double.parse(widget.price);
    int totalDays = endDate.difference(startDate).inDays;
    if (totalDays == 0 && endHour > startHour) {
      totalDays = 0;
    }
    double totalPrice = totalDays * pricePerDate;
    if (endHour > startHour) {
      totalPrice += (endHour - startHour) * (pricePerDate / 24);
    }
    return double.parse(totalPrice.toStringAsFixed(2));
  }

  Future<void> fetchBookingId() async {
    try {
      var bookingCollection = FirebaseFirestore.instance.collection('Bookings');
      var querySnapshot = await bookingCollection.orderBy('Booking_Id', descending: true).limit(1).get();

      int latestId = 1;
      if (querySnapshot.docs.isNotEmpty) {
        var latestBooking = querySnapshot.docs.first;
        latestId = latestBooking['Booking_Id'];
      }
      bookingId = (latestId).toString();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching booking ID. Please try again.");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> makePayment() async {
    try {
      var counterRef = FirebaseFirestore.instance.collection('Counter').doc('paymentCounter');
      var counterSnapshot = await counterRef.get();

      if (counterSnapshot.exists) {
        paymentId = counterSnapshot.data()?['latestId'] + 1;
      } else {
        paymentId = 1;
      }

      await counterRef.set({'latestId': paymentId});

      String formatDateTime(DateTime date) {
        int hour = date.hour;
        String period = hour >= 12 ? 'PM' : 'AM';
        hour = hour % 12;
        if (hour == 0) hour = 12;

        return "${date.day}/${date.month}/${date.year}, $hour:${date.minute.toString().padLeft(2, '0')} $period";
      }

      DateTime now = DateTime.now();
      String formattedDate = formatDateTime(now);

      var paymentCollection = FirebaseFirestore.instance.collection('Payments');
      await paymentCollection.add({
        'Payment_Time': formattedDate,
        'Payment_Mode': selectedOption,
        'Booking_Id': bookingId.toString(),
        'Total_Price': totalPrice,
        'Login_Id': currentUser?.email,
        'Vehicle_Id' : widget.vid,
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error making payment. Please try again.");
    }
  }

  Future<void> updateBookingStatus() async {
    try {
      var bookingCollection = FirebaseFirestore.instance.collection('Bookings');
      var vehicleCollection = FirebaseFirestore.instance.collection('Vehicles');

      await bookingCollection.doc(bookingId).update({'Booking_Status': 'Paid'});
      await vehicleCollection.doc(widget.vid).update({'Status': 'Unavailable'});

      Get.to(() => WaitPay());
    } catch (e) {
      Fluttertoast.showToast(msg: "Error updating status. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Payment Methods",
          style: TextStyle(color: Colors.black, fontSize: mheight * 0.030, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : Container(
        padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text('Total Price', style: TextStyle(fontSize: 17)),
                  trailing: Text("₹$totalPrice", style: const TextStyle(fontSize: 17)),
                ),
                SizedBox(height: mheight * 0.02),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Cash", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: mheight * 0.01),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.money, color: Colors.deepPurple.shade400),
                    title: const Text('Cash', style: TextStyle(color: Colors.grey)),
                    trailing: Radio(
                      value: 'Cash',
                      activeColor: Colors.deepPurple.shade400,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: mheight * 0.02),
            SizedBox(height: mheight * 0.05),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("More Payment Options", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: mheight * 0.01),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      for (String option in ['Paypal', 'Google pay', 'Paytm'])
                        RadioListTile(
                          title: Text(option, style: const TextStyle(fontSize: 18)),
                          value: option,
                          activeColor: Colors.deepPurple.shade400,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
        width: double.infinity,
        height: mheight * 0.08,
        child: ElevatedButton(
          onPressed: () async {
            if (selectedOption != null) {
              await makePayment();
              await updateBookingStatus();
            } else {
              Fluttertoast.showToast(
                msg: "Please select a payment method.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
              );
            }
          },
          child: const Text("Confirm Payment", style: TextStyle(fontSize: 15)),
        ),
      ),
    );
  }
}
