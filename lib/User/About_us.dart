import 'package:flutter/material.dart';

class About_us extends StatefulWidget {
  const About_us({super.key});

  @override
  State<About_us> createState() => _About_usState();
}

class _About_usState extends State<About_us> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("About_Us",style: TextStyle(color: Colors.black,fontSize: 20),),

        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 5,left: 10,right: 10),
        child: Text(
          "The Vehicle Rental Application Is A Mobile App Developed Using The Flutter Framework Designed To Provide Users With A Convenient And Efficient Platform For Rent Vehicle.\n "
              "\n This System Aim To Provide A User Friendly Platform For User And High Quality Vehicle.\n"
              "\n We Can Provide Various Type Of Vehicles Like Car , Bike And Electric Vehicles (EV).\n "
              "\n • This Application Offers Flexible Rental Options Allowing Users To Rent Vehicles By Hour Or The Day Based On Their Specific Needs.\n "
              "\n • The Application Categorized Vehicle Into Different Types Making It Easy For User To Find Specific Vehicle They Need.\n"
              "\n • This Application Allowing The User To Pay For Their Rental Various Payment Methods Such As Credit Card , Online Banking etc . \n"
              "\n • User Have The Flexible To Cancel Their Booking And Get Refund .\n "
              "\n • Our System Cancelation Policies Are Very Clearly Communicated\n "
              "\n• Vehicle Renting System Are A Convenient And Affordable Way To Get Access To Vehicle When Needed.",style: TextStyle(fontSize: 17),
        ),
      ),
    );
  }
}
