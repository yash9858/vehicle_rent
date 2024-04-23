// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// ignore: camel_case_types
class Admin_PaymentPage extends StatefulWidget {
  const Admin_PaymentPage({super.key});

  @override
  State<Admin_PaymentPage> createState() => _Admin_PaymentPageState();
}

// ignore: camel_case_types
class _Admin_PaymentPageState extends State<Admin_PaymentPage> {
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
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Payment_Admin.php"));
    if(response.statusCode==200){
      data=response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
      });
    }
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
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
    title: const Text('Payment List'),
    backgroundColor: Colors.deepPurple.shade800,
    iconTheme: const IconThemeData(
    color: Colors.white,
    ),
          centerTitle: true,
    ),
      body:  isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),) :ListView.builder(
          itemCount: getUser.length,
          itemBuilder: (BuildContext context, int index)
          {
            return Padding(padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.025, vertical: mdheight * 0.005),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(mdheight * 0.01),
                  shadowColor: Colors.deepPurple.shade800,
                  surfaceTintColor: Colors.deepPurple.shade800,
                  child: Padding(
                    padding: EdgeInsets.all(mdheight * 0.017),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text('User name : '+getUser[index]['Name']),
                        SizedBox(height: mdheight * 0.01,),
                         Text('Booking Id :'+getUser[index]["Booking_Id"]),
                        SizedBox(height: mdheight * 0.01,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Payment Mode : '+getUser[index]["Payment_Mode"]),
                            Text(formatDate(getUser[index]['Payment_Timestamp'])),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.01,),
                        Text('Total Price : '+getUser[index]["Total_Price"]),
                        SizedBox(height: mdheight * 0.01,),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}
