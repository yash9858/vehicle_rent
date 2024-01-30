import 'package:flutter/Material.Dart';
import 'package:rentify/Admin/Vehicle_Category_Admin.dart';

// ignore: camel_case_types
class Vehicle_Category_Details extends StatefulWidget {
  const Vehicle_Category_Details({super.key});

  @override
  State<Vehicle_Category_Details> createState() => _Vehicle_Category_DetailsState();
}

// ignore: camel_case_types
class _Vehicle_Category_DetailsState extends State<Vehicle_Category_Details> {
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text('Add Vehicle Category '),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
          children: [
            SizedBox(height: mdheight * 0.05,),
            IconButton(
              iconSize: 100,
              onPressed: (){},
              icon: const Icon(Icons.add_a_photo_outlined,),
              splashColor: Colors.deepPurple.shade800,
            ),
            SizedBox(height: mdheight * 0.05,),
            TextField(
              decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  hintText: 'Enter Vehicle Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  )
              ),
            ),
            SizedBox(height: mdheight * 0.05,),
            Container(
            height: MediaQuery.sizeOf(context).height * 0.050,
            width: MediaQuery.sizeOf(context).width * 0.70,
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(mdheight * 0.015),
          ),
          child:ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const Admin_CategoryPage()));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(mdheight * 0.02),
                  )),
              child: Text('Add Category',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: mdheight * 0.025,
                      fontWeight: FontWeight.bold)),
            )
            )],
        ),
      ),
    ),
    );
  }
}
