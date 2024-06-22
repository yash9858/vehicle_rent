import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CancelBookings extends StatefulWidget {
  const CancelBookings({super.key});

  @override
  State<CancelBookings> createState() => _CancelBookingsState();
}

class _CancelBookingsState extends State<CancelBookings> {

  dynamic logindata;
  String? data;
  dynamic getUser;
  String? data2;
  dynamic getUser2;
  bool isLoading = true;
  dynamic feed;

  @override
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
        getdata2();
      });
    }
  }

  Future getdata2() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Refund_Pending.php"));
    if(response.statusCode==200){
      data2=response.body;
      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data2!)["users"];
        feed=jsonDecode(data2!)["Cancle_Id"];
      });
    }
  }

  String formatDate(String date)
  {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy & HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(" Cancel bookings"),
            centerTitle: true,
            backgroundColor: Colors.deepPurple.shade800,
            bottom: const TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                tabs: [
                  Tab(
                    text: 'Cancel List',
                  ),
                  Tab(
                    text: 'Refund List',
                  ),
                ]),
          ),

          body: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),) :
          TabBarView(
            children: [
              ListView.builder(
                  itemCount: getUser.length,
                  itemBuilder: (BuildContext context,int index){
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(mdheight * 0.017),
                      shadowColor: Colors.deepPurple.shade800,
                      surfaceTintColor: Colors.deepPurple.shade800,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                children:[
                                  Text("${index+1}. ",style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text(getUser[index]["Name"],style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                                ]),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                  const Text("Booking Id : ",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Expanded(child: Text(getUser[index]["Booking_Id"]),
                                )],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                  const Text("Reason : ",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Expanded(child: Text(getUser[index]["Reason"]),
                                )],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text("Cancelation Date & Time : ",style: TextStyle(fontWeight: FontWeight.bold),),
                                Text(formatDate(getUser[index]["Cancelation_Time"])),
                            ]),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    );
                  }),

              feed==null?
              ListView.builder(
                  itemCount: getUser2.length,
                  itemBuilder: (BuildContext context,int index){
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(mdheight * 0.017),
                      shadowColor: Colors.deepPurple.shade800,
                      surfaceTintColor: Colors.deepPurple.shade800,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                children:[
                                    Text("${index+1}. ",style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    Text(getUser2[index]["Name"],style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                                ]),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                  const Text("Booking Id : ",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Expanded(child: Text(getUser2[index]["Booking_Id"]),
                                )],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                  const Text("Reason : ",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Expanded(child: Text(getUser2[index]["Reason"]),
                                )],
                            ),
                            const SizedBox(height: 10),
                            Row(
                                children: [
                                    const Text("Cancelation Date & Time : ",style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text(formatDate(getUser2[index]["Cancelation_Time"])),
                                ]),
                            const SizedBox(height: 16),
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
                                                      Row(
                                                        children: [
                                                          const Text('Booking Id : '),
                                                          Text(getUser2[index]["Booking_Id"]),
                                                        ],
                                                      ),
                                                      SizedBox(height: mdheight * 0.01),
                                                      Row(
                                                        children: [
                                                          const Text('Payment Id : '),
                                                          Text(getUser2[index]["Payment_Id"]),
                                                        ],
                                                      ),
                                                      SizedBox(height: mdheight * 0.01),
                                                      Row(
                                                        children: [
                                                          const Text('Cancle Id : '),
                                                          Text(getUser2[index]["Cancle_Id"]),
                                                        ],
                                                      ),
                                                      SizedBox(height: mdheight * 0.01),
                                                      Row(
                                                        children: [
                                                          const Text('Refund Amount : '),
                                                          Text(getUser2[index]["Refund_Amount"]),
                                                        ],
                                                      ),
                                                      SizedBox(height: mdheight * 0.01),
                                                    ],
                                                  ),
                                                ),
                                                MaterialButton(onPressed: (){
                                                 _submit2(index).whenComplete(() => Get.off(()=> const CancelBookings()));
                                                 _submit2(index).whenComplete(() => Get.back());
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
                  :const Center(
                child:
                Text("No Data found"),
              )
            ],
          )
      ),
    );
  }

Future<void> _submit2(int index) async {
  final loginUrl = Uri.parse(
      "https://road-runner24.000webhostapp.com/API/Update_API/Refund_Status_update.php");
  final response = await http
      .post(loginUrl, body: {
    "Cancle_Id": getUser2[index]["Cancle_Id"],
  });
  if (response.statusCode == 200) {
    setState(() {
      isLoading = false;
    });
    if (logindata['error'] == false) {
      Get.back();
    }
    else{
      Fluttertoast.showToast(
          msg: logindata['message'].toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2
      );
    }
  }
  }
}