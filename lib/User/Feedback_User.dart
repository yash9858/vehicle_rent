import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class FeedBack_User extends StatefulWidget {
  const FeedBack_User({super.key});

  @override
  State<FeedBack_User> createState() => _FeedBack_UserState();
}

class _FeedBack_UserState extends State<FeedBack_User> {
  late bool _customicon = false;
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
        titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: mdheight * 0.025,
    ),
    title: const Text('FeedBack'),
    backgroundColor: Colors.deepPurple.shade800,
    iconTheme: const IconThemeData(
    color: Colors.white,
    ),
    centerTitle: true,
    ),
      body:  Padding(
        padding: const EdgeInsets.only(top:15,left: 15,right: 15,),
        child: Column(
          children: [
        //car
        Row(

        children: [
        //Image
        Container(

        child:
          Image.asset("assets/img/tesla.jpg",
            fit: BoxFit.contain,
            height: mdheight*0.15,
            width: mdwidth *0.4,

        )
        ,),
      SizedBox(width: mdwidth*0.015,),
      Expanded(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Container(
                  padding: EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                  decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(6)
                  ),
                  child: Text("suv")),
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
            ],),
          SizedBox(height: mdheight*0.01,),
          Text("Kia Seltos Htk",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height: mdheight*0.02,),
          Row(
            children: [
              Text(
                "₹750",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text("/day"),
            ],
          ),
        ],
      ))
      ],
    ),
    Divider(
    height: mdheight*0.05,
    ),
            Center(child:Text('How Is Your Rental \nExperience')),
            Divider(
              height: mdheight*0.05,
            ),
            Center(child:Text('Your OverAll Rating')),
            Row(
              children: [

              ],
            ),
            Divider(
              height: mdheight*0.05,
            ),

    ])
      ));
  }
}
