import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class Admin_Add_Vehicle extends StatefulWidget {
  const Admin_Add_Vehicle({super.key});

  @override
  State<Admin_Add_Vehicle> createState() => _Admin_Add_VehicleState();
}

// ignore: camel_case_types
class _Admin_Add_VehicleState extends State<Admin_Add_Vehicle> {
  TextEditingController NameController = TextEditingController();

  TextEditingController NumberController = TextEditingController();
  TextEditingController TypeController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController PriceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var logindata;
  var data;
  bool isLoading = false;
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
        title: const Text('Vehicle Details'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body:isLoading ? const Center(child: CircularProgressIndicator(color: Colors.black)) :SingleChildScrollView(
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
         onPressed: _submit,
          child: Text('Save Details',
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

Future<void> _submit() async {
  final form = _formKey.currentState;
  if (form!.validate()) {
    setState(() {
      isLoading = true;
    });
    final login_url = Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Insert_API/Vehicle.php");
    final response = await http
        .post(login_url, body: {
      "Vehicle_Name": NameController.text,
      "Vehicle_Number": NumberController.text,
      "Vehicle_Type": TypeController.text,
      "Vehicle_Description": DescriptionController.text,
      "Rent_Price": PriceController.text,
      //"Vehicle_Image": NameController.text,

      "Availability": "1",
      "Category_Id": "1",

    });
    if (response.statusCode == 200) {
      logindata = jsonDecode(response.body);
      data =
      jsonDecode(response.body)['user'];
      print(logindata);
      setState(() {
        isLoading = false;
      });
      if (logindata['error'] == false) {
        Fluttertoast.showToast(
            msg: logindata['message'].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2
        );

      }else{
        Fluttertoast.showToast(
            msg: logindata['message'].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2
        );
      }
    }
  }

}

}
