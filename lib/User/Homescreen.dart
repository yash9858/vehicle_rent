

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:ui';

import 'package:rentify/User/Available_bike.dart';
import 'package:rentify/User/Available_car.dart';
import 'package:rentify/User/Bike_Details.dart';
import 'package:rentify/User/Car_Details.dart';
import 'package:rentify/User/Profile.dart';



class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
       // iconTheme: const IconThemeData(color: Colors.deepPurple),
        backgroundColor: Colors.deepPurple.shade800,
        elevation: 0,
        title: const Row(
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
             Icon(Icons.location_on_outlined),
            Text(
              "Hy!",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                 ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "User",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
            )
          ],
        ),
        actions: [
          const Padding(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(

                backgroundColor: Colors.black,
                child: Text("S"),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15,top: 6),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //Header Text



            SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            Container(
              child: SearchBar(
                // elevation: MaterialStateProperty.all(5),
                shape: MaterialStateProperty.all(const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                )),
                leading: const Icon(Icons.search),
                  trailing: [
              IconButton(
              icon: const Icon(Icons.keyboard_voice_rounded),
              onPressed: () {
                print('Use voice command');
              },
            ),

          ],

                hintText: "Find your vehicle",

                hintStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.grey)),

                //  backgroundColor: MaterialStateProperty.all(
                //   const Color(0xffece6f5),
                //  ),
              ),
            ),
            //  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            // CATEGORY
            // Row(
            //
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     TextButton(
            //         onPressed: () {
            //           Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
            //         },
            //
            //         child: Text("View all",  style: TextStyle(color: Colors.grey),)),
            //   ],
            // ),

            SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Card(
                        elevation: 5,

                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(10),
                          child: Image.network(
                            "https://t3.ftcdn.net/jpg/05/12/61/78/360_F_512617800_Y3fLiMSaoBYsZt9x8AysMBZv3sMh1cbd.jpg",
                            fit: BoxFit.cover,
                            height: mwidth * 0.17,
                          ),
                        ),
                      ),
                      Text(
                        "SUV",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Card(
                        elevation: 5,

                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(10),
                          child: Image.network(
                            "https://t3.ftcdn.net/jpg/05/12/61/78/360_F_512617800_Y3fLiMSaoBYsZt9x8AysMBZv3sMh1cbd.jpg",
                            fit: BoxFit.cover,
                            height: mwidth * 0.17,
                          ),
                        ),
                      ),
                      Text(
                        "Hetchback",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Card(

                        elevation: 5,

                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(10),
                          child: Image.network(
                            "https://t3.ftcdn.net/jpg/05/12/61/78/360_F_512617800_Y3fLiMSaoBYsZt9x8AysMBZv3sMh1cbd.jpg",
                            fit: BoxFit.cover,
                            height: mwidth * 0.17,
                          ),
                        ),
                      ),
                      Text(
                        "Seddan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Card(

                        elevation: 5,

                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(10),
                          child: Image.network(
                            "https://t3.ftcdn.net/jpg/05/12/61/78/360_F_512617800_Y3fLiMSaoBYsZt9x8AysMBZv3sMh1cbd.jpg",
                            fit: BoxFit.cover,
                            width: mwidth * 0.17,

                          ),
                        ),
                      ),
                      Text(
                        "MPV",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),




                ]),
            //SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            Container(
              padding: EdgeInsets.only(left: 5,right: 5),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "New Arrive",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                      },
                      child: Text(
                        "View More",
                        style: TextStyle(color: Colors.grey),
                      ))
                ],
              ),
            ),

              //  height: mheight * 0.49,
              // padding: EdgeInsets.only(top: 3, left: 10, right: 10),
            //card
            Container(
              height: mheight * 0.32,
              child: PageView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=>car_detail()));},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tesla",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "Model3 Long Range",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  LineIcons.heart,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text("Compact", style: TextStyle()),
                            ),
                            Image.asset(
                              'assets/img/tesla.jpg',
                              fit: BoxFit.cover,
                              height: mheight * 0.17,
                              width: mwidth,
                           //   filterQuality: FilterQuality.high,


                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "₹750",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("/day"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ),
                                    Text("4.9"),
                                    Text("(25 Review)"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),




            // SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            //popular text
            Container(
              padding: EdgeInsets.only(left: 5,right: 5),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Popular",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Car()));
                      },
                      child: Text(
                        "View More",
                        style: TextStyle(color: Colors.grey),
                      ))
                ],
              ),
            ),
            // SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            //car card



            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>car_detail()));
              },
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.25,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,


                      mainAxisSpacing: 5
                  ),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(

                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 7,right: 7,top: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Text("Hetchback",style: TextStyle(color: Colors.grey),),
                                  Icon(LineIcons.heart,color: Colors.red,)
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                              child: Image.network(
                                "https://i.pinimg.com/736x/5f/33/2d/5f332d3fbad470d3109cab05fb99beb6.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, bottom: 2, right: 4),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        " Kwid",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            " ₹400/Day",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              const Text("4.1"),
                                              Icon(
                                                Icons.star,
                                                color: Colors.orange,
                                                size: 18,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ]),
                              ),
                            )
                          ],
                        ));
                  },
                ),
              ),
            ),



            //available text

            Container(
              padding: EdgeInsets.only(left: 5,right: 5),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Popular",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Bike()));
                      },
                      child: Text(
                        "View More",
                        style: TextStyle(color: Colors.grey),
                      ))
                ],
              ),
            ),

            //Bike card
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>bike_detail()));
              },
              child: Container(
                height: MediaQuery.sizeOf(context).height * 0.25,


                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,


                      mainAxisSpacing: 5
                  ),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(

                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 7,right: 7,top: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Text("Royal Enfield",style: TextStyle(color: Colors.grey),),
                                  Icon(LineIcons.heart,color: Colors.red,)
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                              child: Image.asset("assets/img/bullet2.jpeg",fit: BoxFit.fitWidth,height: mheight*0.15,width: mwidth*0.75,),
                            //  child: Image.network("https://5.imimg.com/data5/SELLER/Default/2022/5/HR/UL/BO/3483248/royal-enfield-thunderbird-350-asphalt-500x500.png",fit: BoxFit.cover,),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, bottom: 2, right: 4),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        " Thunderbird 350X",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                " ₹400",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text("/day")
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text("4.1"),
                                              Icon(
                                                Icons.star,
                                                color: Colors.orange,
                                                size: 18,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ]),
                              ),
                            )
                          ],
                        ));
                  },
                ),
              ),
            ),

          ]),
        ),
      ),
    );
  }
}
