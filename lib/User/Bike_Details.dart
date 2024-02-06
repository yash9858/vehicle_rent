import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/User/Homescreen.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'Feedback_User.dart';
import 'Select_date.dart';

class bike_detail extends StatefulWidget {
  const bike_detail({super.key});

  @override
  State<bike_detail> createState() => _bike_detailState();
}

class _bike_detailState extends State<bike_detail> {
  double rating = 0;
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(

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
                    Image.asset("assets/img/bullet.jpeg",height: mheight*0.33,),
                  ],
                ),
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 300),
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
                            Text("Thunder 350X",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                            Row(
                              children: [Text("4.1",style: TextStyle(fontSize: 20,color: Colors.white),),Icon(Icons.star,color: Colors.orange,)],
                            )
                          ],
                        ),

                        //overview
                        SizedBox(height: mheight*0.02,),

                        Container(
                          child: Text("Renaul Kwid is compact hetchback produced by Renaut it have a petrol engine that give a perfect power to this car ",style: TextStyle(color: Colors.grey),),
                        ),


                        SizedBox(height: mheight*0.03,),
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
                                              trailing: const Text("Timestamp", style: TextStyle(color: Colors.white),),
                                              title: const Text("Name",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
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
                                              leading: Image.asset("assets/img/Logo.jpg",height: mheight * 0.5,width: mwidth * 0.1,),
                                            ),
                                            const Padding(
                                                padding:EdgeInsets.all(10),
                                                child: Text("your review", style: TextStyle(
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

      bottomSheet: Container(
        color: Colors.deepPurple.shade800,
        padding: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 10),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("₹450/Day",style: TextStyle(fontSize: mheight*0.03,color: Colors.white),),
            Container(

              height: mheight*0.07,
              width: mwidth*0.40,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Background color
                ),


                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Select_date()));
                },child: Text("Book"),),
            )
          ],
        ),
      ),
    );
  }
}

