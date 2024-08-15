import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminFeedbackController extends GetxController {
  var feedbackList = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeedbacks();
  }

  void fetchFeedbacks() async {
    try {
      isLoading(true);
      QuerySnapshot feedbackSnapshot = await FirebaseFirestore.instance.collection('Feedbacks').get();

      for (var feedbackDoc in feedbackSnapshot.docs) {
        var feedbackData = feedbackDoc.data() as Map<String, dynamic>;
        var vehicleId = feedbackData['Vehicle_Id'];

        DocumentSnapshot vehicleSnapshot = await FirebaseFirestore.instance.collection('Vehicles')
            .doc(vehicleId).get();

        if (vehicleSnapshot.exists) {
          feedbackData['Vehicle_Name'] = vehicleSnapshot['Vehicle_Name'];
        }
        feedbackList.add(feedbackData);
      }
    }
    catch(e){
      Fluttertoast.showToast(
          msg: "Failed To Fetch Feedbacks",
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

class AdminFeedbackPage extends StatelessWidget {
  const AdminFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminFeedbackController controller = Get.put(AdminFeedbackController());
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text('Feedbacks'),
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

        if (controller.feedbackList.isEmpty) {
          return Center(
            child: Text(
              'No Feedbacks Available',
              style: TextStyle(
                color: Colors.deepPurple.shade800,
                fontSize: mdheight * 0.02,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: ()async{
            controller.fetchFeedbacks();
          },
          child: ListView.builder(
            itemCount: controller.feedbackList.length,
            itemBuilder: (BuildContext context, int index) {
              var feedback = controller.feedbackList[index];
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
                        Text('User Name : ${feedback["Name"]}',style: TextStyle(fontSize: mdheight * 0.024,fontWeight: FontWeight.bold),),
                        SizedBox(height: mdheight * 0.01),
                        Text('Feedback Time : ${feedback["Feedback_Time"]}'),
                        Text('Vehicle Name : ${feedback["Vehicle_Name"]}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Comment : ${feedback["Comment"]}'),
                            Row(
                              children: [
                                Text(feedback["Ratings"]),
                                const Icon(LineIcons.starAlt, color: Colors.amber),
                              ],
                            )
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
      }),
    );
  }
}
