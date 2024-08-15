import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rentify/User/DetailsPages/bike_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bike extends StatefulWidget {
  const Bike({super.key});

  @override
  State<Bike> createState() => _BikeState();
}

class _BikeState extends State<Bike> {
  bool isLoading = true;
  List<Map<String, dynamic>> bikes = [];

  @override
  void initState() {
    super.initState();
    fetchBikeData();
  }

  Future<void> fetchBikeData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Vehicles')
          .where('Vehicle_Type', isEqualTo: 'Bike')
          .get();

      bikes = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['Vehicle_Id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load cars");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void addToFavorites(String bikeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');

    try {
      await FirebaseFirestore.instance.collection('Favorites').add({
        'Login_Id': userId,
        'Vehicle_Id': bikeId,
      });
      Fluttertoast.showToast(msg: "Added to favorites");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to add to favorites");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Available Bikes",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: mheight * 0.030,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: mheight * 0.3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: bikes.length,
          itemBuilder: (context, int index) {
            var bike = bikes[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => BikeDetail(
                  index: index,
                  bikeId: bike["Vehicle_Id"].toString(),
                  catName: bike["Cat_Name"],
                  name: bike["Vehicle_Name"],
                  type: bike["Vehicle_Type"],
                  description : bike["Vehicle_Description"],
                  price: bike["Rent_Price"].toString(),
                  image: bike["Vehicle_Image"],
                ));
              },
              child: Card(
                borderOnForeground: true,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7, top: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              bike["Cat_Name"],
                              style: const TextStyle(color: Colors.blueGrey),
                            ),
                          ),
                          const Icon(Icons.info_outline, color: Colors.blueGrey),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        bike["Vehicle_Image"],
                        fit: BoxFit.cover,
                        height: mheight * 0.16,
                        width: mwidth * 0.5,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 2, right: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              bike["Vehicle_Name"],
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text("₹"),
                                    Text(
                                      "${bike["Rent_Price"]}/ Day",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
