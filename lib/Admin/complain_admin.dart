import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminComplainController extends GetxController {
  var isLoading = false.obs;
  var complains = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchComplains();
  }

  Future<void> fetchComplains() async {
    try {
      isLoading(true);
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Complains')
          .orderBy('Timestamp', descending: true).get();


      for (var complainDoc in snapshot.docs) {
        var complainData = complainDoc.data() as Map<String, dynamic>;
        var vehicleId = complainData['Vehicle_Id'];
        var loginId = complainData['Login_Id'];

        DocumentSnapshot vehicleSnapshot = await FirebaseFirestore.instance.collection('Vehicles')
            .doc(vehicleId).get();

        if (vehicleSnapshot.exists) {
          complainData['Vehicle_Name'] = vehicleSnapshot['Vehicle_Name'];
        }
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Users')
            .doc(loginId).get();

        if (userSnapshot.exists) {
          complainData['Name'] = userSnapshot['Name'];
        }
        complains.add(complainData);
      }
    }
    catch(e){
      Fluttertoast.showToast(
          msg: "Failed To Fetch Complain",
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

class AdminComplainPage extends StatelessWidget {
  AdminComplainPage({super.key});
  final AdminComplainController controller = Get.put(AdminComplainController());

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
        title: const Text('Complains'),
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

        if (controller.complains.isEmpty) {
          return Center(
            child: Text(
              'No Complains available',
              style: TextStyle(
                color: Colors.deepPurple.shade800,
                fontSize: mdheight * 0.02,
              ),
            ),
          );
        }

          return RefreshIndicator(
            onRefresh: () async {
              controller.fetchComplains();
            },
            child:  ListView.builder(
                itemCount: controller.complains.length,
                itemBuilder: (BuildContext context, int index) {
                  var complain = controller.complains[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mdwidth * 0.025, vertical: mdheight * 0.005),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(mdheight * 0.01),
                      shadowColor: Colors.deepPurple.shade800,
                      semanticContainer: true,
                      surfaceTintColor: Colors.deepPurple.shade800,
                      child: Padding(
                        padding: EdgeInsets.all(mdheight * 0.017),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User Name : ${complain["Name"]}', style: TextStyle(fontSize: mdheight * 0.024, fontWeight: FontWeight.bold),),
                            SizedBox(height: mdheight * 0.01),
                            Text('Complain Time : ${complain["Timestamp"].toString()}'),
                            Text('Vehicle Name : ${complain["Vehicle_Name"]}'),
                            Text('Complain Description : ${complain["Complain"]}'),
                            SizedBox(height: mdheight * 0.01),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          );
        }
      ),
    );
  }
}
