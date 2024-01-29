import 'package:flutter/material.dart';
import 'package:rentify/Admin/Vehicle_Admin.dart';

class Admin_Add_Vehicle extends StatefulWidget {
  const Admin_Add_Vehicle({super.key});

  @override
  State<Admin_Add_Vehicle> createState() => _Admin_Add_VehicleState();
}

class _Admin_Add_VehicleState extends State<Admin_Add_Vehicle> {
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdhwidth = MediaQuery.sizeOf(context).width;
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
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.add_a_photo_outlined, size: 50,),
                splashColor: Colors.deepPurple.shade800,
              ),
              SizedBox(height: 40,),
              TextField(
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Enter Vehicle Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Enter Vehicle Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Enter Vehicle Type',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Enter Vehicle Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Enter Rent Price',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: 40,),
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
                              const Admin_VehiclePage()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(mdheight * 0.10),
                        )),
                    child: Text('Add Vehicle',
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
