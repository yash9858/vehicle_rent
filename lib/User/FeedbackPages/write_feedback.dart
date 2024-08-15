import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackController extends GetxController {
  var isLoading = true.obs;
  var feedbackList = <Map<String, dynamic>>[].obs;
  var rating = 1.0.obs;
  dynamic feedbackId;

  Future<void> fetchFeedback(String vehicleId) async {
    try {
      isLoading(true);
      QuerySnapshot feedbackSnapshot = await FirebaseFirestore.instance.collection('Feedbacks')
          .where('Vehicle_Id', isEqualTo: vehicleId).get();

      feedbackList.value = feedbackSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }
    catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load feedback: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    } finally {
      isLoading(false);
    }
  }


  Future<void> submitFeedback(String vehicleId, String comment) async {
    try {
      if (comment.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "Comment cannot be empty",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
        );
        return;
      }

      isLoading(true);
      final User? currentUser = FirebaseAuth.instance.currentUser;
      var counterRef = FirebaseFirestore.instance.collection('Counter').doc('FeedbackCounter');
      var counterSnapshot = await counterRef.get();

      if (counterSnapshot.exists) {
        feedbackId = counterSnapshot.data()?['latestId'] + 1;
      } else {
        feedbackId = 1;
      }

      await counterRef.set({'latestId': feedbackId});

      if (currentUser == null) {
        Fluttertoast.showToast(
          msg: "User not logged in.",
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

      var response = await FirebaseFirestore.instance.collection('Users').doc(currentUser.email).get();
      DateTime now = DateTime.now();
      String formattedDate = formatDateTime(now);

      await FirebaseFirestore.instance.collection('Feedbacks').doc(feedbackId.toString()).set({
        'Login_Id': currentUser.email,
        'Vehicle_Id': vehicleId,
        'Ratings': rating.value.toString(),
        'Comment': comment,
        'Name': response["Name"] ?? 'Anonymous',
        'Profile_Image': response["Profile_Image"] ?? '',
        'Feedback_Time': formattedDate,
      });

      Fluttertoast.showToast(
        msg: "Feedback submitted successfully.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );

      fetchFeedback(vehicleId);
      Get.back();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to submit feedback: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    } finally {
      isLoading(false);
    }
  }

}

class FeedBackUser extends StatelessWidget {
  final int num;
  final String vid;
  final FeedbackController controller = Get.put(FeedbackController());

  FeedBackUser({super.key, required this.num, required this.vid});

  @override
  Widget build(BuildContext context) {
    controller.fetchFeedback(vid);

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
      body: Obx(
            () => controller.isLoading.value
            ? const Center(
          child: CircularProgressIndicator(color: Colors.deepPurple),
        )
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.feedbackList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var feedback = controller.feedbackList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          trailing: Text(
                            feedback["Feedback_Time"],
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
                            initialRating: double.parse(feedback["Ratings"]),
                            minRating: 0,
                            direction: Axis.horizontal,
                            itemSize: 25,
                            itemCount: 5,
                            allowHalfRating: true,
                            itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                            onRatingUpdate: (value) {},
                          ),
                          leading: feedback["Profile_Image"] != ''
                              ? Image.network(
                            feedback["Profile_Image"],
                            height: mdheight * 0.5,
                            width: mdwidth * 0.1,
                          )
                              : const Icon(Icons.person),
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
                        const Divider(thickness: 1),
                      ],
                    );
                  },
                ),
                SizedBox(height: mdheight * 0.012),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          height: mdheight * 0.07,
          width: mdwidth * 0.50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade800, // Background color
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Review(vid: vid),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Text("Write Review", style: TextStyle(fontSize: 17)),
          ),
        ),
      ),
    );
  }
}


class Review extends StatelessWidget {
  final String vid;
  final FeedbackController controller = Get.find();

  Review({super.key, required this.vid});

  final TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rating & Review",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        const SizedBox(height: 5),
        Obx(() => Text("Rating(${controller.rating}/5.0)")),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.topLeft,
          child: RatingBar.builder(
            initialRating: 1,
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (value) {
              controller.rating.value = value;
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text("Write your Review"),
        const SizedBox(height: 5),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: commentController,
            validator: (val) {
              if (val!.isEmpty) {
                return "Type your Feedback here";
              }
              return null;
            },
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            cursorColor: Colors.deepPurple.shade800,
            decoration: InputDecoration(
              fillColor: Colors.grey.shade100,
              filled: true,
              hintText: "Enter Your Review",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple.shade800),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  controller.submitFeedback(vid, commentController.text);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ],
    );
  }
}
