import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/User/Homescreen.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Feedback_User.dart';
import 'Select_date.dart';

class bike_detail extends StatefulWidget {
  final int val1;
  final String bikeid;
  const bike_detail({required this.val1,required this.bikeid,});

  @override
  State<bike_detail> createState() => _bike_detailState();
}

class _bike_detailState extends State<bike_detail> {
  double rating = 0;
  bool isLoading=false;
  var data;
  var getUser2;
  var getUser3;

  void initState(){
    super.initState();
    getdata();
    getdata2();
  }

  Future getdata() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/DashBoard_Bike_Fetch.php"));
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

  Future getdata2() async{
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
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
          : SafeArea(

          child:Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:8),
                            child: IconButton(
                                onPressed: (){
                                  Navigator.pop(context, MaterialPageRoute(builder: (context)=>const Homescreen()));
                                },

                                icon: Icon(Icons.arrow_back,)),
                          ),
                          Text("Bike Details",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                                onPressed: (){},
                                icon: Icon(LineIcons.heart)),
                          )

                        ],
                      ),
                    ),
                    Image.network(getUser2[widget.val1]["Vehicle_Image"],height: mheight*0.33,),
                  ],
                ),
              ),
              SingleChildScrollView(
                physics: FixedExtentScrollPhysics(),
                child: Padding(
                  padding:  EdgeInsets.only(top: 300),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade800,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                    ),

                    padding: EdgeInsets.only(left: 20,right: 20),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //car name and reting
                      children: [
                        SizedBox(height: mheight*0.02,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(getUser2[widget.val1]["Vehicle_Name"],style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                          ],
                        ),

                        //overview
                        SizedBox(height: mheight*0.02,),

                        Container(
                          child: Text(getUser2[widget.val1]["Vehicle_Description"],style: TextStyle(color: Colors.grey),),
                        ),


                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: mheight * 0.02),
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
                                                BorderRadius.circular(mheight * 0.02),
                                              )),
                                          onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedBack_User()));
                                          }, child: Text('View All Review', style: TextStyle(color: Colors.black),),),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const RatingSummary(
                                      counter: 15,
                                      average: 4,
                                      averageStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
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
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 3,
                                  itemBuilder: (BuildContext context,int index){
                                    return Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              trailing: Text(getUser3[index]["Feedback_Time"], style: TextStyle(color: Colors.white),),
                                              title: Text(getUser3[index]["Name"],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                              subtitle: RatingBar.builder(
                                                unratedColor: Colors.white,
                                                initialRating: 0,
                                                minRating: 0,
                                                direction: Axis.horizontal,
                                                itemSize: 25,
                                                itemCount: 5,
                                                allowHalfRating: true,
                                                itemBuilder: (context,_) => const Icon(Icons.star,color: Colors.amber,),
                                                onRatingUpdate: (value) {
                                                  setState(() {
                                                    rating = value;
                                                  });
                                                },
                                              ),
                                              leading: Image.network(getUser3[index]["Profile_Image"],height: mheight * 0.5,width: mwidth * 0.1,),
                                            ),
                                             Padding(
                                                padding:EdgeInsets.all(10),
                                                child: Text(getUser3[index]["Comment"], style: TextStyle(
                                                  color: Colors.white,),))
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 1,
                                        ),
                                      ],
                                    );
                                  }),
                              SizedBox(height: mheight * 0.012,),
                            ]),
                        // Price and button
                      ],
                    ),
                  ),
                )
              )],
          ),
        ),

      bottomNavigationBar: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
      :Container(
        color: Colors.deepPurple.shade800,
        padding: EdgeInsets.only(top: 10,left: 20,right: 15,bottom: 10),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("₹"+ getUser2[widget.val1]["Rent_Price"].toString()+ "/Day",style: TextStyle(fontSize: mheight*0.03,color: Colors.white),),
            Container(

              height: mheight*0.07,
              width: mwidth*0.40,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Background color
                ),


                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Select_date(num : widget.val1, v_id: widget.bikeid)));
                },child: Text("Book",
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

