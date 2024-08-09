import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentify/User/PaymentPages/payment_page.dart';

class SelectDateController extends GetxController {
  final String vid;
  final String avg;
  final String name;
  final String image;
  final String catName;
  final String type;
  final String price;

  SelectDateController({
    required this.vid,
    required this.avg,
    required this.image,
    required this.type,
    required this.name,
    required this.catName,
    required this.price,
  });

  TextEditingController addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = true.obs;
  dynamic vehicleData;
  var ratingsList = <double>[].obs;
  var userData = {}.obs;
  var pickupDate = DateTime.now().obs;
  var pickupTime = TimeOfDay(hour: DateTime.now().hour + 2, minute: 0).obs;
  var returnDate = DateTime.now().obs;
  var returnTime = TimeOfDay(hour: DateTime.now().hour + 3, minute: 0).obs;
  dynamic bookingId;

  @override
  void onInit() {
    super.onInit();
    fetchAddress();
  }

  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: pickupDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      pickupDate.value = picked;
      if (picked.isAfter(returnDate.value)) {
        returnDate.value = picked;
      }
    }
  }

  void pickTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: pickupTime.value,
    );

    if (picked != null) {
      final now = TimeOfDay.now();
      if (picked.hour < now.hour || (picked.hour == now.hour && picked.minute < now.minute)) {
        Fluttertoast.showToast(
          msg: "Selected time is in the past.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        pickupTime.value = picked;
        if (pickupDate.value.isAtSameMomentAs(returnDate.value) && picked.hour > returnTime.value.hour) {
          returnTime.value = TimeOfDay(hour: picked.hour + 1, minute: picked.minute);
        }
      }
    }
  }

  void returnDatePicker(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: returnDate.value,
      firstDate: pickupDate.value,
      lastDate: DateTime(2025),
    );

    if (picked != null) {
      returnDate.value = picked;
    }
  }

  void returnTimePicker(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: returnTime.value,
    );

    if (picked != null) {
      if (returnDate.value.isAtSameMomentAs(pickupDate.value) && picked.hour < pickupTime.value.hour) {
        Fluttertoast.showToast(
          msg: "Return time must be after pickup time.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        returnTime.value = picked;
      }
    }
  }


  Future<void> fetchAddress() async {
    isLoading.value = true;
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        var response = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .get();
        if (response.exists) {
          userData.value = response.data()!;
          addressController.text = userData["Address"] ?? "";
        }
      }
      isLoading.value = false;
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error fetching user data: $error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      isLoading.value = false;
    }
  }

  Future<void> updateAddress() async {
    isLoading.value = true;
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.email)
            .update({
          'Address': addressController.text,
        });

        Fluttertoast.showToast(
          msg: "Address updated successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
      isLoading.value = false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error updating address: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      isLoading.value = false;
    }
  }

  Future<void> fetchRatings() async {
    try {
      final feedbackSnapshot = await FirebaseFirestore.instance
          .collection('VehicleFeedback')
          .where('Vehicle_Id', isEqualTo: vehicleData['Vehicle_Id'])
          .get();

      if (feedbackSnapshot.docs.isNotEmpty) {
        ratingsList.value = feedbackSnapshot.docs
            .map((doc) => double.parse(doc['Ratings']))
            .toList();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching ratings: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  double calculateAverageRating() {
    if (ratingsList.isEmpty) {
      return 0.0;
    }
    double sum = ratingsList.fold(0, (previous, current) => previous + current);
    return sum / ratingsList.length;
  }

  Future<void> submitBooking(BuildContext context) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (formKey.currentState!.validate() && currentUser != null) {
      try {
        var counterRef = FirebaseFirestore.instance.collection('Counter').doc('bookingCounter');
        var counterSnapshot = await counterRef.get();

        if (counterSnapshot.exists) {
          bookingId = counterSnapshot.data()?['latestId'] + 1;
        } else {
          bookingId = 1;
        }

        await counterRef.set({'latestId': bookingId});



        await FirebaseFirestore.instance.collection('Bookings').doc(bookingId.toString()).set({
          'Booking_Id': bookingId,
          'Start_Date': DateFormat('yyyy-MM-dd').format(pickupDate.value),
          'Start_Time': '${pickupTime.value.hour.toString().padLeft(2, '0')}:${pickupTime.value.minute.toString().padLeft(2, '0')}',
          'Return_Date': DateFormat('yyyy-MM-dd').format(returnDate.value),
          'Return_Time': '${returnTime.value.hour.toString().padLeft(2, '0')}:${returnTime.value.minute.toString().padLeft(2, '0')}',
          'Price': double.parse(price),
          'Vehicle_Id': vid.toString(),
          'Login_Id': currentUser.email,
          'Booking_Status': 'Pending',
        });

        Fluttertoast.showToast(
          msg: "Booking successful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        Get.to(() => PaymentPage(
          vid: vid.toString(),
          price: price,
          starty: pickupDate.value.year.toString(),
          startm: pickupDate.value.month.toString(),
          startd: pickupDate.value.day.toString(),
          startt: pickupTime.value.hour.toString(),
          returny: returnDate.value.year.toString(),
          returnm: returnDate.value.month.toString(),
          returnd: returnDate.value.day.toString(),
          returnt: returnTime.value.hour.toString(),
        ));
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error submitting booking: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
  }
}


class SelectDate extends StatelessWidget {
  final String vid;
  final String name;
  final String avg;
  final String image;
  final String catName;
  final String type;
  final String price;

  const SelectDate({
    Key? key,
    required this.vid,
    required this.avg,
    required this.image,
    required this.type,
    required this.name,
    required this.catName,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SelectDateController(
      avg: avg,
      vid: vid,
      image: image,
      type: type,
      name: name,
      catName: catName,
      price: price,
    ));

    var mheight = MediaQuery
        .of(context)
        .size
        .height;
    var mwidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Select Date and Time",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: mheight * 0.030),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Obx(
            () =>
        controller.isLoading.value
            ? const Center(
          child: CircularProgressIndicator(color: Colors.deepPurple),
        )
            : SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network(
                        image,
                        fit: BoxFit.contain,
                        height: mheight * 0.15,
                        width: mwidth * 0.4,
                      ),
                      SizedBox(width: mwidth * 0.02),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.pink.shade50,
                                    borderRadius:
                                    BorderRadius.circular(6),
                                  ),
                                  child: Text(catName),
                                ),
                                Row(
                                  children: [
                                    Text(controller.avg.toString()),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.deepPurple,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: mheight * 0.01),
                            Text(
                              name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: mheight * 0.02),
                            ),
                            SizedBox(height: mheight * 0.01),
                            Text(
                              "₹ $price / Day",
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: mheight * 0.018),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  buildDateTimePicker(
                    context: context,
                    label: "Select Pickup Date",
                    date: controller.pickupDate.value,
                    time: controller.pickupTime.value,
                    onDatePressed: () => controller.pickDate(context),
                    onTimePressed: () => controller.pickTime(context),
                  ),
                  const SizedBox(height: 20),
                  buildDateTimePicker(
                    context: context,
                    label: "Select Return Date",
                    date: controller.returnDate.value,
                    time: controller.returnTime.value,
                    onDatePressed: () =>
                        controller.returnDatePicker(context),
                    onTimePressed: () =>
                        controller.returnTimePicker(context),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.addressController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: "Enter your address here",
                      labelText: "Address",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: () {
                        controller.updateAddress();
                        controller.submitBooking(context);
                      },
                      child: const Text("Payment"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDateTimePicker({
    required BuildContext context,
    required String label,
    required DateTime date,
    required TimeOfDay time,
    required VoidCallback onDatePressed,
    required VoidCallback onTimePressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: onDatePressed,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(DateFormat('yyyy-MM-dd').format(date)),
              ),
            ),
            InkWell(
              onTap: onTimePressed,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute
                      .toString().padLeft(2, '0')}',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}