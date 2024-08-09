import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rentify/Admin/vehicle_add_admin.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool isLoading = false;
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<void> getdata() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Categories').get();
      categories = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      e.toString();
      Fluttertoast.showToast(msg: "Failed to load categories");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade800,
        title: Text(
          "Select Category",
          style: TextStyle(
            color: Colors.white,
            fontSize: mheight * 0.025,
          ),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : Container(
        padding: const EdgeInsets.only(top: 20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 5,
            crossAxisCount: 3,
            crossAxisSpacing: 5,
          ),
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Get.to(() => AdminAddVehicle(
                  name: categories[index]["Cat_Name"],
                ));
              },
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        categories[index]["Cat_Image"],
                        fit: BoxFit.cover,
                        height: mwidth * 0.17,
                      ),
                    ),
                  ),
                  Text(
                    categories[index]["Cat_Name"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
