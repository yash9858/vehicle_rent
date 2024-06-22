import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CancelBookingUser extends StatefulWidget {
  final String?  pid;
  final String? bid;
  final String amount;
  const CancelBookingUser({super.key,required this.pid, required this.bid,required this.amount});

  @override
  State<CancelBookingUser> createState() => _CancelBookingState();
}

class _CancelBookingState extends State<CancelBookingUser> {
  TextEditingController cancel = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  dynamic logindata;
  dynamic data;
  bool isLoading = false;
  dynamic selectedOption;
  dynamic reason = [
    'Schedule change',
    'Book Another Car',
    'Found a Better Alternative',
    'Want to Book another car',
    'My Reason is not listed',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cancel Booking", style: TextStyle(color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: mheight * 0.030),),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading ? const Center(
          child: CircularProgressIndicator(color: Colors.deepPurple))
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(top: 5, right: 8, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: mheight * 0.01,),
              const Padding(
                padding: EdgeInsets.only(left: 19),
                child: Text("Note : If You Are Cancel Ride Than 10% Deduct In Your Refund Amount",
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),),
              ),
              SizedBox(height: mheight * 0.04,),
              const Padding(
                padding: EdgeInsets.only(left: 19),
                child: Text("Please Select the reason for cancellation:",
                  style: TextStyle(color: Colors.grey, fontSize: 15),),
              ),
              SizedBox(height: mheight * 0.02,),
              for (String option in reason)
                RadioListTile(
                  title: Text(option, style: const TextStyle(fontSize: 18),),
                  value: option,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value.toString();
                      cancel.text =value.toString();
                    });
                  },
                ),
              Divider(height: mheight * 0.04,),
              Container(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: cancel,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    cursorColor: Colors.deepPurple.shade800,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Type your Cancel Reason here";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: "Enter Your Reason",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.deepPurple.shade800)
                        ),
                        border: const OutlineInputBorder()
                    ),
                  ),
                ),
              ),
              SizedBox(height: mheight * 0.08,),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
        height: mheight * 0.08,
        width: mwidth,
        child: MaterialButton(
          color: Colors.deepPurple.shade800,
          onPressed: (){_submit();_submit2();},
          child: const Text("Cancel Ride", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });
      SharedPreferences s = await SharedPreferences.getInstance();
      final loginUrl = Uri.parse(
          "https://road-runner24.000webhostapp.com/API/Insert_API/Cancelation_Insert.php");
      final response = await http
          .post(loginUrl, body: {
        "Reason": cancel.text,
        "Login_Id": s.getString('id'),
        "Booking_Id": widget.bid,
        "Refund_Amount":widget.amount,
        "Refund_Status":"1",
        "Payment_Id": widget.pid,
      });
      if (response.statusCode == 200) {
        logindata = jsonDecode(response.body);
        data = jsonDecode(response.body)['user'];
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
        } else {
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

Future<void> _submit2() async {
    final loginUrl = Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Update_API/Booking_Status_update.php");
    final response = await http
        .post(loginUrl, body: {
      "Booking_Id": widget.bid,
    });
    if (response.statusCode == 200) {
      logindata = jsonDecode(response.body);
      data = jsonDecode(response.body)['user'];
      setState(() {
        isLoading = false;
      });
      if (logindata['error'] == false) {
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