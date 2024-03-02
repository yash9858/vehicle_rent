// ignore_for_file: camel_case_types, depend_on_referenced_packages, file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/User/Feedback_User.dart';
import 'package:rentify/User/Homescreen.dart';
import 'package:rentify/User/Select_date.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
class car_detail extends StatefulWidget {
  final int val;
  final String carid;
  const car_detail({required this.val,required this.carid});
  @override
  State<car_detail> createState() => _car_detailState();
}

class _car_detailState extends State<car_detail> {
  double rating = 0;
  bool isLoading=false;
  var data;
  var getUser2;
  var getUser3;

  void initState(){
    super.initState();
    getdata2();
    getdata3();
  }
  Future getdata2() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/DashBoard_Car_Fetch.php"));
    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data!)["users"];
      });
      if (getUser2['error'] == false) {
        SharedPreferences setpreference = await SharedPreferences.getInstance();
        setpreference.setString('type', data['Vehicle_Type'].toString());
      }
    }
  }
  Future getdata3() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Car_Details_Feedback.php"));
    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser3=jsonDecode(data!)["users"];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple,),)
    : Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(
        child:Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left:8),
                        child: IconButton(
                            onPressed: () => {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homescreen())),
                            },
                            icon: const Icon(Icons.arrow_back,)),
                      ),
                      const Text("Car Details",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                            onPressed: (){},
                            icon: const Icon(LineIcons.heart)),
                      )
                    ],
                  ),
                ),
                Image.network(getUser2[widget.val]["Vehicle_Image"])
              ],
            ),
            SingleChildScrollView(
              child: Padding(
              padding:  EdgeInsets.only(top: mdheight * 0.37),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurple.shade800,
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                ),
                padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.035),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //car name and rating
                  children: [
                    SizedBox(height: mdheight*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(getUser2[widget.val]["Vehicle_Name"],style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                      ],
                    ),
                    //overview
                    SizedBox(height: mdheight*0.022,),
                     Text(getUser2[widget.val]["Vehicle_Description"],style: TextStyle(color: Colors.grey),),
                    SizedBox(height: mdheight*0.01,),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: mdheight * 0.02),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Ratings & Reviews",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white.withOpacity(0.90),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(mdheight * 0.02),
                                          )),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const FeedBack_User()));
                                      }, child: const Text('View All Review', style: TextStyle(color: Colors.black),),),
                                  ],
                                ),
                                 SizedBox(
                                  height: 15,
                                ),
                                RatingSummary(
                                  counter: 15,
                                  average: 4,
                                  averageStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                  ),
                                  counterFiveStars: 7,
                                  labelCounterFiveStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  counterFourStars: 4,
                                  labelCounterFourStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  counterThreeStars: 2,
                                  labelCounterThreeStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  counterTwoStars: 1,
                                  labelCounterTwoStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  counterOneStars: 1,
                                  labelCounterOneStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: mdheight * 0.02),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: (BuildContext context,int index){
                                return Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          trailing: Text(getUser3[widget.val]["Feedback_Time"], style: TextStyle(color: Colors.white),),
                                          title:  Text(getUser3[widget.val]["Name"],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                          subtitle: RatingBar.builder(
                                            unratedColor: Colors.white,
                                            initialRating: 0,
                                            minRating: 0,
                                            direction: Axis.horizontal,
                                            itemSize: 25,
                                            itemCount: 5,
                                            allowHalfRating: true,
                                            itemBuilder: (context,_) =>  Icon(Icons.star,color: Colors.amber,),
                                            onRatingUpdate: (value) {
                                              setState(() {
                                                rating = value;
                                              });
                                            },
                                          ),
                                          leading: Image.network(getUser3[widget.val]["Profile_Image"],height: mdheight * 0.5,width: mdwidth * 0.1,),
                                        ),
                                        Padding(
                                            padding:EdgeInsets.all(10),
                                            child: Text(getUser3[widget.val]["Comment"],style: TextStyle(
                                              color: Colors.white,),))
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                  ],
                                );
                              }),
                          SizedBox(height: mdheight * 0.012,)
                        ]),
                    // Price and button
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.deepPurple.shade800,
        padding: const EdgeInsets.only(top: 10,left: 20,right: 15,bottom: 10),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("₹"+getUser2[widget.val]["Rent_Price"].toString()+"/Day",style: TextStyle(fontSize: mdheight*0.03,color: Colors.white),),
            SizedBox(
              height: mdheight*0.07,
              width: mdwidth*0.40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.9), // Background color
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Select_date(num : widget.val, v_id :widget.carid)));
                },child: const Text("Book",
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black),),),
            )
          ],
        ),
      ),
    );
  }
}
