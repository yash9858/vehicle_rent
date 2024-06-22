import 'dart:convert';
import 'package:flutter/Material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AdminBookingPage extends StatefulWidget {
  const AdminBookingPage({super.key});

  @override
  State<AdminBookingPage> createState() => _AdminBookingPageState();
}

class _AdminBookingPageState extends State<AdminBookingPage> {

  String? data;
  dynamic getUser;
  bool isLoading=true;

  @override
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

  String formatDateTime(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
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
      body: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),) : ListView.builder(
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
                            Row(
                              children: [
                                const Text("User Name: "),
                                Text(getUser[index]["Name"]),
                              ],
                            ),
                            Text(formatDateTime(getUser[index]["Booking_Timestamp"])),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.015),
                         Row(
                           children: [
                             const Text("Vehicle Name: "),
                             Text(getUser[index]["Vehicle_Name"]),
                           ],
                         ),
                        SizedBox(height: mdheight * 0.015,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('Start Date : '),
                                Text(formatDate(getUser[index]["Start_Date"])),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('Start Time : '),
                                Text(formatTime(getUser[index]["Start_Time"])),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: mdheight * 0.015,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('Return Date : '),
                                Text(formatDate(getUser[index]["Return_Date"])),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('Return Time : '),
                                Text(formatTime(getUser[index]["Return_Time"])),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: mdheight * 0.015,),
                        Row(
                          children: [
                            const Text('Booking Status : '),
                            Text(getUser[index]["Booking_Status"]),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.015,),
                        Row(
                          children: [
                            const Text('Address : '),
                            Text(getUser[index]["Address"]),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}
