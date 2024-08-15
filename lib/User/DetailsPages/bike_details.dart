import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rentify/User/BookingPages/select_date.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rentify/User/FeedbackPages/show_feedback.dart';

class BikeDetailController extends GetxController {
  final String bikeId;
  var isLoading = true.obs;
  var ratingList = <double>[].obs;
  var feedbacks = [].obs;
  var averageRating = 0.0.obs;

  BikeDetailController(this.bikeId);

  @override
  void onInit() {
    super.onInit();
    fetchFeedbacks();
  }

  Future<void> fetchFeedbacks() async {
    try {
      var feedbackSnapshot = await FirebaseFirestore.instance
          .collection('Feedbacks')
          .where('Vehicle_Id', isEqualTo: bikeId)
          .get();

      for (var doc in feedbackSnapshot.docs) {
        var data = doc.data();
        ratingList.add(double.parse(data['Ratings']));
        feedbacks.add(data);
      }
      calculateAverageRating();
      isLoading.value = false;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      isLoading.value = false;
    }
  }

  void calculateAverageRating() {
    if (ratingList.isEmpty) {
      averageRating.value = 0.0;
    } else {
      var sum = ratingList.reduce((a, b) => a + b);
      averageRating.value = sum / ratingList.length;
    }
  }
}

class BikeDetail extends StatefulWidget {
  final int index;
  final String bikeId;
  final String catName;
  final String name;
  final String type;
  final String description;
  final String price;
  final String image;

  const BikeDetail({
    Key? key,
    required this.index,
    required this.bikeId,
    required this.catName,
    required this.name,
    required this.type,
    required this.description,
    required this.price,
    required this.image,
  }) : super(key: key);

  @override
  _BikeDetailState createState() => _BikeDetailState();
}

class _BikeDetailState extends State<BikeDetail> {
  late final BikeDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(BikeDetailController(widget.bikeId));
  }

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.of(context).size.height;
    var mdwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bike Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: mdheight * 0.028,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Image.network(widget.image, height: mdheight * 0.3, width: mdwidth, fit: BoxFit.cover),
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: mdheight * 0.37),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade800,
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.035),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: mdheight * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: mdheight * 0.022),
                      Text(
                        widget.description,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 3,
                      ),
                      SizedBox(height: mdheight * 0.01),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: mdheight * 0.02),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Ratings & Reviews",
                                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white.withOpacity(0.90),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(mdheight * 0.02),
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.to(() => ShowFeedback(
                                          vehicleId: controller.bikeId,
                                        ));
                                      },
                                      child: const Text(
                                        'View All Review',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Obx(() => controller.feedbacks.isEmpty
                                    ? const RatingSummary(
                                  counter: 1,
                                  average: 0,
                                  averageStyle: TextStyle(color: Colors.white, fontSize: 30),
                                  counterFiveStars: 0,
                                  labelCounterFiveStarsStyle: TextStyle(color: Colors.white),
                                  counterFourStars: 0,
                                  labelCounterFourStarsStyle: TextStyle(color: Colors.white),
                                  counterThreeStars: 0,
                                  labelCounterThreeStarsStyle: TextStyle(color: Colors.white),
                                  counterTwoStars: 0,
                                  labelCounterTwoStarsStyle: TextStyle(color: Colors.white),
                                  counterOneStars: 0,
                                  labelCounterOneStarsStyle: TextStyle(color: Colors.white),
                                )
                                    : RatingSummary(
                                  counter: controller.feedbacks.length,
                                  average: controller.averageRating.value,
                                  averageStyle: const TextStyle(color: Colors.white, fontSize: 30),
                                  counterFiveStars: controller.feedbacks.where((f) => f['Ratings'] == '5.0').length,
                                  labelCounterFiveStarsStyle: const TextStyle(color: Colors.white),
                                  counterFourStars: controller.feedbacks.where((f) => f['Ratings'] == '4.0').length,
                                  labelCounterFourStarsStyle: const TextStyle(color: Colors.white),
                                  counterThreeStars: controller.feedbacks.where((f) => f['Ratings'] == '3.0').length,
                                  labelCounterThreeStarsStyle: const TextStyle(color: Colors.white),
                                  counterTwoStars: controller.feedbacks.where((f) => f['Ratings'] == '2.0').length,
                                  labelCounterTwoStarsStyle: const TextStyle(color: Colors.white),
                                  counterOneStars: controller.feedbacks.where((f) => f['Ratings'] == '1.0').length,
                                  labelCounterOneStarsStyle: const TextStyle(color: Colors.white),
                                )),
                              ],
                            ),
                          ),
                          SizedBox(height: mdheight * 0.02),
                          controller.feedbacks.isEmpty
                              ? const Column(
                            children: [
                              SizedBox(height: 42),
                              Center(child: Text("No Feedbacks", style: TextStyle(fontSize: 22, color: Colors.white))),
                              SizedBox(height: 42),
                            ],
                          )
                              : ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.feedbacks.length,
                              itemBuilder: (BuildContext context, int index) {
                                var feedback = controller.feedbacks[index];
                                return Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          title: Text(feedback['Name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                          subtitle: RatingBar.builder(
                                            ignoreGestures: true,
                                            unratedColor: Colors.white,
                                            initialRating: double.parse(feedback['Ratings']),
                                            minRating: 0,
                                            direction: Axis.horizontal,
                                            itemSize: 23,
                                            itemCount: 5,
                                            allowHalfRating: true,
                                            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                                            onRatingUpdate: (value) {},
                                          ),
                                          leading: Image.network(feedback['Profile_Image'], height: mdheight * 0.5, width: mdwidth * 0.1),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  feedback["Comment"],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                feedback["Feedback_Time"].toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(thickness: 1),
                                  ],
                                );
                              }),
                          SizedBox(height: mdheight * 0.012),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : Container(
        color: Colors.deepPurple.shade800,
        padding: const EdgeInsets.only(top: 10, left: 20, right: 15, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text( "₹${widget.price.toString()}/Day", style: TextStyle(fontSize: mdheight * 0.03, color: Colors.white)),
              ],
            ),
            SizedBox(
              height: mdheight * 0.07,
              width: mdwidth * 0.40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.9),
                ),
                onPressed: () {
                  Get.to(() => SelectDate(
                    avg: controller.averageRating.value.toString(),
                    vid: widget.bikeId.toString(),
                    image: widget.image,
                    name: widget.name,
                    price: widget.price,
                    catName: widget.catName,
                    type: widget.type.toString(),
                  ));
                },
                child: const Text(
                  "Book",
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
