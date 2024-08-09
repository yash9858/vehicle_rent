import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rentify/User/BookingPages/cancel_booking.dart';
import 'package:rentify/User/BookingPages/complain.dart';
import 'package:rentify/User/FeedbackPages/write_feedback.dart';

class BookSummary extends StatefulWidget {
  final int index;
  final String vid;
  final String image;
  final String name;
  final String catName;
  final String price;

  const BookSummary({
    super.key,
    required this.index,
    required this.vid,
    required this.image,
    required this.name,
    required this.catName,
    required this.price,
  });

  @override
  State<BookSummary> createState() => _BookSummaryState();
}

class _BookSummaryState extends State<BookSummary> {
  dynamic bookingData;
  double? totalPrice;
  var ratingList = <double>[];
  var averageRating = 0.0;
  dynamic mode;
  double? deductAmount;
  double? remainingPay;
  List<double> ratingsList = [];
  var feedbacks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchBookingData();
    await fetchTotalPrice();
    await fetchRatings();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchBookingData() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    var bookingCollection = FirebaseFirestore.instance.collection('Bookings');
    var querySnapshot = await bookingCollection
        .where('Vehicle_Id', isEqualTo: widget.vid)
        .where('Login_Id', isEqualTo: currentUser?.email)
        .orderBy(FieldPath.documentId, descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        bookingData = querySnapshot.docs.first.data();
      });
    }
  }

  Future<void> fetchTotalPrice() async {
    if (bookingData != null) {
      var paymentCollection = FirebaseFirestore.instance.collection('Payments');
      var paymentSnapshot = await paymentCollection
          .where('Booking_Id', isEqualTo: bookingData['Booking_Id'].toString())
          .limit(1)
          .get();

      if (paymentSnapshot.docs.isNotEmpty) {
        var paymentData = paymentSnapshot.docs.first.data();
        setState(() {
          mode = paymentData["Payment_Mode"].toString();
          totalPrice = double.parse(paymentData['Total_Price'].toString());
          deductAmount = totalPrice! / 10;
          remainingPay = totalPrice! - deductAmount!;
        });
      }
    }
  }

  Future<void> fetchRatings() async {
    try {
      var feedbackSnapshot = await FirebaseFirestore.instance
          .collection('Feedbacks')
          .where('Vehicle_Id', isEqualTo: widget.vid)
          .get();

      for (var doc in feedbackSnapshot.docs) {
        var data = doc.data();
        ratingList.add(double.parse(data['Ratings']));
        feedbacks.add(data);
      }

      calculateAverageRating();
      isLoading = false;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      isLoading = false;
    }
  }

  void calculateAverageRating() {
    if (ratingList.isEmpty) {
      averageRating = 0.0;
    } else {
      var sum = ratingList.reduce((a, b) => a + b);
      averageRating = sum / ratingList.length;
    }
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy ').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Book Summary",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: mheight * 0.030),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.network(
                          widget.image,
                          fit: BoxFit.contain,
                          height: mheight * 0.15,
                          width: mwidth * 0.4,
                        ),
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
                                    child: Text(widget.catName)),
                                Row(
                                  children: [
                                    Text(averageRating.toString()),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 18,
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: mheight * 0.01,
                            ),
                            Text(
                              widget.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: mheight * 0.03,
                            ),
                            Row(
                              children: [
                                const Text("₹"),
                                Text(
                                  widget.price,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text("/day"),
                              ],
                            ),
                          ],
                        ))
                      ],
                    ),
                    Divider(
                      height: mheight * 0.05,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Pick-Up Time",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              bookingData["Start_Time"].toString(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mheight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Pick-Up Date",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              formatDate(bookingData["Start_Date"]),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mheight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Return  Time",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              bookingData["Return_Time"].toString(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mheight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Return Date",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              formatDate(bookingData["Return_Date"]),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      height: mheight * 0.05,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Payment Mode",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(mode.toString()),
                          ],
                        ),
                        SizedBox(
                          height: mheight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Amount",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Row(children: [
                              const Text("₹"),
                              Text(
                                "${widget.price}/day",
                              ),
                            ])
                          ],
                        ),
                        Divider(
                          height: mheight * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                const Text("₹"),
                                Text(totalPrice?.toString() ?? "N/A"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: mheight * 0.08,
                    ),
                  ],
                ),
              ),
            ),
      bottomSheet: Container(
        padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (bookingData["Booking_Status"] == "Paid") ...[
                    Expanded(
                      child: SizedBox(
                          height: mheight * 0.065,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple.shade800,
                            ),
                            onPressed: () {
                              Get.to(() => CancelBookingUser(
                                    bid: bookingData["Booking_Id"].toString(),
                                    amount: remainingPay.toString(),
                                  ));
                            },
                            child: const Text("Cancel"),
                          )),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                  Expanded(
                    child: SizedBox(
                        height: mheight * 0.065,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black),
                            onPressed: () {
                              Get.to(() =>
                                  Complain(vid: bookingData["Vehicle_Id"]));
                            },
                            child: const Text("Complain"))),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  if (bookingData["Booking_Status"] == "Cancel") ...[
                    Expanded(
                      child: SizedBox(
                          height: mheight * 0.065,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple.shade800,
                            ),
                            onPressed: () {
                              Get.to(() => FeedBackUser(
                                    num: widget.index,
                                    vid: bookingData["Vehicle_Id"].toString(),
                                  ));
                            },
                            child: const Text("Feedback"),
                          )),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
