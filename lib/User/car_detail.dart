

import 'package:flutter/material.dart';

import 'package:line_icons/line_icons.dart';
import 'package:rentify/User/Homescreen.dart';

class car_detail extends StatefulWidget {
  const car_detail({super.key});

  @override
  State<car_detail> createState() => _car_detailState();
}

class _car_detailState extends State<car_detail> {
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
                              Navigator.pop(context, MaterialPageRoute(builder: (context)=>Homescreen()));
                            },

                              icon: Icon(Icons.arrow_back,)),
                        ),
                        Text("Car Details",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: IconButton(
                            onPressed: (){},
                              icon: Icon(LineIcons.heart)),
                        )

                      ],
                    ),
                  ),
                  Image.network("https://imgd-ct.aeplcdn.com/664x415/n/cw/ec/141125/kwid-exterior-right-front-three-quarter-3.jpeg?isig=0&q=80")
                ],
                ),
              ),
              Padding(
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
                        Text("Renualt Kwid",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.white),),
                        Row(
                          children: [Text("4.1",style: TextStyle(fontSize: 20,color: Colors.white),),Icon(Icons.star,color: Colors.deepPurple.shade300,)],
                        )
                      ],
                      ),

                      //overview
                      SizedBox(height: mheight*0.02,),

                      Container(
                        child: Text("Renaul Kwid is compact hetchback produced by Renaut it have a petrol engine that give a perfect power to this car ",style: TextStyle(color: Colors.grey),),
                      ),


                      SizedBox(height: mheight*0.03,),
                      Text("Features",style: TextStyle(fontSize: mheight*0.032,fontWeight: FontWeight.bold,color: Colors.white),),

                      SizedBox(height: mheight*0.03,),
                      //Feature specifiction

                      Container(
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                            height: mheight*0.16,
                              width: mwidth*0.25,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(12),
                               color: Colors.deepPurple,
                             ),



                              child: Padding(
                                padding: const EdgeInsets.only(left: 7,top: 2),
                                child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Icon(Icons.event_seat),
                                    SizedBox(height: mheight*0.02,),

                                    Text("Total ",style: TextStyle(color: Colors.grey),),
                                    Text("Capacity",style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: mheight*0.02,),
                                    Text("5 Seats",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: mheight*0.16,
                              width: mwidth*0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.deepPurple,
                              ),



                              child: Padding(
                                padding: const EdgeInsets.only(left: 7,top: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Icon(LineIcons.car),
                                    SizedBox(height: mheight*0.02,),

                                    Text("Engine ",style: TextStyle(color: Colors.grey),),
                                    Text("Output",style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: mheight*0.02,),
                                    Text("65 HP",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: mheight*0.16,
                              width: mwidth*0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.deepPurple,
                              ),



                              child: Padding(
                                padding: const EdgeInsets.only(left: 7,top: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Icon(Icons.speed),
                                    SizedBox(height: mheight*0.02,),

                                    Text("Highest ",style: TextStyle(color: Colors.grey),),
                                    Text("Speed",style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: mheight*0.02,),
                                    Text("120 KM/H",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )

                      ),
                      SizedBox(height: mheight*0.04,),
                      // Price and button
                      Row(
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


                              onPressed: (){},child: Text("Book"),),
                          )
                        ],
                      )

                    ],
                  ),
                ),
              )
            ],
          ),
        ) );
  }
}
