import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rentify/User/payment_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SelectDate extends StatefulWidget {
  final int num;
  final String vid;
  final String type;
  const SelectDate({super.key, required this.num, required this.vid,required this.type});

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {

  TextEditingController startdate = TextEditingController();
  TextEditingController returndate = TextEditingController();
  TextEditingController starttime = TextEditingController();
  TextEditingController returntime = TextEditingController();
  final _formKey2 = GlobalKey<FormState>();
  dynamic logindata;

  TextEditingController address = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading=true;
  dynamic data;
  dynamic data2;
  dynamic data3;
  dynamic data4;
  dynamic data5;
  List list= [];
  dynamic getUser;
  dynamic getUser2;
  dynamic getUser3;
  dynamic getUser4;

  @override
  void initState(){
    super.initState();
    vDet();
  }

  Future vDet() async{
    setState(() {
      isLoading = true;
    });
    final loginUrl = Uri.parse(
        "https://road-runner24.000webhostapp.com/API/User_Fetch_API/Select_Fetch_Vehicle.php");
    final response = await http
        .post(loginUrl, body: {
      "Vehicle_Type": widget.type,
      "Vehicle_Id":widget.vid,
    });

    if(response.statusCode==200) {
      data = response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
        addressFetch();
        ratings();
      });
    }
  }

  Future addressFetch() async{
    setState(() {
      isLoading=true;
    });
    SharedPreferences share=await SharedPreferences.getInstance();
    http.Response response= await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/User_Fetch_API/Address_Booking.php"),
        body: {'Login_Id':share.getString('id')});
    if(response.statusCode==200) {
      data2 = response.body;
      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data2!)["users"];
        address.text = getUser2[0]["Address"];
      });
    }
  }

  Future addressUpdate() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    final form = _formKey.currentState;
    if (form!.validate()) {
      final loginUrl = Uri.parse(
          "https://road-runner24.000webhostapp.com/API/Update_API/Address_Booking.php");
      final response = await http
          .post(loginUrl, body: {
        "Login_Id": share.getString('id'),
        "Address": address.text,
      });
      if (response.statusCode == 200) {
        data3 = jsonDecode(response.body);
        getUser3 = jsonDecode(response.body)["users"];
        setState(() {
          isLoading = false;
        });
        if (data3['error'] == false) {
          Fluttertoast.showToast(
              msg: data3['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
        }else{
          Fluttertoast.showToast(
              msg: data3['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
        }
      }
    }
  }

  Future ratings() async{
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Car_Details_Feedback.php",
    ),body: {'Vehicle_Id' : widget.vid});

    if(response.statusCode==200) {
      data4 = response.body;

      setState(() {
        isLoading=false;
        getUser4=jsonDecode(data4!)["users"];
        for(var data in getUser4){
          list.add(double.parse(data["Ratings"]));
        }
      }
      );
    }
  }

  double avg()
  {
    if(list.isEmpty) {
      return 0.0;
    }
    double sum = 0.0;
    for(var rating in list)
    {
      sum += rating;
    }
    return sum /list.length;
  }

  Future<void> _submit() async {
    SharedPreferences s=await SharedPreferences.getInstance();
    final form = _formKey.currentState;
    if (form!.validate()) {
      final loginUrl = Uri.parse(
          "https://road-runner24.000webhostapp.com/API/Insert_API/Booking_Insert.php");
      final response = await http
          .post(loginUrl, body: {
        "Start_Date": (pickupDate.year).toString()+"-"+(pickupDate.month).toString()+"-"+(pickupDate.day).toString(),
        "Start_Time": (pickupTime.hour).toString()+":"+(pickupTime.minute).toString(),
        "Return_Date": (returnDate.year).toString()+"-"+(returnDate.month).toString()+"-"+(returnDate.day).toString(),
        "Return_Time": (returnTime.hour).toString()+":"+(returnTime.minute).toString(),
        "Vehicle_Id": widget.vid,
        "Login_Id":s.getString('id'),
      });
      if (response.statusCode == 200) {
        logindata = jsonDecode(response.body);
        data5 = jsonDecode(response.body)['user'];
        setState(() {
          isLoading = false;
        });
        if (logindata['error'] == false) {
          Fluttertoast.showToast(
              msg: logindata['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
          Get.to(()=>  PaymentPage(
            v2id: widget.vid,price:getUser[0]["Rent_Price"],
            starty: (pickupDate.year).toString(),
            startm: (pickupDate.month).toString(),
            startd: (pickupDate.day).toString(),
            startt:(pickupTime.hour).toString(),
            returny: (returnDate.year).toString(),
            returnm: (returnDate.month).toString(),
            returnd: (returnDate.day).toString(),
            returnt:(returnTime.hour).toString(),
          ));
        }else{
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

  DateTime pickupDate=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  TimeOfDay pickupTime = TimeOfDay(hour: DateTime.now().hour+2,minute: 00);
  DateTime returnDate=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  TimeOfDay returnTime = TimeOfDay(hour: DateTime.now().hour+3,minute: 00);

  void pickDate(){
    showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month , DateTime.now().day), lastDate: DateTime(2025), initialDate: pickupDate,).then((value){
      setState(() {
        pickupDate=value!;
      });
    });
  }

  void rDate(){
    showDatePicker(
      context: context,
      firstDate: DateTime(pickupDate.year, pickupDate.month , pickupDate.day), lastDate: DateTime(2025), initialDate: pickupDate,).then((value){
      setState(() {
        returnDate=value!;
      });
    });
  }

  void pickTime(){
    showTimePicker(
      context: context, initialTime: TimeOfDay.now().replacing(hour: DateTime.now().hour+2 , minute: 00),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },).then((value){
      setState(() {
        if(DateTime.now().hour + 2 > value!.hour){
          Fluttertoast.showToast(
            msg: "Please select correct Time",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
          );
        }
        else{
          pickupTime=value;
          returnTime = TimeOfDay.now().replacing(hour: pickupTime.hour+1, minute: 00,
          );
        }
      });
    });
  }

  void rTime(){
    showTimePicker(context: context, initialTime: TimeOfDay.now().replacing(hour: pickupTime.hour+1, minute: 00) ,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },).then((value){
      setState(() {
        if(pickupTime.hour + 1 > value!.hour){
          Fluttertoast.showToast(
            msg: "Please select correct Return Time",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
          );
        }
        else{
          returnTime=value;
          returnTime = TimeOfDay.now().replacing(hour: returnTime.hour, minute: 00,
          );
        }
      });
    });
  }

  dynamic sDate;
  dynamic sTime;
  dynamic eDate;
  dynamic eTime;

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Select Date and Time",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: mheight*0.030),),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
          : SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top:15,left: 15,right: 15,),
            child: Form(
              key: _formKey2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network(getUser[0]["Vehicle_Image"],fit: BoxFit.contain,
                        height: mheight*0.15,width: mwidth*0.4,
                      ),
                      SizedBox(width: mwidth*0.02,),
                      Expanded(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
                                  : Container(
                                  padding: const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.pink.shade50,
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: Text(getUser[0]["Category_Name"])),
                              isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
                                  : Row(
                                children: [
                                  Text(avg().toStringAsFixed(2)),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 18,
                                  )
                                ],
                              )
                            ],),
                          SizedBox(height: mheight*0.01,),
                          Text(getUser[0]["Vehicle_Name"],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          SizedBox(height: mheight*0.03,),
                          Row(
                            children: [
                              const Text(
                                "₹",
                                style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),),
                              Text(
                                getUser[0]["Rent_Price"],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Text("/day"),
                            ],
                          ),
                        ],
                      ))
                    ],
                  ),
                  Divider(height: mheight*0.07,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Pick Up Date and Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                      SizedBox(height:mheight*0.025),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width:mwidth*0.4,
                              padding:const EdgeInsets.only(left: 10,right: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:Colors.grey.shade100,
                                  border: Border.all(width: 1)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(pickupTime.format(context).toString(),style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                  IconButton(onPressed: pickTime, icon: Icon(Icons.timer_outlined,color: Colors.deepPurple.shade400,))
                                ],
                              )),
                          Container(
                            width:mwidth*0.4,
                            padding:const EdgeInsets.only(left: 5,),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:Colors.grey.shade100,
                                border: Border.all(width: 1)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(DateFormat('d MMM yy').format(pickupDate),style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                IconButton(onPressed: pickDate, icon: Icon(Icons.calendar_month_outlined,color: Colors.deepPurple.shade400,))
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Divider(height: mheight*0.05,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Return  Date and Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                      SizedBox(height:mheight*0.025),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width:mwidth*0.4,
                            padding:const EdgeInsets.only(left: 10,right: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:Colors.grey.shade100,
                                border: Border.all(width: 1)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(returnTime.format(context).toString(),style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                IconButton(onPressed: rTime, icon: Icon(Icons.timer_outlined,color: Colors.deepPurple.shade400,))
                              ],
                            ),
                          ),
                          Container(
                            width:mwidth*0.4,
                            padding:const EdgeInsets.only(left: 5,),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade100,
                                border: Border.all(width: 1)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(DateFormat('d MMM yy').format(returnDate),style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                                IconButton(onPressed: rDate, icon: Icon(Icons.calendar_month_outlined,color: Colors.deepPurple.shade400,))
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Divider(height: mheight*0.04,),
                  const Text("Address",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  SizedBox(height: mheight*0.01,),
                  Form(
                    key : _formKey,
                    child: TextFormField(
                      controller: address,
                      keyboardType: TextInputType.multiline,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return " Please Enter the Address  ";
                        }
                        return null;
                      },
                      maxLines: 4,
                      cursorColor: Colors.deepPurple.shade800,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: "Enter Your Delivary Address",
                          focusedBorder:OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.deepPurple.shade800)
                          ),
                          border: const OutlineInputBorder()
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 5,left: 10,right: 10),
        width: double.infinity,
        height: mheight*0.08,
        child: ElevatedButton(
          onPressed: (){
            addressUpdate();
            _submit();
          },
          child: const Text("Payment",style: TextStyle(fontSize: 15),),
        ),
      ),
    );
  }
}