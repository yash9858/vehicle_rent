import 'dart:convert';

import 'package:flutter/Material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:http/http.dart' as http;

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
  bool isLoading=false;

  void initState(){
    super.initState();
    getdata();
  }
  Future getdata() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Booking_Admin.php"));
    if(response.statusCode==200){
      data=response.body;
    }
    setState(() {
      isLoading=false;
      getUser=jsonDecode(data!)["users"];
    });
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
                            Text("User Name: "+getUser[index]["Name"] ),

                            Text(getUser[index]["Booking_Timestamp"]),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.01,),
                         Row(
                           children: [
                             Text("Vehicle Name: "),
                             Text( getUser[index]["Vehicle_Name"]),
                           ],
                         ),
                        SizedBox(height: mdheight * 0.01,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Start Time: '+getUser[index]["Start_Datetime"],),

                          ],
                        ),
                        SizedBox(height: mdheight * 0.01,),
                        Text('Return Time: '+getUser[index]["Return_Datetime"]),
                        SizedBox(height: mdheight * 0.01,),
                         Text('Address: '+getUser[index]["Address"]),
                        SizedBox(height: mdheight * 0.01,),
                         //Text('Booking Status: '+getUser[index]["Booking_Status"]),
                        //SizedBox(height: mdheight * 0.01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(onPressed: (){
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.success,
                                text: 'Booking Accepted',
                                autoCloseDuration: const Duration(seconds: 3),
                                confirmBtnColor: Colors.deepPurple.shade800,
                                backgroundColor: Colors.deepPurple.shade800,
                              );
                            },
                                color: Colors.deepPurple.shade800,
                                padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                                ),
                                child: const Text('Accept Booking', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                )),
                            MaterialButton(onPressed: (){
                              CoolAlert.show(context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Do you Cancel Booking',
                                  confirmBtnColor: Colors.red,
                                  animType: CoolAlertAnimType.slideInDown,
                                  backgroundColor: Colors.red,
                                  cancelBtnTextStyle: const TextStyle(
                                    color: Colors.black,
                                  ));
                            },
                                color: Colors.red,
                                padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                                ),
                                child: const Text('Cancel Booking', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                )),
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
