import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:rentify/Admin/booking_admin.dart';
import 'package:rentify/Admin/cancel_booking_admin.dart';
import 'package:rentify/Admin/complain_admin.dart';
import 'package:rentify/Admin/feedback_admin.dart';
import 'package:rentify/Admin/payment_admin.dart';
import 'package:rentify/Admin/report_generate.dart';
import 'package:rentify/Admin/user_list_admin.dart';
import 'package:rentify/Admin/vehicle_admin.dart';
import 'package:rentify/Admin/vehicle_category_admin.dart';
import 'package:rentify/AuthPages/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxInt userCount = 0.obs;
  RxInt categoryCount = 0.obs;
  RxInt vehicleCount = 0.obs;
  RxInt bookingCount = 0.obs;
  RxInt paymentCount = 0.obs;
  RxInt complainCount = 0.obs;
  RxInt feedbackCount = 0.obs;
  RxBool isLoading = true.obs;
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCounts();
  }

  Future<void> fetchCounts() async {
    try {
      isLoading.value = true;

      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore.collection('Counter').doc('UserCounter').get();
      DocumentSnapshot<Map<String, dynamic>> catDoc = await _firestore.collection('Counter').doc('CatCounter').get();
      DocumentSnapshot<Map<String, dynamic>> cancleDoc = await _firestore.collection('Counter').doc('CancleCounter').get();
      DocumentSnapshot<Map<String, dynamic>> feedDoc = await _firestore.collection('Counter').doc('FeedbackCounter').get();
      DocumentSnapshot<Map<String, dynamic>> payDoc = await _firestore.collection('Counter').doc('paymentCounter').get();
      DocumentSnapshot<Map<String, dynamic>> complainDoc = await _firestore.collection('Counter').doc('ComplainCounter').get();
      DocumentSnapshot<Map<String, dynamic>> vehicleDoc = await _firestore.collection('Counter').doc('VehicleCounter').get();

        final user = userDoc.data();
        final cat = catDoc.data();
        final feed = feedDoc.data();
        final pay = payDoc.data();
        final complain = complainDoc.data();
        final vehicle = vehicleDoc.data();
        final cancle  = cancleDoc.data();

        userCount.value = user?['latestId'];
        categoryCount.value = cat?['latestId'];
        bookingCount.value = pay?['latestId'] - cancle?['latestId'];
        feedbackCount.value = feed?['latestId'];
        paymentCount.value = pay?['latestId'];
        complainCount.value = complain?['latestId'];
        vehicleCount.value = vehicle?['latestId'];
    }
    catch (e) {
      Fluttertoast.showToast(
          msg: "Failed To Fetch Count",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    }
    finally {
      isLoading.value = false;
    }
  }
}


class DrawerNavigationItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final bool selected;
  final Function() onTap;

  const DrawerNavigationItem({
    Key? key,
    required this.iconData,
    required this.title,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      leading: Icon(iconData),
      onTap: onTap,
      title: Text(title),
      selectedTileColor: Colors.white,
      selected: selected,
      selectedColor: Colors.black,
      textColor: Colors.white,
      iconColor: Colors.white,
    );
  }
}

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text(
      "Hello Admin !",
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    ),
    );
  }
}

class AdminDashBoard extends StatelessWidget {
  final AdminDashboardController _controller = Get.put(AdminDashboardController());
  AdminDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    var pageName = ['Total Users', 'Total Categories', 'Total Vehicles', 'Success Bookings', 'Total Payments', 'Total Complains', 'Total Feedbacks'];
    var page = [AdminUserPage(), AdminCategoryPage(), AdminVehiclePage(), AdminBookingPage(), const AdminPaymentPage(), AdminComplainPage(), const AdminFeedbackPage()];
    var image = ['assets/img/user.json', 'assets/img/category.json', 'assets/img/vehicle.json', 'assets/img/bookings.json', 'assets/img/payments.json', 'assets/img/complain.json', 'assets/img/feedback.json'];

