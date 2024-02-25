// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
                  elevation: 5.0,
                  shadowColor: Colors.deepPurple.shade800,
                  semanticContainer: true,
                  surfaceTintColor: Colors.deepPurple.shade800,
                  child: Padding(
                    padding: EdgeInsets.all(mdheight * 0.017),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text('User name :'+getUser[index]['User_Name']),
                        SizedBox(height: mdheight * 0.01,),
                         Text('Booking Id :'+getUser[index]["Booking_Id"]),
                        SizedBox(height: mdheight * 0.01,),
                         Text('Vehicle Id : '),
                        SizedBox(height: mdheight * 0.01,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Payment Mode : '+getUser[index]["Payment_Mode"]),
                            Text(getUser[index]['Payment_Timestamp']),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.01,),
                        Text('Total Price : '+getUser[index]["Total_Price"]),
                        SizedBox(height: mdheight * 0.01,),
                         Text('Payment Status : '+getUser[index]["Payment_Status"]),
                        SizedBox(height: mdheight * 0.01,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(onPressed: (){
                            showDialog(context: context, builder: (context)
                            {
                              return Dialog(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.03),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: mdheight * 0.02),
                                          Padding(
                                            padding: EdgeInsets.only(left : mdwidth * 0.05, right: mdwidth * 0.01,),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children :[
                                                const Text('Cancel Id: 1'),
                                                SizedBox(height: mdheight * 0.01),
                                                const Text('Vehicle Id : 1'),
                                                SizedBox(height: mdheight * 0.01),
                                                const Text('Vehicle Name : Tesla'),
                                                SizedBox(height: mdheight * 0.01),
                                                const Text('Vehicle Type : Car'),
                                                SizedBox(height: mdheight * 0.01),
                                                const Text('Vehicle Description : This Is Fully Automated Car'),
                                                SizedBox(height: mdheight * 0.01),
                                                const Text('Rent Price: 500/day'),
                                                SizedBox(height: mdheight * 0.01),
                                                const Text('Availability : True'),
                                                SizedBox(height: mdheight * 0.01),
                                              ],
                                            ),
                                          ),
                                          MaterialButton(onPressed: (){
                                                Navigator.pop(context);
                                            },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.02)),
                                              ),
                                              color: Colors.deepPurple.shade800,
                                              elevation: 5.0,
                                              child: const Text('Refund', style: TextStyle(color: Colors.white,),)),
                                          SizedBox(height: mdheight * 0.01),
                                        ]
                                    ),
                                  ));
                          });
                          },
                              color: Colors.deepPurple.shade800,
                              padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.02)),
                              ),
                              child: const Text('Proceed Refund', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              )),
                        ],
                      ),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}
