import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AdminPaymentPage extends StatefulWidget {
  const AdminPaymentPage({super.key});

  @override
  State<AdminPaymentPage> createState() => _AdminPaymentPageState();
}

class _AdminPaymentPageState extends State<AdminPaymentPage> {
  String? data;
  dynamic getUser;
  bool isLoading=false;

  @override
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
      body:  isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),) :ListView.builder(
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
                        Row(
                          children: [
                            const Text('User name : '),
                            Text(getUser[index]['Name']),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.01,),
                        Row(
                          children: [
                            const Text('Booking Id :'),
                            Text(getUser[index]["Booking_Id"]),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.01,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('Payment Mode : '),
                                Text(getUser[index]["Payment_Mode"]),
                              ],
                            ),
                            Text(formatDate(getUser[index]['Payment_Timestamp'])),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.01,),
                        Row(
                          children: [
                            const Text('Total Price : '),
                            Text(getUser[index]["Total_Price"]),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.01,),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}
