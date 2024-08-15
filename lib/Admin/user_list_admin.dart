import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cool_alert/cool_alert.dart';

class AdminUserController extends GetxController {
  var isLoading = true.obs;
  var userList = [].obs;
  final auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading(true);
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Users')
          .where('Role', isEqualTo: 'User').get();
      userList.value = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['Email'] = doc.id;
        return data;
      }).toList();
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteUser(String userId, String profileImageUrl) async {
    try {
      var bookingsSnapshot = await FirebaseFirestore.instance.collection('Bookings')
          .where('Login_Id', isEqualTo: userId).get();
      for (var doc in bookingsSnapshot.docs) {
        await doc.reference.delete();
      }
      await _updateCounter('bookingCounter', -bookingsSnapshot.size);

      var paymentsSnapshot = await FirebaseFirestore.instance.collection('Payments')
          .where('Login_Id', isEqualTo: userId).get();
      for (var doc in paymentsSnapshot.docs) {
        await doc.reference.delete();
      }
      await _updateCounter('paymentCounter', -paymentsSnapshot.size);

      var feedbackSnapshot = await FirebaseFirestore.instance.collection('Feedbacks')
          .where('Login_Id', isEqualTo: userId).get();
      for (var doc in feedbackSnapshot.docs) {
        await doc.reference.delete();
      }
      await _updateCounter('FeedbackCounter', -feedbackSnapshot.size);

      var complainSnapshot = await FirebaseFirestore.instance.collection('Complains')
          .where('Login_Id', isEqualTo: userId).get();
      for (var doc in complainSnapshot.docs) {
        await doc.reference.delete();
      }
      await _updateCounter('ComplainCounter', -complainSnapshot.size);

      await FirebaseFirestore.instance.collection('Users').doc(userId).delete();
      await _updateCounter('UserCounter', -1);

      if (profileImageUrl.isNotEmpty) {
        var storageRef = FirebaseStorage.instance.refFromURL(profileImageUrl);
        await storageRef.delete();
      }
      fetchUserData();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed To Delete User",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    }
  }

  Future<void> _updateCounter(String counterName, int change) async {
    var counterRef = FirebaseFirestore.instance.collection('Counter').doc(
        counterName);
    var counterSnapshot = await counterRef.get();
    if (counterSnapshot.exists) {
      int currentCount = counterSnapshot.data()?['latestId'] ?? 0;
      await counterRef.update({'latestId': currentCount + change});
    }
  }
}

  class AdminUserPage extends StatelessWidget {
  final AdminUserController _controller = Get.put(AdminUserController());

  AdminUserPage({super.key});

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
        title: const Text('User List'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          );
        }
        if (_controller.userList.isEmpty) {
          return Center(
            child: Text(
              'No User available',
              style: TextStyle(
                color: Colors.deepPurple.shade800,
                fontSize: mdheight * 0.02,
              ),
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: ()async{
              _controller.fetchUserData();
            },
            child: ListView.builder(
              itemCount: _controller.userList.length,
              itemBuilder: (BuildContext context, int index) {
                var user = _controller.userList[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.025, vertical: mdheight * 0.005),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.all(mdheight * 0.01),
                    shadowColor: Colors.deepPurple.shade800,
                    surfaceTintColor: Colors.deepPurple.shade800,
                    child: Padding(
                      padding: EdgeInsets.all(mdheight * 0.017),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('Name: '),
                                        Text(user["Name"] ?? ''),
                                      ],
                                    ),
                                    SizedBox(height: mdheight * 0.01),
                                    Row(
                                      children: [
                                        const Text('Dob: '),
                                        Text(user["Dob"] ?? ''),
                                      ],
                                    ),
                                    SizedBox(height: mdheight * 0.01),
                                    Row(
                                      children: [
                                        const Text('Gender: '),
                                        Text(user["Gender"] ?? ''),
                                      ],
                                    ),
                                    SizedBox(height: mdheight * 0.01),
                                    const Row(
                                      children: [
                                        Text('Address: '),
                                      ],
                                    ),
                                    Text(user["Address"] ?? ''),
                                    SizedBox(height: mdheight * 0.01),
                                    const Row(
                                      children: [
                                        Text('Licence Number: '),
                                      ],
                                    ),
                                    Text(user["Lincence"] ?? ''),
                                    SizedBox(height: mdheight * 0.01),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      user["Profile_Image"] ?? '',
                                      height: mdheight * 0.15,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    text: 'Do you want to remove this user?',
                                    confirmBtnColor: Colors.red,
                                    onConfirmBtnTap: () {
                                      _controller
                                          .deleteUser(user["Email"].toString(), user["Profile_Image"])
                                          .whenComplete(() {
                                        Get.back(); // Close the alert
                                      });
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
                                  'Delete User',
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
        }
      }),
    );
  }
}
