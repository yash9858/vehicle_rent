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
  String carname;
  String type;
  String descripation;
  String price;
  String image;


   car_detail({super.key , required this.val,required this.carid,required this.carname,required this.type,required this.descripation,required this.price,required this.image});
  @override
  State<car_detail> createState() => _car_detailState();
}

class _car_detailState extends State<car_detail> {
  double rating = 0;
  bool isLoading=true;
  var data;
  var data2;
  var data3;
  var getUser2;
  var getUser3;
  List list=[];
  var feed1;
  var feed2;
  var feed3;
  var feed4;
  var feed5;

  void initState(){
    super.initState();
   // cardet();
    getdata3();
    getdata2();

  }

  Future getdata2() async{
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Car_Details_Feedback.php",
    ),body: {'Vehicle_Id' : widget.carid});

    if(response.statusCode==200) {
      data2 = response.body;

      setState(() {
        isLoading=false;
         getUser3=jsonDecode(data2!)["users"];
        for(var data in getUser3){
          list.add(double.parse(data["Ratings"]));
        }
       // getdata3();
      }
      );
    }
  }

  Future getdata3() async{
    http.Response response= await http.post(Uri.parse(""
        "https://road-runner24.000webhostapp.com/API/User_Fetch_API/Feedback_Star_Avg.php",
    ),body: {'Vehicle_Id' : widget.carid});

    if(response.statusCode==200) {
      data3 = response.body;

      setState(() {
        isLoading=false;
        feed1 = jsonDecode(data3!)["FEEDBACK1"];
        feed2 = jsonDecode(data3!)["FEEDBACK2"];
        feed3 = jsonDecode(data3!)["FEEDBACK3"];
        feed4 = jsonDecode(data3!)["FEEDBACK4"];
        feed5 = jsonDecode(data3!)["FEEDBACK5"];
      }
      );
    }
  }
  double avg()
  {
    if(list.isEmpty)
      return 0.0;
    double sum = 0.0;
    for(var rating in list)
    {
      sum += rating;
    }
    return sum /list.length;
  }

    @override
  Widget build(context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      body:isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple,),): SafeArea(
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
                      Text("Car Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: mdheight*0.028),),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                            onPressed: (){},
                            icon: const Icon(LineIcons.heart)),
                      )
                    ],
                  ),
                ),
                Image.network(widget.image,height: 300,width: double.infinity,fit: BoxFit.fill)
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
                        Text(widget.carname,style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                      ],
                    ),
                    //overview
                    SizedBox(height: mdheight*0.022,),
                     Text(widget.descripation,style: TextStyle(color: Colors.grey),),
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedBack_User(num : widget.val, v_id :widget.carid,v_type: "car")));
                                      }, child: const Text('View All Review', style: TextStyle(color: Colors.black),),),
                                  ],
                                ),
                                 SizedBox(
                                  height: 15,
                                ),
                                feed1==null && feed2==null && feed3==null && feed4==null && feed5==null?
                                RatingSummary(
                                  counter: 1,
                                  average: 0,
                                  averageStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                  counterFiveStars: 0,
                                  labelCounterFiveStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  counterFourStars: 0,
                                  labelCounterFourStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  counterThreeStars: 0,
                                  labelCounterThreeStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  counterTwoStars: 0,
                                  labelCounterTwoStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  counterOneStars: 0,
                                  labelCounterOneStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                                    :RatingSummary(
                                  counter: feed1.length + feed2.length + feed3.length + feed4.length + feed5.length,
                                  average: avg(),
                                  averageStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                  counterFiveStars: feed5.length,
                                  labelCounterFiveStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  counterFourStars: feed4.length,
                                  labelCounterFourStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  counterThreeStars: feed3.length,
                                  labelCounterThreeStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  counterTwoStars: feed2.length,
                                  labelCounterTwoStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  counterOneStars: feed1.length,
                                  labelCounterOneStarsStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: mdheight * 0.02),
                          getUser3==null?Column(children:[
                            SizedBox(height: 42,),
                            Center(child: Text("No Feedbacks", style: TextStyle(fontSize: 22, color: Colors.white)),),
                            SizedBox(height: 42,),
                          ])
                              :ListView.builder(
                              shrinkWrap: true,
                              itemCount: getUser3.length,
                              itemBuilder: (BuildContext context,int index){
                                return Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          trailing: Text(getUser3[index]["Feedback_Time"], style: TextStyle(color: Colors.white),),
                                          title:  Text(getUser3[index]["Name"],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                          subtitle: RatingBar.builder(
                                            ignoreGestures: true,
                                            unratedColor: Colors.white,
                                            initialRating: double.parse(getUser3[index]["Ratings"]),
                                            minRating: 0,
                                            direction: Axis.horizontal,
                                            itemSize: 23,
                                            itemCount: 5,
                                            allowHalfRating: true,
                                            itemBuilder: (context,_) =>  Icon(Icons.star,color: Colors.amber,),
                                            onRatingUpdate: (value) {
                                              setState(() {
                                                rating = value;
                                              });
                                            },
                                          ),
                                          leading: Image.network(getUser3[index]["Profile_Image"],height: mdheight * 0.5,width: mdwidth * 0.1,),
                                        ),
                                        Padding(
                                            padding:EdgeInsets.all(10),
                                            child: Text(getUser3[index]["Comment"],style: TextStyle(
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
      bottomNavigationBar: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple,),):Container(
        color: Colors.deepPurple.shade800,
        padding: const EdgeInsets.only(top: 10,left: 20,right: 15,bottom: 10),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("₹"+widget.price.toString()+"/Day",style: TextStyle(fontSize: mdheight*0.03,color: Colors.white),),
            SizedBox(
              height: mdheight*0.07,
              width: mdwidth*0.40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.9), // Background color
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Select_date(num : widget.val, v_id :widget.carid,v_type: widget.type,)));
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
