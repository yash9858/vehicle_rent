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
  var getUser;
  var data2;
  bool isLoading=true;
  void initState(){
    super.initState();
    getdata();
    getdata2();
  }

  Future getdata() async{

    SharedPreferences share=await SharedPreferences.getInstance();
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Booking_History_User.php"),body: {'Login_Id':share.getString('id')});
    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data!)["users"];
      });
    }
  }

  Future getdata2() async{

    SharedPreferences share=await SharedPreferences.getInstance();
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Past_Booking.php"),body: {'Login_Id':share.getString('id')});
    if(response.statusCode==200) {
      data2 = response.body;

      setState(() {
        isLoading=false;
        getUser=jsonDecode(data2!)["users"];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
          //centerTitle: true,
            title: Text("Booking History",style: TextStyle(fontWeight: FontWeight.bold,fontSize: mdheight*0.030),),
            elevation: 0,
           // backgroundColor: Colors.transparent,
          //  iconTheme: const IconThemeData(color: Colors.black),
            bottom: const TabBar(
                indicatorColor: Colors.deepPurple,
                indicatorWeight: 3,
                labelColor: Colors.white,
                tabs: [
                  Tab(
                    text: 'Current Booking',
                  ),
                  Tab(
                    text: 'Past Booking',
                  ),
                ]),
          ),
        body: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
        :

        TabBarView(
          children: [
            getUser2==null?
                Container(
                    padding: EdgeInsets.only(top: 5,left: 8,right: 8),
                    child:Center(
                        child:Text('No Bookings'))
                ):
            Container(
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Book_summary(val3: index,Bid:getUser2[index]["Booking_Id"], vid:getUser2[index]["Vehicle_Id"])));

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

            //second tab code
            getUser==null?
            Container(
              padding: EdgeInsets.only(top: 5,left: 8,right: 8),
              child:Center(
                child:Text('No Past Data'))
            ):
            Container(
              padding: EdgeInsets.only(top: 5,left: 8,right: 8),
              child: ListView.builder(
                itemCount: getUser.length,
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
                          Image.network(getUser[index]["Vehicle_Image"],fit: BoxFit.contain,
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
                                        child: Text(getUser[index]["Category_Name"])),
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
                                Text(getUser[index]["Vehicle_Name"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                // SizedBox(height: mheight*0.01,),
                                //last Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Money
                                    Row(
                                      children: [
                                        Text(
                                          "₹"+getUser[index]["Rent_Price"]
                                          ,style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        Text("/day"),
                                      ],
                                    ),

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
          ],
        ),
      ),
    );
  }
}
