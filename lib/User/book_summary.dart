import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rentify/User/cancel_booking.dart';
import 'package:rentify/User/complain.dart';
import 'package:rentify/User/write_feedback.dart';
import 'package:http/http.dart' as http;

class BookSummary extends StatefulWidget {
  final int val3;
  final String bid;
  final String vid;
  const BookSummary({super.key,required this.val3, required this.bid, required this.vid});

  @override
  State<BookSummary> createState() => _BookSummaryState();
}


class _BookSummaryState extends State<BookSummary> {
  dynamic data;
  dynamic data2;
  dynamic getUser2;
  dynamic getUser;
  dynamic deduct;
  dynamic dec;
  dynamic rPay;
  dynamic rPay2;
  List list = [];
  bool isLoading=true;

  @override
  void initState(){
    super.initState();
    getdata();
  }

  Future getdata() async {
    Map sendData ={
      'Booking_Id': widget.bid
    };
    http.Response response = await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/User_Fetch_API/Booking_Summery_User.php" ),body:sendData);
    if (response.statusCode == 200) {
      data = response.body;
      dec = response.body;
      rPay2 = response.body;
      setState(() {
        isLoading = false;
        getUser2 = jsonDecode(data!)["users"];
        deduct = double.parse(jsonDecode(dec!)["users"][0]["Total_Price"]) /10;
        rPay = double.parse(jsonDecode(rPay2!)["users"][0]["Total_Price"])- deduct;
        ratings();
      });
    }
  }

  Future ratings() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Car_Details_Feedback.php",
    ),body: {'Vehicle_Id' : widget.vid});
    if(response.statusCode==200) {
      data2 = response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data2!)["users"];
        for(var data in getUser){
          list.add(double.parse(data["Ratings"]));
        }
      }
      );
    }
  }

  double avg()
  {
    if(list.isEmpty) {
      return 0.0;
    }
    double sum = 0.0;
    for(var rating in list)
    {
      sum += rating;
    }
    return sum /list.length;
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy ').format(dateTime);
  }

  String formatTime(String time) {
    DateTime dateTime = DateFormat.Hms().parse(time);
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Book Summary",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: mheight*0.030),),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple,),)
      : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:15,left: 15,right: 15,),
          child: Column(
            children: [
              Row(
                children: [
                  Image.network(getUser2[0]["Vehicle_Image"],fit: BoxFit.contain,
                    height: mheight*0.15,width: mwidth*0.4,
                  ),
                  SizedBox(width: mwidth*0.02,),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Container(
                            padding: const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                            decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                borderRadius: BorderRadius.circular(6)
                            ),
                            child: Text(getUser2[0]["Category_Name"])),
                        Row(
                          children: [
                            Text(avg().toStringAsFixed(2)),
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 18,
                            )
                          ],
                        )
                      ],),
                      SizedBox(height: mheight*0.01,),
                      Text(getUser2[0]["Vehicle_Name"],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      SizedBox(height: mheight*0.03,),
                      Row(
                        children: [
                          const Text("₹"),
                          Text(getUser2[0]["Rent_Price"],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Text("/day"),
                        ],
                      ),
                    ],
                  ))
                ],
              ),
              Divider(height: mheight*0.05,),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                     const Text("Pick-Up Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                     Text(formatTime(getUser2[0]["Start_Time"]),style: const TextStyle(fontSize: 16,)),
                   ],
                  ),
                  SizedBox(height: mheight*0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Pick-Up Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      Text(formatDate(getUser2[0]["Start_Date"]),style: const TextStyle(fontSize: 16,)),
                    ],
                  ),
                  SizedBox(height: mheight*0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Return  Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      Text(formatTime(getUser2[0]["Return_Time"]),style: const TextStyle(fontSize: 16,)),
                    ],
                  ),
                   SizedBox(height: mheight*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Return Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        Text(formatDate(getUser2[0]["Return_Date"]),style: const TextStyle(fontSize: 16,)),
                    ],
                  ),
                ],
              ),
              Divider(height: mheight*0.05,),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Payment Mode",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                      Text(getUser2[0]["Payment_Mode"]),
                    ],
                  ),
                  SizedBox(height: mheight*0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Amount",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Text("₹"),
                          Text(getUser2[0]["Rent_Price"]+"/day",),
                        ]
                      )
                    ],
                  ),
                  Divider(height: mheight*0.03,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Text("₹"),
                          Text(getUser2[0]["Total_Price"]),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: mheight*0.08,),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.only(bottom: 5,left: 10,right: 10),
        child:  isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple,),)
        :Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(getUser2[0]["Booking_Status"] == "1") ...[
            Expanded(
              child: SizedBox(
               height: mheight*0.065,
               child: ElevatedButton(
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.deepPurple.shade800,),
                    onPressed: () {
                      Get.to(()=> CancelBookingUser(pid:getUser2[0]["Payment_Id"],bid:getUser2[0]["Booking_Id"],amount:rPay.toString()));
                 },
                 child: const Text("Cancel"),)),
         ),
         const SizedBox(width: 16,),
       ],
            Expanded(
              child: SizedBox(
                  height: mheight*0.065,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black),
                      onPressed: () {
                        Get.to(()=> Complain(vid:getUser2[0]["Vehicle_Id"]));
                      },
                      child: const Text("Complain"))),
            ),
            const SizedBox(width: 16,),
            if(getUser2[0]["Booking_Status"] == "0") ...[
              Expanded(
                child: SizedBox(
                    height: mheight*0.065,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade800,),
                      onPressed: () {
                        Get.to(()=> FeedBackUser(num: widget.val3, vid: getUser2[0]["Vehicle_Id"], type: getUser2[0]["Vehicle_Type"]));
                      },
                      child: const Text("Feedback"),)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
