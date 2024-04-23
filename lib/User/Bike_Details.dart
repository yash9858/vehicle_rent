import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:rentify/User/Show_Feedback.dart';
import 'Write_Feedback.dart';
import 'Select_date.dart';

class bike_detail extends StatefulWidget {
  final int val1;
  final String bikeid;
  String bikename;
  String type;
  String descripation;
  String price;
  String image;

  bike_detail({required this.val1,required this.bikeid,required this.bikename,required this.type,required this.descripation,required this.price,required this.image});

  @override
  State<bike_detail> createState() => _bike_detailState();
}

class _bike_detailState extends State<bike_detail> {

  double rating = 0;
  bool isLoading=true;
  var data;
  var data2;
  var data3;
  var getUser2;
  var getUser3;
  List list=[];
  var f1;
  var f2;
  var f3;
  var f4;
  var f5;

  void initState(){
    super.initState();
    star_count();
  }

  Future star_avg() async{
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Car_Details_Feedback.php",
    ),body: {'Vehicle_Id' : widget.bikeid});
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

  Future star_count() async{
    http.Response response= await http.post(Uri.parse(""
        "https://road-runner24.000webhostapp.com/API/User_Fetch_API/Feedback_Star_Avg.php",
    ),body: {'Vehicle_Id' : widget.bikeid});
    if(response.statusCode==200) {
      data3 = response.body;
      setState(() {
        f1 = jsonDecode(data3!)["FEEDBACK1"];
        f2 = jsonDecode(data3!)["FEEDBACK2"];
        f3 = jsonDecode(data3!)["FEEDBACK3"];
        f4 = jsonDecode(data3!)["FEEDBACK4"];
        f5 = jsonDecode(data3!)["FEEDBACK5"];
        star_avg();
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
        iconTheme: IconThemeData(color: Colors.black),

      ),
      body: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
          : SafeArea(
        child:Stack(
          children: [
            Container(
              child: Column(
                children: [

                  Image.network(widget.image,height: mheight*0.33,width: mwidth*7,fit: BoxFit.cover),
                ],
              ),
            ),
            SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.only(top: mheight * 0.37),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade800,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
                    ),

                    padding:  EdgeInsets.symmetric(horizontal: mwidth * 0.035),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //car name and reting
                        children: [
                          SizedBox(height: mheight*0.02,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.bikename,style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                            ],
                          ),

                          //overview
                          SizedBox(height: mheight*0.022,),

                          Text(widget.descripation,style: TextStyle(color: Colors.grey),),
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
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Show_Feedback(num : widget.val1, v_id: widget.bikeid,v_type: widget.type)));
                                            }, child: Text('View All Review', style: TextStyle(color: Colors.black),),),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      f1==null && f2==null && f3==null && f4==null && f5==null?
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
                                          : RatingSummary(
                                        counter: f1.length + f2.length + f3.length + f4.length + f5.length,
                                        average: avg(),
                                        averageStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                        ),
                                        counterFiveStars: f5.length,
                                        labelCounterFiveStarsStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        counterFourStars: f4.length,
                                        labelCounterFourStarsStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        counterThreeStars: f3.length,
                                        labelCounterThreeStarsStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        counterTwoStars: f2.length,
                                        labelCounterTwoStarsStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                        counterOneStars: f1.length,
                                        labelCounterOneStarsStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: mheight * 0.02),
                                getUser3==null?Column(children:[
                                  SizedBox(height: 50,),
                                  Center(child: Text("No Feedbacks", style: TextStyle(fontSize: 22, color: Colors.white)),),
                                  SizedBox(height: 50,),
                                ])
                                    : ListView.builder(
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
                                                trailing: Text(getUser3[index]["Feedback_Time"], style: TextStyle(color: Colors.white),),
                                                title: Text(getUser3[index]["Name"],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                                subtitle: RatingBar.builder(

                                                  ignoreGestures: true,
                                                  unratedColor: Colors.white,
                                                  initialRating: double.parse(getUser3[index]["Ratings"]),
                                                  minRating: 0,
                                                  direction: Axis.horizontal,
                                                  itemSize: 23,
                                                  itemCount: 5,
                                                  allowHalfRating: true,
                                                  itemBuilder: (context,_) => Icon(Icons.star,color: Colors.amber, size: 2),
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
                                SizedBox(height: mheight * 0.012,)
                              ])
                          // Price and button
                        ]
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
            Text("₹"+ widget.price.toString()+ "/Day",style: TextStyle(fontSize: mheight*0.03,color: Colors.white),),
            Container(

              height: mheight*0.07,
              width: mwidth*0.40,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Background color
                ),


                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Select_date(num : widget.val1, v_id: widget.bikeid,v_type: widget.type)));
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