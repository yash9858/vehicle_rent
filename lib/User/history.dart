import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentify/User/Book_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  dynamic data;
  dynamic getUser2;
  dynamic getUser;
  dynamic data2;
  bool isLoading=true;

  @override
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
          centerTitle: true,
            title: Text("Booking History",style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: mdheight*0.030),),
            elevation: 0,
           backgroundColor: Colors.transparent,
           iconTheme: const IconThemeData(color: Colors.black),
            bottom: const TabBar(
                indicatorColor: Colors.deepPurple,
                indicatorWeight: 3,
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: 'Current Booking',
                  ),
                  Tab(
                    text: 'Past Booking',
                  ),
                ]),
          ),
        body: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
        : TabBarView(
          children: [
            getUser2==null?
                Container(
                    padding: const EdgeInsets.only(top: 5,left: 8,right: 8),
                    child:const Center(
                        child:Text('No Bookings'))
                ): Container(
              padding: const EdgeInsets.only(top: 5,left: 8,right: 8),
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
                        Image.network(getUser2[index]["Vehicle_Image"],fit: BoxFit.contain,
                          height: mdheight*0.15,width: mwidth*0.4,
                        ),
                        SizedBox(width: mwidth*0.02,),
                        Expanded(
                            child: Column(
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
                                    child: Text(getUser2[index]["Category_Name"])),
                                    const Padding(
                                    padding: EdgeInsets.only(left: 5,right: 5,top: 2),
                                    child: Row(
                                    children: [
                                      Icon(Icons.bookmark,color: Colors.blueGrey,)
                                    ],
                                )),
                              ],),
                            SizedBox(height: mdheight*0.01,),
                            Text(getUser2[index]["Vehicle_Name"],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        const Text("₹",style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold)
                                        ),
                                        Text(
                                          getUser2[index]["Rent_Price"]
                                          ,style: const TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    const Text("/day"),
                                  ],
                                ),
                                TextButton(onPressed: (){
                                  Get.to(()=> BookSummary(val3: index,bid:getUser2[index]["Booking_Id"], vid:getUser2[index]["Vehicle_Id"]));
                                }, child: const Text("View"))
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
            getUser==null?
            Container(
              padding: const EdgeInsets.only(top: 5,left: 8,right: 8),
              child:const Center(
                child:Text('No Past Data'))
            ):
            Container(
              padding: const EdgeInsets.only(top: 5,left: 8,right: 8),
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
                        Image.network(getUser[index]["Vehicle_Image"],fit: BoxFit.contain,
                          height: mdheight*0.15,width: mwidth*0.4,
                        ),
                        SizedBox(width: mwidth*0.02,),
                        Expanded(
                            child: Column(
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
                                        child: Text(getUser[index]["Category_Name"])),
                                        const Padding(
                                        padding: EdgeInsets.only(left: 5,right: 5,top: 2),
                                        child: Row(
                                          children: [
                                            Icon(Icons.bookmark,color: Colors.blueGrey,)
                                          ],
                                        )),
                                  ],),
                                SizedBox(height: mdheight*0.01,),
                                Text(getUser[index]["Vehicle_Name"],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Text("₹",style: TextStyle(
                                                fontSize: 16, fontWeight: FontWeight.bold)
                                            ),
                                            Text(
                                              getUser[index]["Rent_Price"]
                                              ,style: const TextStyle(
                                                fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const Text("/day"),
                                      ],
                                    ),
                                    TextButton(onPressed: (){
                                      Get.to(()=> BookSummary(val3: index,bid:getUser[index]["Booking_Id"], vid:getUser[index]["Vehicle_Id"]));
                                    }, child: const Text("View"))
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