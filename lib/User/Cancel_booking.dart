import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class Cancel_booking_user extends StatefulWidget {
 //  final String Booking_id;
  String?  p_id;
  String? b_id;
   Cancel_booking_user({super.key,required this.p_id, required this.b_id});

  @override
  State<Cancel_booking_user> createState() => _Cancel_bookingState();
}

class _Cancel_bookingState extends State<Cancel_booking_user> {
  TextEditingController _cancel = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var logindata;
  var data;
  bool isLoading = false;

  var selectedOption;
  var Reason = ['Schedule change',
    'Book Another Car',
    'Found a Better Alternative',
    'Want to Book another car',
    'My Reason is not listed',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery
        .sizeOf(context)
        .height;
    var mwidth = MediaQuery
        .sizeOf(context)
        .width;
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

      body: isLoading
          ? Center(
          child: CircularProgressIndicator(color: Colors.deepPurple))
          : SingleChildScrollView(
        physics: BouncingScrollPhysics(),


        child: Container(
          padding: EdgeInsets.only(top: 5, right: 8, left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 19),
                child: Text("Please Select the reason for cancellation:",
                  style: TextStyle(color: Colors.grey, fontSize: 15),),
              ),
              SizedBox(height: mheight * 0.02,),

              for (String option in [
                'Schedule change',
                'Book Another Car',
                'Found a Better Alternative',
                'Want to Book another car',
                'My Reason is not listed',
                'Other'
              ])

                RadioListTile(
                  title: Text(option, style: TextStyle(fontSize: 18),),
                  value: option,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value.toString();
                    });
                  },
                ),
              // SizedBox(height: 20),
              // Text('Selected Option: $selectedOption'),

              Divider(height: mheight * 0.04,),

              Container(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: Form(
                  key: _formKey,
                  child: TextFormField(

                    controller: _cancel,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    cursorColor: Colors.deepPurple.shade800,
                    validator: (val) {
                      if (val!.isEmpty
                      ) {
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

              //button
              SizedBox(height: mheight * 0.08,),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 12, right: 12, bottom: 8),
        height: mheight * 0.08,
        width: mwidth,
        child: MaterialButton(
          color: Colors.deepPurple.shade800,
          onPressed: _submit,

          child: Text("Cancel Ride", style: TextStyle(color: Colors.white),),
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
      final login_url = Uri.parse(
          "https://road-runner24.000webhostapp.com/API/Insert_API/Cancelation_Insert.php");
      final response = await http
          .post(login_url, body: {
        "Reason": _cancel.text,
        "Login_Id": s.getString('id'),
        "Booking_Id": widget.b_id,

        "Payment_Id": widget.p_id,
      });
      if (response.statusCode == 200) {
        logindata = jsonDecode(response.body);
        data =
        jsonDecode(response.body)['user'];
        print(logindata);
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
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) => ()),
          //         (route) => false);
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
}




