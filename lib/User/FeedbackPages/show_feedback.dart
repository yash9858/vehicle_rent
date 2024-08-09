import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeedbackController extends GetxController {
  final String vehicleId;
  var isLoading = true.obs;
  var feedbacks = [].obs;

  FeedbackController(this.vehicleId);

  @override
  void onInit() {
    super.onInit();
    fetchFeedbacks();
  }

  Future<void> fetchFeedbacks() async {
    try {
      var feedbackSnapshot = await FirebaseFirestore.instance
          .collection('Feedbacks')
          .where('Vehicle_Id', isEqualTo: vehicleId)
          .get();

      feedbacks.value = feedbackSnapshot.docs.map((doc) => doc.data()).toList();
      isLoading.value = false;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      isLoading.value = false;
    }
  }
}

class ShowFeedback extends StatelessWidget {
  final String vehicleId;
  final FeedbackController controller;

  ShowFeedback({
    Key? key,
    required this.vehicleId,
  })  : controller = Get.put(FeedbackController(vehicleId)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.of(context).size.height;
    var mdwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Review And Rating",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.deepPurple),
          );
        } else if (controller.feedbacks.isEmpty) {
          return const Center(
            child: Text(
              "No Feedback Available",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.feedbacks.length,
                    itemBuilder: (BuildContext context, int index) {
                      var feedback = controller.feedbacks[index];
                      return Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                trailing: Text(
                                  feedback["Feedback_Time"].toString(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                title: Text(
                                  feedback["Name"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                subtitle: RatingBar.builder(
                                  ignoreGestures: true,
                                  initialRating:
                                  double.parse(feedback["Ratings"]),
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  itemSize: 25,
                                  itemCount: 5,
                                  allowHalfRating: true,
                                  itemBuilder: (context, _) =>
                                  const Icon(Icons.star, color: Colors.amber),
                                  onRatingUpdate: (value) {},
                                ),
                                leading: Image.network(
                                  feedback["Profile_Image"],
                                  height: mdheight * 0.5,
                                  width: mdwidth * 0.1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  feedback["Comment"],
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(thickness: 1),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: mdheight * 0.012),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
