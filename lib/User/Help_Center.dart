import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {

  late bool _customicon = false;

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
    var mdheight = MediaQuery.sizeOf(context).height;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: mdheight * 0.025,
              ),
              title: const Text('Help Center'),
              backgroundColor: Colors.deepPurple.shade800,
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              centerTitle: true,
              bottom: const TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
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
                          return Padding(
                              padding:  EdgeInsets.symmetric(vertical: 10),
                              child: ExpansionTile(
                                shape: ShapeBorder.lerp(
                                    InputBorder.none, const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 1.5,
                                  ),
                                ), 20),
                                leading:  Text('$index'),
                                title: Text(QA[index]),
                                trailing: Icon(
                                    _customicon ? Icons.expand_less : Icons.expand_more
                                ),
                                children: [
                                  ListTile(
                                      title: Padding(
                                        padding: EdgeInsets.only(left : 20),
                                        child:Text(Ans[index],style: TextStyle(
                                          color: Colors.deepPurple.shade800,
                                        ),),
                                      ))
                                ],
                                onExpansionChanged: (bool expanded){
                                  setState(()=> _customicon = expanded);
                                },
                              ));
                        }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child : ListView.builder(
                        itemCount: title.length,
                        shrinkWrap: true,
                        itemBuilder: (context , int index) {
                          return Padding(
                              padding:  EdgeInsets.symmetric(vertical: 10),
                              child: ExpansionTile(
                                shape: ShapeBorder.lerp(
                                    InputBorder.none, const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 1.5,
                                  ),
                                ), 20),
                                leading:  Icon(icon[index]),
                                title: Text(title[index]),
                                trailing: Icon(
                                  _customicon ? Icons.expand_less : Icons.expand_more
                                ),
                                children: [
                                  ListTile(
                                    title: Padding(
                                      padding: EdgeInsets.only(left : 20),
                                    child:Text(val[index]),
                                  ))
                                ],
                                onExpansionChanged: (bool expanded){
                                  setState(()=> _customicon = expanded);
                                },
                              ));
                        }
                    ),
                  ),
    ],
    )
    ));
    }
    }
