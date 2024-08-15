import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentify/User/CategoriesPages/search_page.dart';
import 'package:rentify/User/DetailsPages/bike_details.dart';
import 'package:rentify/User/DetailsPages/car_details.dart';
import 'package:rentify/User/CategoriesPages/category.dart';
import 'package:rentify/User/CategoriesPages/category_vehicle_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var categories = [].obs;
  List<Map<String, dynamic>> cars = [];
  List<Map<String, dynamic>> bikes = [];
  var newArrivals = [].obs;
  var username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await fetchCategories();
      await fetchCars();
      await fetchBikes();
      await fetchUsername();
      await fetchNewArrivals();
      isLoading.value = false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed To Fetching Data:",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    }
  }

  Future<void> fetchCategories() async {
    var snapshot = await FirebaseFirestore.instance.collection('Categories')
        .get();
    categories.assignAll(snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> fetchCars() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Vehicles')
          .where('Vehicle_Type', isEqualTo: 'Car').get();

      cars = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['Vehicle_Id'] = doc.id;
        return data;
      }).toList();
    }
    catch (e) {
      Fluttertoast.showToast(
        msg: "Failed To Fetching Cars Data",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    }
    finally {
      isLoading(false);
    }
  }

  Future<void> fetchBikes() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Vehicles')
          .where('Vehicle_Type', isEqualTo: 'Bike').get();

      bikes = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['Vehicle_Id'] = doc.id;
        return data;
      }).toList();
    }
    catch (e) {
      Fluttertoast.showToast(
        msg: "Failed To Fetching Bike Data",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    }
    finally {
      isLoading(false);
    }
  }

  Future<void> fetchNewArrivals() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Vehicles')
          .orderBy('Vehicle_Id', descending: false)
          .limit(3).get();

      newArrivals.assignAll(querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['Vehicle_Id'] = doc.id;
        return data;
      }).toList());
    }
    catch (e) {
      Fluttertoast.showToast(
        msg: "Failed To Fetching New Arrive Data",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    }
  }

  Future<void> fetchUsername() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        var response = await FirebaseFirestore.instance.collection('Users')
            .doc(currentUser.email).get();

        if (response.exists && response.data() != null) {
          username.value =
              response.data()?["Name"]?.toString() ?? "Unknown User";
        } else {
          Fluttertoast.showToast(
            msg: "User Document Does Not Exist Or Is Empty",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Failed To Fetch Username",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
        );
      }
      finally {
        isLoading(false);
      }
    }
    else {
      Fluttertoast.showToast(
        msg: "No Current User Found",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
      isLoading(false);
    }
  }
}


  class Homescreen extends StatelessWidget {
  Homescreen({super.key});
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade800,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              "Hy,",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
            ),
            const SizedBox(width: 5),
            Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator(color: Colors.transparent))
                : Text(
              controller.username.value.capitalize.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
            )),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Obx(() => CircleAvatar(
              backgroundColor: Colors.black,
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.transparent)
                  : Text(controller.username.value.isNotEmpty
                    ? controller.username.value.characters.first.capitalize!
                    : "",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )),
          ),
        ],

      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: mheight * 0.01),
              SearchBar(
                onTap: () {
                  Get.to(() => SearchPage());
                },
                shape: WidgetStateProperty.all(
                  const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                leading: const Icon(Icons.search,color: Colors.black,),
                hintText: "Find your vehicle",
                hintStyle: WidgetStateProperty.all(
                  const TextStyle(color: Colors.grey),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Category",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => Category());
                    },
                    child: const Text(
                      "View all",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: mheight * 0.12,
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 1,
                  ),
                  itemCount: controller.categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    var category = controller.categories[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => CategoryVehicleUser(
                          name: category["Cat_Name"],
                          val: index.toString(),
                        ));
                      },
                      child: Column(
                        children: [
                          Card(
                            elevation: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                category["Cat_Image"],
                                fit: BoxFit.cover,
                                height: mwidth * 0.14,
                              ),
                            ),
                          ),
                          Text(
                            category["Cat_Name"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: mheight * 0.01),
              Container(
                padding: const EdgeInsets.only(left: 5, right: 5),
                width: double.infinity,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Arrives",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: mheight * 0.01),
              SizedBox(
                height: mheight * 0.35,
                child: PageView.builder(
                  itemCount: controller.newArrivals.length,
                  itemBuilder: (BuildContext context, int index) {
                    var arrival = controller.newArrivals[index];
                    return GestureDetector(
                      onTap: () {
                        if (arrival["Vehicle_Type"] == "Car") {
                          Get.to(() => CarDetails(
                            index: index,
                            carId: arrival["Vehicle_Id"].toString(),
                            catName: arrival["Cat_Name"],
                            name: arrival["Vehicle_Name"],
                            type: arrival["Vehicle_Type"],
                            description: arrival["Vehicle_Description"],
                            price: arrival["Rent_Price"].toString(),
                            image: arrival["Vehicle_Image"],
                          ));
                        }
                        else if (arrival["Vehicle_Type"] == "Bike") {
                          Get.to(() => BikeDetail(
                            index: index,
                            bikeId: arrival["Vehicle_Id"].toString(),
                            catName: arrival["Cat_Name"],
                            name: arrival["Vehicle_Name"],
                            type: arrival["Vehicle_Type"],
                            description: arrival["Vehicle_Description"],
                            price: arrival["Rent_Price"].toString(),
                            image: arrival["Vehicle_Image"],
                          ));
                        }
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        arrival["Vehicle_Name"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5, right: 5),
                                      child: Text(
                                        arrival["Cat_Name"],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(2),
                                width: double.infinity,
                                height: mheight * 0.22,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    arrival["Vehicle_Image"],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(height: mheight * 0.01,),
                              Text(
                                "₹ ${arrival["Rent_Price"].toString()}/ Day",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: mheight * 0.01),
              _buildSectionTitle("Cars"),
              SizedBox(height: mheight * 0.01),
              _buildHorizontalList(controller.cars, mheight,"Car"),
              SizedBox(height: mheight * 0.01),
              _buildSectionTitle("Bikes"),
              SizedBox(height: mheight * 0.01),
              _buildHorizontalList(controller.bikes, mheight,"Bike"),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<dynamic> items, double mheight, String type) {
    return SizedBox(
      height: mheight * 0.31,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          var item = items[index];
          return GestureDetector(
            onTap: () {
              Get.to(() => type == "Car"
                  ? CarDetails(
                index: index,
                carId: item["Vehicle_Id"].toString(),
                catName: item["Cat_Name"],
                name: item["Vehicle_Name"],
                type: item["Vehicle_Type"],
                description: item["Vehicle_Description"],
                price: item["Rent_Price"].toString(),
                image: item["Vehicle_Image"],
              ) : BikeDetail(
                index: index,
                bikeId: item["Vehicle_Id"].toString(),
                catName: item["Cat_Name"],
                name: item["Vehicle_Name"],
                type: item["Vehicle_Type"],
                description : item["Vehicle_Description"],
                price: item["Rent_Price"].toString(),
                image: item["Vehicle_Image"],
              ));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              item["Cat_Name"],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        item["Vehicle_Image"],
                        height: mheight * 0.15,
                        width: mheight * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: mheight * 0.01),
                    Text(
                      item["Vehicle_Name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "₹ ${item["Rent_Price"].toString()}/ Day",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
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
}