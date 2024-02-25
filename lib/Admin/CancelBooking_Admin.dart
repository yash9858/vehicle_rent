import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Cancel_Bookings extends StatefulWidget {
  const Cancel_Bookings({super.key});

  @override
  State<Cancel_Bookings> createState() => _Cancel_BookingsState();
}

class _Cancel_BookingsState extends State<Cancel_Bookings> {

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
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Cancel_Admin.php"));
    if(response.statusCode==200){
      data=response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
          title: Text(" Cancel bookings"),
          centerTitle: true,
          backgroundColor: Colors.deepPurple.shade800,
        ),
        body: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),) : ListView.builder(
            itemCount: getUser.length,
            itemBuilder: (BuildContext context,int index){
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.all(mdheight * 0.017),
                shadowColor: Colors.deepPurple.shade800,
                surfaceTintColor: Colors.deepPurple.shade800,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(

                          children:[
                        Text((index+1).toString()+". ",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(getUser[index]["Name"],style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                      ]),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text("Booking Id : ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Expanded(child: Text(getUser[index]["Booking_Id"]),
                          )],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text("Reason : ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Expanded(child: Text(getUser[index]["Reason"]),
                          )],
                      ),
                      SizedBox(height: 10),
                      Row(
                      children: [
                      Text("Cancelation Date & Time : ",style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(getUser[index]["Cancelation_Time"]),
                      ]),
                      //Text("Booking Date & Time 17-11-2023,11:45 AM"),
                      SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(onPressed: (){
                            showDialog(context: context, builder: (context)
                            {
                              return Dialog(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.03),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: mdheight * 0.02),
                                          Padding(
                                            padding: EdgeInsets.only(left : mdwidth * 0.05, right: mdwidth * 0.01,),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children :[
                                                Text('Booking Id : '+getUser[index]["Booking_Id"]),
                                                SizedBox(height: mdheight * 0.01),
                                                Text('Payment Id : '+getUser[index]["Payment_Id"]),
                                                SizedBox(height: mdheight * 0.01),
                                                Text('Cancle Id : '+getUser[index]["Cancle_Id"]),
                                                SizedBox(height: mdheight * 0.01),
                                                Text('Refund Amount : '+getUser[index]["Refund_Amount"]),
                                                SizedBox(height: mdheight * 0.01),
                                                // const Text('Vehicle Description : This Is Fully Automated Car'),
                                                // SizedBox(height: mdheight * 0.01),
                                                // const Text('Rent Price: 500/day'),
                                                // SizedBox(height: mdheight * 0.01),
                                                // const Text('Availability : True'),
                                                // SizedBox(height: mdheight * 0.01),
                                              ],
                                            ),
                                          ),
                                          MaterialButton(onPressed: (){
                                            Navigator.pop(context);
                                          },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.02)),
                                              ),
                                              color: Colors.deepPurple.shade800,
                                              elevation: 5.0,
                                              child: const Text('Refund', style: TextStyle(color: Colors.white,),)),
                                          SizedBox(height: mdheight * 0.01),
                                        ]
                                    ),
                                  ));
                            });
                          },
                              color: Colors.deepPurple.shade800,
                              padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.02)),
                              ),
                              child: const Text('Proceed Refund', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            })
    );
  }
}
