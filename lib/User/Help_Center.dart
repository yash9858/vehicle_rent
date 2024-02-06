// ignore_for_file: non_constant_identifier_names

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

  var icon = [Icons.call, LineIcons.facebookMessenger, Icons.email_outlined];
  var title = ['Phone No', 'Message', 'Email'];
  var val = ['955887****', '123446798', 'mistryyash123@gmail.com'];
  var QA = [
    'How Do I Rent A Car Or Bike Using The Rentify App?',
    'What Types Of Vehicles Are Available For Rent On The Rentify App?',
    'Can I Choose A Specific Date And Time For My Rental?',
    'Can I Modify Or Cancel My Reservation Through The Rentify App?',
    'How Does The Pricing Work For Car And Bike Rentals?',
    'Is There A Customer Support Service Available If I Encounter Any Issues During My Rental?',
  ];
  var Ans = [
    'Using Our App Is Simple And Convenient. Just Follow These Steps: \nOpen The App And Log In Or Create An Account.\nSelect Whether You Want To Rent A Car Or A Bike.\nChoose Your Preferred Date And Time For Pickup And Return.\nBrowse Through Available Options, And Select The Vehicle That Suits Your Needs.\nReview The Details, Including Rental Price, Model .\nConfirm Your Rental And Make A Secure Payment Through The App.',
    'Our App Offers A Wide Range Of Vehicles To Suit Your Preferences And Needs. You Can Find Cars Of Various Sizes From Compact To SUVs And Bikes Ranging From Standard To Premium Models.Each Vehicle Comes With Detailed Information Allowing You To Make An Informed Choice Based On Your Requirements.',
    'Absolutely! Our app allows you to select the exact date and time for both pickup and return, providing flexibility to match your schedule. This feature ensures that you have the vehicle precisely when you need it, making your rental experience as convenient as possible.',
    'Yes, you can easily cancel your Rental through the app. If your plans change, simply access your booking details, and you find options to adjust the pickup and return times or cancel the Rental. Please check our cancellation policy for any applicable charges.',
    'The pricing is transparent and based on factors such as the type of vehicle, duration of the rental . You can view the total cost before confirming your Rent. We strive to provide competitive and fair pricing, ensuring you get the best value for your money.',
    'Absolutely. Our customer support team is available 24/7 to assist you with any questions or concerns. You can reach out through the apps contact our helpline for immediate assistance. We are committed to ensuring a smooth and enjoyable rental experience for all our users.',
  ];
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Help Center",style: TextStyle(color: Colors.black,fontSize: 20),),

              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.black),
              bottom: const TabBar(
                  indicatorColor: Colors.deepPurple,
                  indicatorWeight: 3,
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
                    padding: const EdgeInsets.all(15),
                    child : ListView.builder(
                        itemCount: QA.length,
                        shrinkWrap: true,
                        itemBuilder: (context , int index) {
                          return ExpansionTileGroup(
                            spaceBetweenItem: 15,
                            toggleType: ToggleType.expandOnlyCurrent,
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
                          ]);
                        }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child : ListView.builder(
                        itemCount: title.length,
                        shrinkWrap: true,
                        itemBuilder: (context , int index) {
                          return ExpansionTileGroup(
                              toggleType: ToggleType.expandOnlyCurrent,
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
                              ]);
                        }
                    ),
                  ),
    ],
    )
    ));
    }
    }
