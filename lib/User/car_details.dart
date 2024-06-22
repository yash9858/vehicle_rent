import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentify/User/show_feedback.dart';
import 'package:rentify/User/select_date.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CarDetail extends StatefulWidget {
  final int val;
  final String carId;
  final String carName;
  final String type;
  final String descripation;
  final String price;
  final String image;

  const CarDetail({super.key , required this.val,required this.carId,required this.carName,required this.type,required this.descripation,required this.price,required this.image});

  @override
  State<CarDetail> createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {
  double rating = 0;
  bool isLoading=true;
  dynamic data;
  dynamic data2;
  dynamic data3;
  dynamic getUser2;
  dynamic getUser3;
  List list=[];
  dynamic feed1;
  dynamic feed2;
  dynamic feed3;
  dynamic feed4;
  dynamic feed5;

  @override
  void initState(){
    super.initState();
    getdata3();
  }

  Future getdata2() async{
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Car_Details_Feedback.php",
    ),body: {'Vehicle_Id' : widget.carId});
    if(response.statusCode==200) {
      data2 = response.body;
      setState(() {
        isLoading=false;
        getUser3=jsonDecode(data2!)["users"];
        for(var data in getUser3){
          list.add(double.parse(data["Ratings"]));
        }
      }
      );
    }
  }

  Future getdata3() async{
    http.Response response= await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/User_Fetch_API/Feedback_Star_Avg.php",
    ),body: {'Vehicle_Id' : widget.carId});

    if(response.statusCode==200) {
      data3 = response.body;
      setState(() {
        feed1 = jsonDecode(data3!)["FEEDBACK1"];
        feed2 = jsonDecode(data3!)["FEEDBACK2"];
        feed3 = jsonDecode(data3!)["FEEDBACK3"];
        feed4 = jsonDecode(data3!)["FEEDBACK4"];
        feed5 = jsonDecode(data3!)["FEEDBACK5"];
        getdata2();
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
  Widget build(context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: mdheight*0.028,color: Colors.black),),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body:isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple,),): SafeArea(
        child:Stack(
          children: [
            Column(
              children: [
                Image.network(widget.image,height: mdheight*0.3,width: mdwidth*7,fit: BoxFit.cover)
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
                      children: [
                        SizedBox(height: mdheight*0.02,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.carName,style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                          ],
                        ),
                        SizedBox(height: mdheight*0.022,),
                        Text(widget.descripation,style: const TextStyle(color: Colors.grey),maxLines: 3,),
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
                                            Get.to(()=> ShowFeedback(num : widget.val, vid :widget.carId,type: widget.type));
                                          }, child: const Text('View All Review', style: TextStyle(color: Colors.black),),),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    feed1==null && feed2==null && feed3==null && feed4==null && feed5==null?
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
                                    ) :RatingSummary(
                                      counter: feed1.length + feed2.length + feed3.length + feed4.length + feed5.length,
                                      average: avg(),
                                      averageStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                      ),
                                      counterFiveStars: feed5.length,
                                      labelCounterFiveStarsStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      counterFourStars: feed4.length,
                                      labelCounterFourStarsStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      counterThreeStars: feed3.length,
                                      labelCounterThreeStarsStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      counterTwoStars: feed2.length,
                                      labelCounterTwoStarsStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      counterOneStars: feed1.length,
                                      labelCounterOneStarsStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: mdheight * 0.02),
                              getUser3.length==0?const Column(children:[
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
                                              trailing: Text(getUser3[index]["Feedback_Time"], style: const TextStyle(color: Colors.white),),
                                              title:  Text(getUser3[index]["Name"],style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                              subtitle: RatingBar.builder(
                                                ignoreGestures: true,
                                                unratedColor: Colors.white,
                                                initialRating: double.parse(getUser3[index]["Ratings"]),
                                                minRating: 0,
                                                direction: Axis.horizontal,
                                                itemSize: 23,
                                                itemCount: 5,
                                                allowHalfRating: true,
                                                itemBuilder: (context,_) =>  const Icon(Icons.star,color: Colors.amber,),
                                                onRatingUpdate: (value) {
                                                  setState(() {
                                                    rating = value;
                                                  });
                                                },
                                              ),
                                              leading: Image.network(getUser3[index]["Profile_Image"],height: mdheight * 0.5,width: mdwidth * 0.1,),
                                            ),
                                            Padding(
                                                padding:const EdgeInsets.all(10),
                                                child: Text(getUser3[index]["Comment"],style: const TextStyle(
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
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
      bottomNavigationBar: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple,),):Container(
        color: Colors.deepPurple.shade800,
        padding: const EdgeInsets.only(top: 10,left: 20,right: 15,bottom: 10),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("₹",style: TextStyle(fontSize: mdheight*0.03,color: Colors.white),),
                Text(widget.price.toString(),style: TextStyle(fontSize: mdheight*0.03,color: Colors.white)),
                Text("/Day",style: TextStyle(fontSize: mdheight*0.03,color: Colors.white),),
              ],
            ),
            SizedBox(
              height: mdheight*0.07,
              width: mdwidth*0.40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.9), // Background color
                ),
                onPressed: (){
                  Get.to(()=> SelectDate(num : widget.val, vid :widget.carId,type: widget.type));
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