    var mdheight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.deepPurple.shade800,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(mdheight * 0.015),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: mdheight * 0.02,
                ),
                const DrawerHeader(),
                SizedBox(
                  height: mdheight * 0.02,
                ),
                DrawerNavigationItem(
                  iconData:  Icons.home_rounded,
                  title: "Admin DashBoard",
                  selected: _controller.currentIndex == 0.obs,
                  onTap: () =>
                  {
                    Get.to(()=> AdminDashBoard())
                  },
                ),
                DrawerNavigationItem(
                  iconData:Icons.account_circle_rounded,
                  title: "Manage User",
                  selected: _controller.currentIndex == 1.obs,
                  onTap: () =>
                  {
                    _controller.currentIndex == 1.obs,
                    Get.to(()=> AdminUserPage())
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.list,
                  title: "Manage Category",
                  selected: _controller.currentIndex == 2.obs,
                  onTap: () =>
                  {
                    Get.to(()=> AdminCategoryPage()),
                    _controller.currentIndex == 2.obs,
                  },
                ),
                DrawerNavigationItem(
                  iconData:LineIcons.car,
                  title: "Manage Vehicle",
                  selected: _controller.currentIndex == 3.obs,
                  onTap: () =>
                  {
                    Get.to(()=> AdminVehiclePage()),
                    _controller.currentIndex == 3.obs,
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.date_range_sharp,
                  title: "Manage Bookings",
                  selected: _controller.currentIndex == 4.obs,
                  onTap: () =>
                  {
                    Get.to(()=> AdminBookingPage()),
                    _controller.currentIndex == 4.obs,
                  },
                ),
                DrawerNavigationItem(
                  iconData:Icons.paid_rounded,
                  title: "Manage Payments",
                  selected: _controller.currentIndex == 5.obs,
                  onTap: () =>
                  {
                    Get.to(()=> const AdminPaymentPage()),
                    _controller.currentIndex == 5.obs,
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.free_cancellation_outlined,
                  title: "Cancel Bookings",
                  selected: _controller.currentIndex == 6.obs,
                  onTap: () =>
                  {
                    Get.to(()=> const CancelBookings()),
                    _controller.currentIndex == 6.obs,
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.forum,
                  title: "Manage Complains",
                  selected: _controller.currentIndex == 7.obs,
                  onTap: () =>
                  {
                    Get.to(()=> AdminComplainPage()),
                    _controller.currentIndex == 7.obs,
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.feedback_rounded,
                  title: "Manage Feedbacks",
                  selected: _controller.currentIndex == 8.obs,
                  onTap: () =>
                  {
                    Get.to(()=> const AdminFeedbackPage()),
                    _controller.currentIndex == 8.obs,
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.picture_as_pdf_rounded,
                  title: "Generate Report",
                  selected:_controller.currentIndex == 9.obs,
                  onTap: () =>
                  {
                    //Get.to(()=> const ReportAdmin()),
                    _controller.currentIndex == 9.obs,
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.logout_outlined,
                  title: "Log Out",
                  selected:_controller.currentIndex == 10.obs,
                  onTap: () async
                  {
                    final pref = await SharedPreferences.getInstance();
                    await pref.clear();
                    await pref.setBool('seen', true);

                    Get.offAll(()=> LoginPage());
                    _controller.currentIndex == 10.obs;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        leading: Builder(
            builder: (context){
              return IconButton(icon: const Icon(Icons.sort),
                  onPressed: () => Scaffold.of(context).openDrawer());
            }),
        title: const Text('Admin DashBoard'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme:  const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return _controller.isLoading.value
            ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
            : RefreshIndicator(
            onRefresh: () async {
              await _controller.fetchCounts();
            },
            child: Padding(
            padding: EdgeInsets.all(mdheight * 0.01),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: mdheight * 0.015,
                mainAxisSpacing: mdheight * 0.015,
              ),
              itemCount: pageName.length,
              itemBuilder: (context, int index) {
                return InkWell(
                    onTap: () {
                      Get.to(() => page[index]);
                    },
                    child: Expanded(
                      child: Card(
                        elevation: 12.0,
                        color: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(mdheight * 0.020),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: mdheight * 0.13,
                              child: Lottie.asset(image[index]),
                            ),
                            SizedBox(height: mdheight * 0.015),
                            Expanded(
                              child:Text(
                                pageName[index],
                                style: TextStyle(fontSize: mdheight * 0.022),
                              ),
                            ),
                            Text(
                              [
                                _controller.userCount.value.toString(),
                                _controller.categoryCount.value.toString(),
                                _controller.vehicleCount.value.toString(),
                                _controller.bookingCount.value.toString(),
                                _controller.paymentCount.value.toString(),
                                _controller.complainCount.value.toString(),
                                _controller.feedbackCount.value.toString()
                              ][index],
                              style: const TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: mdheight * 0.01),
                          ],
                        ),
                      )
                    ),
                );
              },
            ),
          ));
        }
      ),
    );
  }
}
