//shri Gneshay Nam:


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentify/Admin/CancelBooking_Admin.dart';
import 'package:rentify/User/Cancel_booking.dart';
import 'package:rentify/User/Complain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Book_summary extends StatefulWidget {
  final int val3;
  final String? Booking_Id;
  const Book_summary({required this.val3, required this.Booking_Id});


  @override
  State<Book_summary> createState() => _Book_summaryState();
}


class _Book_summaryState extends State<Book_summary> {
  var data;

  var getUser2;
  bool isLoading=false;
  void initState(){
    super.initState();
    getdata();
  }

  Future getdata() async {
    SharedPreferences share = await SharedPreferences.getInstance();

    setState(() {
      isLoading = true;
    });
    Map senddata ={
      'Booking_Id': widget.Booking_Id
    };
    http.Response response = await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/User_Fetch_API/Booking_Summery_User.php" ),body:senddata);
    if (response.statusCode == 200) {
      data = response.body;

      setState(() {
        isLoading = false;
        getUser2 = jsonDecode(data!)["users"];
      });
    }
  }


DateTime _dateTime=DateTime(2023,1,12);
TimeOfDay _timeOfDay = TimeOfDay(hour: 8,minute: 10);
void _showdatepicker(){
  showDatePicker(
      context: context,
      firstDate: DateTime(2020), lastDate: DateTime(2025), initialDate: _dateTime,).then((value){
        setState(() {
          _dateTime=value!;
        });
  });
  
}

void _showtimepicker(){
  showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
    setState(() {
      _timeOfDay=value!;
    });
  });
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
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,

      ),
      body: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple,),)
      : SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.only(top:15,left: 15,right: 15,),
          child: Column(
            children: [
              //car
              Row(

                children: [
                  //Image
                  Container(

                    child:
                  Image.network(getUser2[widget.val3]["Vehicle_Image"],fit: BoxFit.contain,
                    height: mheight*0.15,width: mwidth*0.4,

                  )
                    ,),
                  SizedBox(width: mwidth*0.02,),
                  Expanded(child: Column(
                   // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //Category
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Container(
                            padding: EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                            decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                borderRadius: BorderRadius.circular(6)
                            ),
                            child: Text(getUser2[widget.val3]["Category_Name"])),
                        Row(
                          children: [
                            const Text("4.1"),
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 18,
                            )
                          ],
                        )
                      ],),
                      SizedBox(height: mheight*0.01,),

                      //Car Name
                      Text(getUser2[widget.val3]["Vehicle_Name"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      SizedBox(height: mheight*0.03,),
                      Row(
                        children: [
                          Text(
                            "₹"+getUser2[widget.val3]["Rent_Price"],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text("/day"),
                        ],
                      ),
                    ],
                  ))

                ],
              ),

              Divider(
                height: mheight*0.05,

              ),
              //Calender

              Container(
                child: Column(
                  children: [
                    //pick up time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("Pick-Up Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                       Text(getUser2[widget.val3]["Start_Time"],style: TextStyle(fontSize: 16,)),

                     ],
                    ),

                    SizedBox(height: mheight*0.02,),
                    //Pick up date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Pick-Up Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        Text(getUser2[widget.val3]["Start_Date"],style: TextStyle(fontSize: 16,)),

                      ],
                    ),

                    SizedBox(height: mheight*0.02,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Return  Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        Text(getUser2[widget.val3]["Return_Time"],style: TextStyle(fontSize: 16,)),

                      ],
                    ),

                     SizedBox(height: mheight*0.02,),
                    //Pick up date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Return Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        Text(getUser2[widget.val3]["Return_Date"],style: TextStyle(fontSize: 16,)),

                      ],
                    ),
                  ],
                ),
              ),

              Divider(
                height: mheight*0.05,
              ),

              //Amount
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Payment Mode",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                        Text(getUser2[widget.val3]["Payment_Mode"]),
                      ],
                    ),
                    SizedBox(height: mheight*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                        Text("₹"+getUser2[widget.val3]["Rent_Price"]+"/day",),
                      ],
                    ),
                    SizedBox(height: mheight*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Days",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                        Text("5"),
                      ],
                    ),
                    Divider(
                      height: mheight*0.05,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                        Text("₹"+getUser2[widget.val3]["Total_Price"] +"/day"),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: mheight*0.08,),




            ],
          ),
        ),
      ),
      bottomSheet:
      Container(
        padding: EdgeInsets.only(bottom: 5,left: 10,right: 10),
      //  width: double.infinity,
      //  height: mheight*0.08,
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
       //  if(getUser2[widget.val3]["Booking_Status"]==1)


             Container(
                 width: mwidth*0.45,
                height: mheight*0.065,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(

                        backgroundColor:    Colors.deepPurple.shade800,),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Cancel_booking_user(p_id:getUser2[widget.val3]["Payment_Id"],b_id:getUser2[widget.val3]["Booking_Id"])));
                    },
                    child: Text(
                      "Cancel"),)),

            Container(
                width: mwidth*0.45,
                height: mheight*0.065,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Complain(v_id:getUser2[widget.val3]["Vehicle_Id"])));
                    },
                    child: Text(
                      "Complain",
                    ))),
          ],
        ),

      ),

    );

  }
}
Widget cat(){
  return Container();
}

