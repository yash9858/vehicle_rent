import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:rentify/User/Wait_Payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  final String v2id;
  final String price;
  final String startd;
  final String startt;
  final String returnd;
  final String returnt;
  final String starty;
  final String startm;
  final String returnm;
  final String returny;

  const PaymentPage({super.key ,required this.v2id,required this.price,
    required this.starty,
    required this.startm,
    required this.startd,
    required this.startt,
    required this.returnd,
    required this.returny,
    required this.returnm,
    required this.returnt
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  bool isLoading=true;
  dynamic data;
  dynamic data2;
  dynamic data3;
  dynamic getUser;
  dynamic getUser2;
  dynamic bid;
  dynamic bStat;
  dynamic totalPrice;

  @override
  void initState(){
    super.initState();
    booking();
    totalPrice = calculateTotalPrice(DateTime(int.parse(widget.starty),int.parse(widget.startm), int.parse(widget.startd)), double.parse(widget.startt),  DateTime(int.parse(widget.returny),int.parse(widget.returnm),int.parse(widget.returnd)), double.parse(widget.returnt));
  }

  double calculateTotalPrice(DateTime startDate, double startHour, DateTime endDate, double endHour) {
    double pricePerDate = double.parse(widget.price);
    int totalDays = endDate.difference(startDate).inDays;
    if (totalDays == 0 && endHour > startHour) {
      totalDays = 0;
    }
    double totalPrice = totalDays * pricePerDate;
    if (endHour > startHour) {
      totalPrice += (endHour - startHour) * (pricePerDate / 24);
    }
    return double.parse(totalPrice.toStringAsFixed(2));
  }

  Future booking() async{
    SharedPreferences share=await SharedPreferences.getInstance();
    http.Response response= await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/User_Fetch_API/Payment_Booking_Fetch.php"),
        body: {'Login_Id':share.getString('id')});
    if(response.statusCode==200) {
      data = response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
        bid = jsonDecode(data!)["users"][0]["Booking_Id"];
        payment();
      });
    }
  }

  Future payment() async{
    SharedPreferences share=await SharedPreferences.getInstance();
    http.Response response= await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Insert_API/Payment_Insert.php"),
        body: {
          'Payment_Mode': selectedOption,
          'Booking_Id': bid,
          'Total_Price': totalPrice.toStringAsFixed(2),
          'Login_Id':share.getString('id')});
    if(response.statusCode==200) {
      data2 = response.body;
      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data2!)["users"];
      });
    }
  }

  Future bStatus() async{
    http.Response response= await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Update_API/Booking_Status_Update_Payment.php"),
        body: {
          'Booking_Id': bid,});
    if(response.statusCode==200) {
      data3 = response.body;
      setState(() {
        isLoading=false;
        bStat=jsonDecode(data3!)["users"];
      });
      Get.to(()=> const WaitPay());
    }
  }

  dynamic selectedOption;
  dynamic total;
  dynamic x;

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Payment Methods",style: TextStyle(color: Colors.black,fontSize: mheight*0.030, fontWeight: FontWeight.bold),),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 15,right: 15,left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text('Total Price',style: TextStyle(fontSize: 17)),
                  trailing: Text("₹$totalPrice",style: const TextStyle(fontSize: 17)),
                ),
                SizedBox(height: mheight*0.02,),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Cash",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: mheight*0.01,),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: ListTile(
                    leading: Icon(Icons.money,color: Colors.deepPurple.shade400,),
                    title: const Text('cash',style: TextStyle(color: Colors.grey)),
                    trailing: Radio(
                      value: 'cash',
                      activeColor: Colors.deepPurple.shade400,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: mheight*0.02,),
            SizedBox(height: mheight*0.05,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("More Payment Options",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: mheight*0.01,),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    children: [
                      for (String option in [
                        'paypal',
                        'Google pay',
                        'Paytm'
                      ])
                        RadioListTile(
                          title: Text(option,style: const TextStyle(fontSize: 18,),),
                          value: option,
                          activeColor: Colors.deepPurple.shade400,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 5,left: 10,right: 10),
        width: double.infinity,
        height: mheight*0.08,
        child: ElevatedButton(
          onPressed: () {
            if (selectedOption != null) {
              payment();
              bStatus();
            }
            else
            {
              Fluttertoast.showToast(
                  msg: "Please select a payment method.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2
              );
            }
          },
          child: const Text("Confirm Payment",style: TextStyle(fontSize: 15),),
        ),
      ),
    );
  }
}