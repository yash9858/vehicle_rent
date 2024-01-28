import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/User/Car_Details.dart';

class Bike extends StatefulWidget {
  const Bike({super.key});

  @override
  State<Bike> createState() => _BikeState();
}

class _BikeState extends State<Bike> {
  @override
  Widget build(BuildContext context) {
    var    mheight=MediaQuery.sizeOf(context).height;
    var   mwidth=MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        title: Text("Available Bikes",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: mheight*0.033),),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,

      ),
      body: Container(
        padding: EdgeInsets.only(left: 10,right: 10),

        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: mheight * 0.27, // Adjust this value
                crossAxisSpacing: 5,
                mainAxisSpacing: 5
            ),
            itemCount: 20,
            itemBuilder: (BuildContext context,int index){
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>car_detail()));
                },
                child: Container(

                    child:  Card(
                        borderOnForeground: true,

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
                              child: Image.asset("assets/bullet.jpeg",fit: BoxFit.cover,),
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
                                              Text(
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
                        ))
                ),
              );
            }),
      ),
    );
  }
}


