// ignore_for_file: camel_case_types, depend_on_referenced_packages, file_names
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/User/Feedback_User.dart';
import 'package:rentify/User/Homescreen.dart';
import 'package:rentify/User/Select_date.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class car_detail extends StatefulWidget {
  const car_detail({super.key});
  @override
  State<car_detail> createState() => _car_detailState();
}

class _car_detailState extends State<car_detail> {
  double rating = 0;
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                Image.network("https://imgd-ct.aeplcdn.com/664x415/n/cw/ec/141125/kwid-exterior-right-front-three-quarter-3.jpeg?isig=0&q=80")
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Renault Kwid",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                      ],
                    ),
                    //overview
                    SizedBox(height: mdheight*0.022,),
                    const Text("Renault Kwid is compact hatchback produced by Renault it have a petrol engine that give a perfect power to this car ",style: TextStyle(color: Colors.grey),),
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
                                const SizedBox(
                                  height: 15,
                                ),
                                const RatingSummary(
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
                                          leading: Image.asset("assets/img/Logo.jpg",height: mdheight * 0.5,width: mdwidth * 0.1,),
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
            Text("₹450/Day",style: TextStyle(fontSize: mdheight*0.03,color: Colors.white),),
            SizedBox(
              height: mdheight*0.07,
              width: mdwidth*0.40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.9), // Background color
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const Select_date()));
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
