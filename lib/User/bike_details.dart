import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:rentify/User/select_date.dart';
import 'package:rentify/User/show_feedback.dart';

class BikeDetail extends StatefulWidget {
  final int val1;
  final String bikeId;
  final String bikeName;
  final String type;
  final String descripation;
  final String price;
  final String image;

  const BikeDetail({
    super.key,
    required this.val1,
    required this.bikeId,
    required this.bikeName,
    required this.type,
    required this.descripation,
    required this.price,
    required this.image
  });

  @override
  State<BikeDetail> createState() => _BikeDetailState();
}

class _BikeDetailState extends State<BikeDetail> {
  double rating = 0;
  bool isLoading=true;
  dynamic data;
  dynamic data2;
  dynamic data3;
  dynamic getUser2;
  dynamic getUser3;
  List list=[];
  dynamic f1;
  dynamic f2;
  dynamic f3;
  dynamic f4;
  dynamic f5;

  @override
  void initState(){
    super.initState();
    starCount();
  }

  Future starAvg() async{
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Car_Details_Feedback.php",
    ),body: {'Vehicle_Id' : widget.bikeId});
    if(response.statusCode==200) {
      data2 = response.body;
      setState(() {
        isLoading = false;
        getUser3=jsonDecode(data2!)["users"];
        for(var data in getUser3){
          list.add(double.parse(data["Ratings"]));
        }
      }
      );
    }
  }

  Future starCount() async{
    http.Response response= await http.post(Uri.parse(""
        "https://road-runner24.000webhostapp.com/API/User_Fetch_API/Feedback_Star_Avg.php",
    ),body: {'Vehicle_Id' : widget.bikeId});
    if(response.statusCode==200) {
      data3 = response.body;
      setState(() {
        f1 = jsonDecode(data3!)["FEEDBACK1"];
        f2 = jsonDecode(data3!)["FEEDBACK2"];
        f3 = jsonDecode(data3!)["FEEDBACK3"];
        f4 = jsonDecode(data3!)["FEEDBACK4"];
        f5 = jsonDecode(data3!)["FEEDBACK5"];
        starAvg();
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
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Bikes Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: mheight*0.028,color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
          : SafeArea(
        child:Stack(
          children: [
            Column(
              children: [
                Image.network(widget.image,height: mheight*0.33,width: mwidth*7,fit: BoxFit.cover),
              ],
            ),
            SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.only(top: mheight * 0.37),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade800,
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                    ),
                    padding:  EdgeInsets.symmetric(horizontal: mwidth * 0.035),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: mheight*0.02,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.bikeName,style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                            ],
                          ),
                          SizedBox(height: mheight*0.022,),
                          Text(widget.descripation,style: const TextStyle(color: Colors.grey),),
                          SizedBox(height: mheight*0.01,),
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
                                              Get.to(()=> ShowFeedback(num : widget.val1, vid: widget.bikeId,type: widget.type));
                                            }, child: const Text('View All Review', style: TextStyle(color: Colors.black),),),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      f1==null && f2==null && f3==null && f4==null && f5==null?
                                      const RatingSummary(
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
                                      ) : RatingSummary(
                                        counter: f1.length + f2.length + f3.length + f4.length + f5.length,
                                        average: avg(),
                                        averageStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                        ),
                                        counterFiveStars: f5.length,
                                        labelCounterFiveStarsStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        counterFourStars: f4.length,
                                        labelCounterFourStarsStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        counterThreeStars: f3.length,
                                        labelCounterThreeStarsStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        counterTwoStars: f2.length,
                                        labelCounterTwoStarsStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        counterOneStars: f1.length,
                                        labelCounterOneStarsStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: mheight * 0.02),
                                getUser3==null?const Column(children:[
                                  SizedBox(height: 50,),
                                  Center(child: Text("No Feedbacks", style: TextStyle(fontSize: 22, color: Colors.white)),),
                                  SizedBox(height: 50,),
                                ]) : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: getUser3.length,
                                    itemBuilder: (BuildContext context,int index){
                                      return Column(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                trailing: Text(getUser3[index]["Feedback_Time"], style: const TextStyle(color: Colors.white),),
                                                title: Text(getUser3[index]["Name"],style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                                subtitle: RatingBar.builder(
                                                  ignoreGestures: true,
                                                  unratedColor: Colors.white,
                                                  initialRating: double.parse(getUser3[index]["Ratings"]),
                                                  minRating: 0,
                                                  direction: Axis.horizontal,
                                                  itemSize: 23,
                                                  itemCount: 5,
                                                  allowHalfRating: true,
                                                  itemBuilder: (context,_) => const Icon(Icons.star,color: Colors.amber, size: 2),
                                                  onRatingUpdate: (value) {
                                                    setState(() {
                                                      rating = value;
                                                    });
                                                  },
                                                ),
                                                leading: Image.network(getUser3[index]["Profile_Image"],height: mheight * 0.5,width: mwidth * 0.1,),
                                              ),
                                              Padding(
                                                  padding:const EdgeInsets.all(10),
                                                  child: Text(getUser3[index]["Comment"], style: const TextStyle(
                                                    color: Colors.white,),))
                                            ],
                                          ),
                                          const Divider(
                                            thickness: 1,
                                          ),
                                        ],
                                      );
                                    }),
                                SizedBox(height: mheight * 0.012,)
                              ])
                        ]
                    ),
                  ),
                )
            )],
        ),
      ),
      bottomNavigationBar: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
          :Container(
        color: Colors.deepPurple.shade800,
        padding: const EdgeInsets.only(top: 10,left: 20,right: 15,bottom: 10),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("₹${widget.price}/Day",style: TextStyle(fontSize: mheight*0.03,color: Colors.white),),
            SizedBox(
              height: mheight*0.07,
              width: mwidth*0.40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Background color
                ),
                onPressed: (){
                  Get.to(()=> SelectDate(num:widget.val1, vid: widget.bikeId,type: widget.type));
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