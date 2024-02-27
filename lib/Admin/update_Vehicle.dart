import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class update_Vehicle extends StatefulWidget {
  const update_Vehicle({super.key});

  @override
  State<update_Vehicle> createState() => _update_VehicleState();
}

// ignore: camel_case_types
class _update_VehicleState extends State<update_Vehicle> {

  TextEditingController NameController = TextEditingController();

  TextEditingController NumberController = TextEditingController();
  TextEditingController TypeController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController PriceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? data;
  var getUser;
  bool isLoading=false;

  void initState(){
    super.initState();
    getdata();
    getdata2();
  }

  Future getdata() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Vehicle_Admin.php"));
    if(response.statusCode==200){
      data=response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
      });
    }
  }

  Future getdata2() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Update_API/Vehicle_Update.php"));
    if(response.statusCode==200){
      data=response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
      });
    }
  }
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
        title: const Text(' Update Vehicle Details'),
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
              Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: NameController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter name";
                        }
                      },
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
                    TextFormField(
                      controller: NumberController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Number";
                        }
                      },
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
                    TextFormField(
                      controller: TypeController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Vehicle Type";
                        }
                      },
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
                    TextFormField(
                      controller: DescriptionController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Descripation";
                        }
                      },
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
                    TextFormField(
                      controller: PriceController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Price";
                        }
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Enter Rent Price',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                          )
                      ),
                    ),
                  ],)),

              SizedBox(height: mdheight * 0.04,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(mdheight * 0.02),
                  color: Colors.deepPurple.shade800,
                ),
                height: mdheight * 0.06,
                width: mdwidth * 0.7,
                child: MaterialButton(
                  onPressed: (){
                    getdata2();
                    Navigator.pop(context);
                  },
                  child: Text('Update Details',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: mdheight * 0.025,
                          fontWeight: FontWeight.bold)),
                ),
              )],
          ),
        ),
      ),
    );
  }
}
