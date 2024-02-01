import 'package:flutter/material.dart';

// ignore: camel_case_types
class Admin_Add_Vehicle extends StatefulWidget {
  const Admin_Add_Vehicle({super.key});

  @override
  State<Admin_Add_Vehicle> createState() => _Admin_Add_VehicleState();
}

// ignore: camel_case_types
class _Admin_Add_VehicleState extends State<Admin_Add_Vehicle> {
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text('Vehicle Details'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(mdheight * 0.02),
          child: Column(
            children: [
              Center(
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(
                            "assets/img/Logo.jpg"),
                      ),
                      Positioned(
                        left: 80,
                        bottom: 1,
                        child: CircleAvatar(

                          child: IconButton(
                              onPressed: (){

                              },
                              icon:const Icon(Icons.edit)),
                        ),
                      )
                    ],
                  )),
              SizedBox(height: mdheight * 0.04),
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
              SizedBox(height: mdheight * 0.025,),
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
              SizedBox(height: mdheight * 0.025,),
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
              SizedBox(height: mdheight * 0.025,),
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
              SizedBox(height: mdheight * 0.025,),
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
              SizedBox(height: mdheight * 0.04,),
              Container(
                  height: MediaQuery.sizeOf(context).height * 0.050,
                  width: MediaQuery.sizeOf(context).width * 0.70,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(mdheight * 0.015),
                  ),
                  child:ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(mdheight * 0.02),
                        )),
                    child: Text('Save Details',
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
