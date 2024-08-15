import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComplainController extends GetxController {
  var isLoading = false.obs;
  TextEditingController complaintController = TextEditingController();
  var selectedType = 'Booking Issue'.obs;
  dynamic complainId;

  Future<void> submitComplaint(String vid) async {
    if (complaintController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Type your complaint here.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
      return;
    }

    try {
      isLoading(true);
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Fluttertoast.showToast(
          msg: "User Not Logged In.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
        );
        return;
      }

      String formatDateTime(DateTime date) {
        int hour = date.hour;
        String period = hour >= 12 ? 'PM' : 'AM';
        hour = hour % 12;
        if (hour == 0) hour = 12;
        return "${date.day}/${date.month}/${date.year}, $hour:${date.minute.toString().padLeft(2, '0')} $period";
      }
      DateTime now = DateTime.now();
      String formattedDate = formatDateTime(now);

      var counterRef = FirebaseFirestore.instance.collection('Counter').doc('ComplainCounter');
      var counterSnapshot = await counterRef.get();
      if (counterSnapshot.exists) {
        complainId = counterSnapshot.data()?['latestId'] + 1;
      }
      else {
        complainId = 1;
      }

      await counterRef.set({'latestId': complainId});
      await FirebaseFirestore.instance.collection('Complains').add({
        'Complain_Id' : complainId,
        'Complain': complaintController.text,
        'Login_Id': currentUser.email,
        'Vehicle_Id': vid.toString(),
        'Complain_Status': 'Send',
        'Timestamp': formattedDate,
      });
      Fluttertoast.showToast(
        msg: "Complaint Submitted Successfully.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
      complaintController.clear();
      selectedType.value = 'Booking Issue';
      Get.back();
    }
    catch (e) {
      Fluttertoast.showToast(
        msg: "Failed To Submit Complaint",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    }
    finally {
      isLoading(false);
    }
  }
}

class Complain extends StatelessWidget {
  final String vid;
  final ComplainController controller = Get.put(ComplainController());
  Complain({super.key, required this.vid});

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "Complain",
          style: TextStyle(fontSize: mheight * 0.030, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: mheight * 0.02),
              const Text(
                'Describe Your Complaint:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: mheight * 0.03),
              Form(
                child: TextFormField(
                  controller: controller.complaintController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Type Your Complaint Here...',
                  ),
                ),
              ),
              SizedBox(height: mheight * 0.05),
              const Text(
                'Type of Complaint:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Obx(
                    () => DropdownButton<String>(
                  value: controller.selectedType.value,
                  onChanged: (newValue) {
                    controller.selectedType.value = newValue!;
                    controller.complaintController.text = newValue;
                  },
                  items: [
                    'Booking Issue',
                    'Vehicle Condition',
                    'Customer Service',
                    'Other'
                  ].map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
        height: mheight * 0.08,
        width: mwidth,
        child: MaterialButton(
          color: Colors.deepPurple.shade800,
          onPressed: () {
            controller.submitComplaint(vid);
          },
          child: const Text(
            "Submit Complaint",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
