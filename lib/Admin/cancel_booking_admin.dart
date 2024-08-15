import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CancelBookings extends StatefulWidget {
  const CancelBookings({super.key});

  @override
  State<CancelBookings> createState() => _CancelBookingsState();
}

class _CancelBookingsState extends State<CancelBookings>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxBool isLoading = true.obs;
  final RxList<Map<String, dynamic>> cancelList = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> refundList = <Map<String, dynamic>>[].obs;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        getData();
      }
    });
    getData();
  }

  Future<void> getData() async {
    isLoading(true);
    try {

      QuerySnapshot cancelSnapshot = await _firestore.collection('Bookings')
          .where('Booking_Status', isEqualTo: 'Refund').get();
      cancelList.value = await Future.wait(cancelSnapshot.docs.map((doc) async {
        var data = doc.data() as Map<String, dynamic>;
        var userDoc = await _firestore.collection('Users')
            .doc(data['Login_Id']).get();
        data['Name'] = userDoc.data()?['Name'];
        return data;
      }).toList());

      QuerySnapshot refundSnapshot = await _firestore.collection('Bookings')
          .where('Booking_Status', isEqualTo: 'Pending Refund').get();

      refundList.value = await Future.wait(refundSnapshot.docs.map((doc) async {
        var data = doc.data() as Map<String, dynamic>;
        var userDoc = await _firestore
            .collection('Users')
            .doc(data['Login_Id'])
            .get();
        data['Name'] = userDoc.data()?['Name'];
        return data;
      }).toList());
    }
    catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cancel bookings"),
          centerTitle: true,
          backgroundColor: Colors.deepPurple.shade800,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            tabs: const [
              Tab(text: 'Cancel List'),
              Tab(text: 'Refund List'),
            ],
          ),
        ),
        body: Obx(() => isLoading.value
            ? const Center(
          child: CircularProgressIndicator(color: Colors.deepPurple),
        )
            : TabBarView(
          controller: _tabController,
          children: [
            cancelList.isEmpty
                ? const Center(child: Text("No Cancel Data"))
                : _buildListView(cancelList, mdheight, mdwidth),
            refundList.isEmpty
                ? const Center(child: Text("No Data found"))
                : _buildRefundListView(refundList, mdheight, mdwidth),
          ],
        )),
      ),
    );
  }

  Widget _buildListView(
      RxList<Map<String, dynamic>> list, double mdheight, double mdwidth) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(mdheight * 0.017),
          shadowColor: Colors.deepPurple.shade800,
          surfaceTintColor: Colors.deepPurple.shade800,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text("${index + 1}. ",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(list[index]['Name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 16),
                _buildRow(
                    "Booking Id : ", list[index]["Booking_Id"].toString()),
                const SizedBox(height: 10),
                _buildRow("Reason : ", list[index]["Cancellation_Reason"]),
                const SizedBox(height: 10),
                _buildRow("Cancelation Date & Time : ",
                    list[index]["Cancellation_Time"].toString()),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRefundListView(
      RxList<Map<String, dynamic>> list, double mdheight, double mdwidth) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        var book = list[index];
        return Card(
          elevation: 5,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(mdheight * 0.017),
          shadowColor: Colors.deepPurple.shade800,
          surfaceTintColor: Colors.deepPurple.shade800,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text("${index + 1}. ",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(book["Name"],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 16),
                _buildRow("Booking Id : ", book["Booking_Id"].toString()),
                const SizedBox(height: 10),
                _buildRow("Reason : ", book["Cancellation_Reason"]),
                const SizedBox(height: 10),
                _buildRow("Cancelation Date & Time : ",
                    book["Cancellation_Time"].toString()),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        _showRefundDialog(context, list[index], mdheight, mdwidth);
                      },
                      color: Colors.deepPurple.shade800,
                      padding: EdgeInsets.symmetric(
                          horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(mdheight * 0.02)),
                      ),
                      child: const Text('Proceed Refund',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }

  void _showRefundDialog(BuildContext context, Map<String, dynamic> booking,
      double mdheight, double mdwidth) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.03),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: mdheight * 0.02),
                Padding(
                  padding:
                  EdgeInsets.only(left: mdwidth * 0.05, right: mdwidth * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRow(
                          'Booking Id : ', booking["Booking_Id"].toString()),
                      SizedBox(height: mdheight * 0.01),
                      SizedBox(height: mdheight * 0.01),
                      _buildRow('Cancle Id : ', booking["Cancle_Id"].toString()),
                      SizedBox(height: mdheight * 0.01),
                      _buildRow('Refund Amount : ', booking["Refund_Amount"]),
                      SizedBox(height: mdheight * 0.01),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    _submitRefund(booking["Booking_Id"].toString()).then((_) {
                      Get.back();
                      getData();
                      _tabController.animateTo(1); // Switch back to Refund List tab
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(mdheight * 0.02)),
                  ),
                  color: Colors.deepPurple.shade800,
                  elevation: 5.0,
                  child: const Text('Refund',
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: mdheight * 0.01),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitRefund(String cancelId) async {
    isLoading(true);
    try {
      await _firestore.collection('Bookings').doc(cancelId).update({
        "Booking_Status": "Refund",
      });
      Fluttertoast.showToast(
          msg: "Refund processed successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2);
    }
    catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
    finally {
      isLoading(false);
    }
  }
}
