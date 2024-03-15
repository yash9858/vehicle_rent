// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class Item
{
  Item({
   required this.headerText,
   required this.expandedText,
   this.isExpanded = false,
});
  String headerText;
  String expandedText;
  bool isExpanded;
}
class _HelpCenterState extends State<HelpCenter> {

  String? data;
  var getUser;
  bool isLoading=false;

  void initState(){
    super.initState();
    getdata();

  }
  Future getdata() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/DashBoard_Category_Fetch.php"));
    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
      });
    }
  }

  var icon = [Icons.call, LineIcons.facebookMessenger, Icons.email_outlined];
  var title = ['Phone No', 'Message', 'Email'];
  var val = ['7834569202', '9646788902', 'Project123@gmail.com'];
  var QA = [
    'How Do I Rent A Car Or Bike Using The Rentify App?',
    'What Types Of Vehicles Are Available For Rent On The Rentify App?',
    'Can I Choose A Specific Date And Time For My Rental?',
    'Can I Cancel My Rental Through The Rentify App?',
    'How Does The Pricing Work For Car And Bike Rentals?',
    'Is There A Customer Support Service Available If Any Issues During My Rental?',
  ];
  var Ans = [
    'Open The App And Log In Or Create An Account.\nSelect Whether You Want To Rent A Car Or A Bike.\nChoose Your Preferred Date And Time For Pickup And Return. \nReview The Details, Including Rental Price, Model .\nConfirm Your Rental.',
    'Our App Offers A Wide Range Of Vehicles To Suit Your Preferences And Needs. You Can Find Cars Of  Compact To SUVs And Bikes Ranging From Standard To Premium Models.',
    'Absolutely! Our app allows you to select the date and time for both pickup and return, providing flexibility to match your schedule. This feature ensures that you have making your rental experience as convenient as possible.',
    'Yes, you can easily cancel your Rental through the app. Please check our cancellation policy for any applicable charges.',
    'The pricing is transparent and based on factors such as the type of vehicle, duration of the rental . We strive to provide competitive and fair pricing, ensuring you get the best value for your money.',
    'Absolutely. Our customer support team is available 24/7 to assist you with any questions or concerns. We are committed to ensuring a smooth and enjoyable rental experience for all our users.',
  ];
  @override
  Widget build(BuildContext context) {

    var mdheight = MediaQuery.sizeOf(context).height;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Help Center",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: mdheight*0.030),),

              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.black),
              bottom: const TabBar(
                  indicatorColor: Colors.deepPurple,
                  indicatorWeight: 2,
                  labelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: 'FAQ',
                    ),
                    Tab(
                      text: 'Contact Us',
                    ),
                  ]),
            ),
            body: TabBarView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(mdheight * 0.015),
                    child : ListView.builder(
                        itemCount: QA.length,
                        shrinkWrap: true,
                        itemBuilder: (context , int index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(vertical: mdheight * 0.01),
                              child: ExpansionTileGroup(
                              children: [
                                ExpansionTileItem(
                                  title: Text(QA[index]),
                                  expendedBorderColor: Colors.deepPurple,
                                  leading: Text('$index'),
                                  isHasLeftBorder: true,
                                  isHasRightBorder: true,
                                  textColor: Colors.black,
                                  children: [
                                    Text(Ans[index]),
                                  ],
                                ),
                          ]));
                        }
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(mdheight * 0.015),
                    child : ListView.builder(
                        itemCount: 3,
                        shrinkWrap: true,
                        itemBuilder: (context , int index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(vertical: mdheight * 0.01),
                              child: ExpansionTileGroup(
                              children: [
                                ExpansionTileItem(
                                  title: Text(title[index]),
                                  expendedBorderColor: Colors.deepPurple,
                                  leading: Icon(icon[index]),
                                  isHasLeftBorder: true,
                                  isHasRightBorder: true,
                                  textColor: Colors.black,
                                  iconColor: Colors.black,
                                  children: [
                                    Text(val[index]),
                                  ],
                                ),
                              ]));
                        }
                    ),
                  ),
    ],
    )
    ));
    }
    }
