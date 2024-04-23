import 'dart:convert';
import 'package:flutter/Material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// ignore: camel_case_types
class Admin_BookingPage extends StatefulWidget {
  const Admin_BookingPage({super.key});

  @override
  State<Admin_BookingPage> createState() => _Admin_BookingPageState();
}

// ignore: camel_case_types
class _Admin_BookingPageState extends State<Admin_BookingPage> {

  String? data;
  var getUser;
  bool isLoading=true;

  void initState(){
    super.initState();
    getdata();
  }
  Future getdata() async{
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Booking_Admin.php"));
    if(response.statusCode==200){
      data=response.body;
    }
    setState(() {
      isLoading=false;
      getUser=jsonDecode(data!)["users"];
    });
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy ').format(dateTime);
  }

  String formatTime(String time) {
    DateTime dateTime = DateFormat.Hms().parse(time);
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

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
    title: const Text('All Bookings'),
    backgroundColor: Colors.deepPurple.shade800,
    iconTheme: const IconThemeData(
    color: Colors.white,
    ),
          centerTitle: true,
    ),
      body: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),) : ListView.builder(
          itemCount: getUser.length,
          itemBuilder: (BuildContext context, int index)
          {
            return Padding(padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.025, vertical: mdheight * 0.005),
                child: Card(
                  elevation: 5.0,
                  shadowColor: Colors.deepPurple.shade800,
                  semanticContainer: true,
                  surfaceTintColor: Colors.deepPurple.shade800,
                  child: Padding(
                    padding: EdgeInsets.all(mdheight * 0.017),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("User Name: "+getUser[index]["Name"]),

                            Text(getUser[index]["Booking_Timestamp"]),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.015),
                         Row(
                           children: [
                             Text("Vehicle Name: "),
                             Text(getUser[index]["Vehicle_Name"]),
                           ],
                         ),
                        SizedBox(height: mdheight * 0.015,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Start Date : '+formatDate(getUser[index]["Start_Date"])),
                            Text('Start Time : '+formatTime(getUser[index]["Start_Time"])),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.015,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Return Date : '+formatDate(getUser[index]["Return_Date"])),
                            Text('Return Time : '+formatTime(getUser[index]["Return_Time"])),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.015,),
                        Text('Booking Status: '+getUser[index]["Booking_Status"]),
                        SizedBox(height: mdheight * 0.015,),
                        Text('Address: '+getUser[index]["Address"]),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}
