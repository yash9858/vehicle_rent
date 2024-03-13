import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentify/User/Book_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class History_page extends StatefulWidget {
  const History_page({super.key});

  @override
  State<History_page> createState() => _History_pageState();
}

class _History_pageState extends State<History_page> {

  var data;
  var getUser2;
  bool isLoading=false;
  void initState(){
    super.initState();
    getdata();
  }

  Future getdata() async{

    SharedPreferences share=await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Booking_History_User.php"),body: {'Login_Id':share.getString('id')});
    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data!)["users"];
      });
      if (getUser2['error'] == false) {
        // SharedPreferences setpreference = await SharedPreferences.getInstance();
        // setpreference.setString('b_id', getUser2['Booking_Id']);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
          title: Text("Booking History",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: mdheight*0.030),),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
      body: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
      : Container(
        padding: EdgeInsets.only(top: 5,left: 8,right: 8),
        child: ListView.builder(
          itemCount: getUser2.length,
          itemBuilder: (context, index) {
            return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
              elevation: 6,
              child: Row(

                children: [
                  //Image
                  Container(

                    child:
                    Image.network(getUser2[index]["Vehicle_Image"],fit: BoxFit.contain,
                      height: mdheight*0.15,width: mwidth*0.4,

                    )
                    ,),

                  SizedBox(width: mwidth*0.02,),


                  Expanded(

                      child: Column(
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
                              child: Text(getUser2[index]["Category_Name"])),
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
                      SizedBox(height: mdheight*0.01,),

                      //Car Name
                      Text(getUser2[index]["Vehicle_Name"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      // SizedBox(height: mheight*0.01,),
                      //last Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Money
                          Row(
                            children: [
                              Text(
                                "₹"+getUser2[index]["Rent_Price"]
                                ,style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text("/day"),
                            ],
                          ),
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Book_summary(val3: index,Booking_Id: getUser2[index]["Booking_Id"])));

                          }, child: Text("View"))
                        ],
                      ),
                    ],
                  ))

                ],
              ),
            );

          },
        ),
      ),
    );
  }
}
