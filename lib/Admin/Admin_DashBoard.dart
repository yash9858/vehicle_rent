


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:rentify/Admin/Booking_Admin.dart';
import 'package:rentify/Admin/CancelBooking_Admin.dart';
import 'package:rentify/Admin/Complain_Admin.dart';
import 'package:rentify/Admin/Feedback_Admin.dart';
import 'package:rentify/Admin/Payment_Admin.dart';
import 'package:rentify/Admin/Report_Generate.dart';
import 'package:rentify/Admin/UserList_Admin.dart';
import 'package:rentify/Admin/Vehicle_Admin.dart';
import 'package:rentify/Admin/Vehicle_Category_Admin.dart';
import 'package:rentify/Login_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DrawerNavigationItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final bool selected;
  final Function() onTap;
  const DrawerNavigationItem({
    Key? key,
    required this.iconData,
    required this.title,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      leading: Icon(iconData),
      onTap: onTap,
      title: Text(title),
      selectedTileColor: Colors.white,
      selected: selected,
      selectedColor: Colors.black,
      textColor: Colors.white,
      iconColor: Colors.white,
    );
  }
}

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text(
      "Hello Admin !",
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    ),
    );
  }
}

// ignore: camel_case_types
class Admin_DashBoard extends StatefulWidget {
  const Admin_DashBoard({super.key});
  @override
  State<Admin_DashBoard> createState() => _Admin_DashBoardState();
}

// ignore: camel_case_types
class _Admin_DashBoardState extends State<Admin_DashBoard> {
  String? data;
  var getUser;
  var det;
  var cat;
  var vehicle;
  var book;
  var pay;
  var com;
  var feed;
  bool isLoading=true;

  void initState(){
    super.initState();
    getdata();
  }
  Future getdata() async{
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Admin_DashBoard.php"));
    if(response.statusCode==200){
      data=response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["user"];
        det=jsonDecode(data!)["user"]["Details_Id"];
        cat=jsonDecode(data!)["user"]["Category_Id"];
        vehicle=jsonDecode(data!)["user"]["Vehicle_Id"];
        book=jsonDecode(data!)["user"]["Booking_Id"];
        pay=jsonDecode(data!)["user"]["Payment_Id"];
        com=jsonDecode(data!)["user"]["Complain_Id"];
        feed=jsonDecode(data!)["user"]["Feedback_Id"];
      });
    }
  }

  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {

    var pageName = ['Total Users', 'Total Categories' ,'Total Vehicles','Success Bookings', 'Total Payments', 'Total Complains', 'Total Feedbacks'];
    var total = [det.toString(), cat.toString(), vehicle.toString(), book.toString(), pay.toString(), com.toString(), feed.toString()];
    var page =  [Admin_UserPage(), Admin_CategoryPage(), Admin_VehiclePage(), Admin_BookingPage(), Admin_PaymentPage(), Admin_ComplainPage(), Admin_FeedbackPage()];
    var image = ['assets/img/user.json','assets/img/category.json','assets/img/vehicle.json','assets/img/bookings.json','assets/img/payments.json','assets/img/complain.json','assets/img/feedback.json'];

    var mdheight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.deepPurple.shade800,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(mdheight * 0.015),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: mdheight * 0.02,
                ),
                DrawerHeader(),
                 SizedBox(
                  height: mdheight * 0.02,
                ),
                DrawerNavigationItem(
                  iconData:  Icons.home_rounded,
                  title: "Admin DashBoard",
                  selected: _currentIndex == 0,
                  onTap: () =>
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Admin_DashBoard())),
                  },
                ),
                DrawerNavigationItem(
                  iconData:Icons.account_circle_rounded,
                  title: "Manage User",
                  selected: _currentIndex == 1,
                  onTap: () =>
                  {
                    _currentIndex == 0,
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Admin_UserPage())),
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.list,
                  title: "Manage Category",
                  selected: _currentIndex == 2,
                  onTap: () =>
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Admin_CategoryPage())),
                    _currentIndex = 0
                  },
                ),
                DrawerNavigationItem(
                  iconData:LineIcons.car,
                  title: "Manage Vehicle",
                  selected: _currentIndex == 3,
                  onTap: () =>
                  {
                    Navigator.push(context , MaterialPageRoute(builder: (context) => const Admin_VehiclePage())),
                    _currentIndex = 0
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.date_range_sharp,
                  title: "Manage Bookings",
                  selected: _currentIndex == 4,
                  onTap: () =>
                  {
                    Navigator.push(context , MaterialPageRoute(builder: (context) => const Admin_BookingPage())),
                    _currentIndex = 0
                  },
                ),
                DrawerNavigationItem(
                  iconData:Icons.paid_rounded,
                  title: "Manage Payments",
                  selected: _currentIndex == 5,
                  onTap: () =>
                  {
                    Navigator.push(context , MaterialPageRoute(builder: (context) => const Admin_PaymentPage())),
                    _currentIndex = 0
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.free_cancellation_outlined,
                  title: "Cancle Bookings",
                  selected: _currentIndex == 6,
                  onTap: () =>
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Cancel_Bookings())),
                    _currentIndex = 0
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.forum,
                  title: "Manage Complains",
                  selected: _currentIndex == 7,
                  onTap: () =>
                  {
                    Navigator.push(context , MaterialPageRoute(builder: (context) => const Admin_ComplainPage())),
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.feedback_rounded,
                  title: "Manage Feedbacks",
                  selected: _currentIndex == 8,
                  onTap: () =>
                  {
                    Navigator.push(context , MaterialPageRoute(builder: (context) => const Admin_FeedbackPage())),
                    _currentIndex = 0
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.picture_as_pdf_rounded,
                  title: "Generate Report",
                  selected: _currentIndex == 9,
                  onTap: () =>
                  {
                    Navigator.push(context , MaterialPageRoute(builder: (context) => Report_Admin())),
                    _currentIndex = 0
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.logout_outlined,
                  title: "Log Out",
                  selected: _currentIndex == 10,
                  onTap: () async
                  {
                    final pref = await SharedPreferences.getInstance();
                    await pref.clear();
                    await pref.setBool('seen', true);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const LoginPage()),  (Route<dynamic> route) => false);
                    _currentIndex = 0;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        leading: Builder(
          builder: (context){
          return IconButton(icon: Icon(Icons.sort),
          onPressed: () => Scaffold.of(context).openDrawer());
          }),
        title: const Text('Admin DashBoard'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme:  IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
      : Padding(
      padding: EdgeInsets.all(mdheight * 0.01),
      child: GridView.builder(
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: mdheight * 0.015,
            mainAxisSpacing: mdheight * 0.015,
            mainAxisExtent: mdheight * 0.23,
          ),
          itemCount: total.length,
          itemBuilder: (context, int index)
          {
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => page[index]));
              },
                child:Card(
                  elevation: 12.0,
                  color: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                children: [
                  SizedBox(
                    height: mdheight * 0.13,
                    child: Lottie.asset(image[index],),
                  ),
                  SizedBox(height: mdheight * 0.015,),
                  Text(pageName[index],
                    style: const TextStyle(fontSize: 18),),
                  SizedBox(height: mdheight * 0.01,),
                  Text(total[index],
                      style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ));
          }),
    ));
  }
}
