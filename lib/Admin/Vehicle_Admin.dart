import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:rentify/Admin/Vehicle_Add_Admin.dart';
import 'package:http/http.dart' as http;
import 'package:rentify/Admin/update_Vehicle.dart';


// ignore: camel_case_types
class Admin_VehiclePage extends StatefulWidget {
  const Admin_VehiclePage({super.key});

  @override
  State<Admin_VehiclePage> createState() => _Admin_VehiclePageState();
}

// ignore: camel_case_types
class _Admin_VehiclePageState extends State<Admin_VehiclePage> {
  String? data;
  var getUser;
  bool isLoading=false;

  void initState(){
    super.initState();
    getdata();
  }
  Future getdata() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Vehicle_Admin.php"));
    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
      });
    }

  }
 // var name = ['Tesla', 'BMW', 'Ferrari', 'Ford', 'Honda', 'Toyota'];
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text('Vehicle List'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body : isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),) : ListView.builder(
          itemCount: getUser.length,
          itemBuilder: (BuildContext context, int index)
          {
            return Padding(padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.025, vertical: mdheight * 0.005),
                child: Card(
                  elevation: 5.0,
                  shadowColor: Colors.deepPurple.shade800,
                  semanticContainer: true,
                  surfaceTintColor: Colors.deepPurple.shade800,
                  child: Padding(
                    padding: EdgeInsets.all(mdheight * 0.017),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                            children :[
                              Expanded(
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text('Vehicle Id : '+getUser[index]["Vehicle_Id"]),
                                  SizedBox(height: mdheight * 0.01),
                                  Text('Vehicle Name : '+getUser[index]["Vehicle_Name"]),
                                  SizedBox(height: mdheight * 0.01),
                                   Text('Vehicle Type : '+getUser[index]["Vehicle_Type"]),
                                  SizedBox(height: mdheight * 0.01),
                                   Text('Vehicle Description : '+getUser[index]["Vehicle_Description"]),
                                  SizedBox(height: mdheight * 0.01),
                                   Text('Rent Price: '+getUser[index]["Rent_Price"]+'/day'),
                                  SizedBox(height: mdheight * 0.01),
                                   Text('Availability :'+getUser[index]["Availability"]),
                                  SizedBox(height: mdheight * 0.01),
                                ],
                              )),
                                  Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children:[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(getUser[index]["Vehicle_Image"],
                                        height: mdheight * 0.18,
                                        width: mdwidth*0.3,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ]
                              ),
                            ]
                        ),
                        SizedBox(height:  mdheight * 0.015,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MaterialButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const update_Vehicle()));
                            },
                                color: Colors.deepPurple.shade800,
                                padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                                ),
                                child: const Text('Edit Vehicle', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                )),
                            MaterialButton(onPressed: (){
                              CoolAlert.show(context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Do you Remove Vehicle',
                                  confirmBtnColor: Colors.red,
                                  animType: CoolAlertAnimType.slideInDown,
                                  backgroundColor: Colors.red,
                                  cancelBtnTextStyle: const TextStyle(
                                    color: Colors.black,
                                  ));
                            },
                                color: Colors.red,
                                padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                                ),

                                child: const Text('Delete Vehicle', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  Admin_Add_Vehicle()));
        },
        backgroundColor: Colors.deepPurple.shade800,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

