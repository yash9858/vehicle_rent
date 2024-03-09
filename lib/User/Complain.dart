import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
class Complain extends StatefulWidget {
   final int v_id;
   Complain({super.key,required this.v_id});

  @override
  State<Complain> createState() => _ComplainState();
}

class _ComplainState extends State<Complain> {
  TextEditingController _complaintController = TextEditingController();
  String _selectedType = 'Booking Issue';
  var logindata;
  var data;
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
       // backgroundColor: Colors.transparent,
        title: Text("Complain",style: TextStyle(fontSize: mheight*0.030),),

        elevation: 0,

      ),
      body: isLoading ? Center(child: CircularProgressIndicator(color: Colors.white)) :Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            SizedBox(height: mheight*0.02),
            Text(
              'Describe your complaint:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: mheight*0.03),
            TextFormField(
             controller: _complaintController,
              maxLines: 5,
              validator: (val) {
                if (val!.isEmpty
                ) {
                  return "Use Proper Password ";
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type your complaint here...',
              ),
            ),
            SizedBox(height: mheight*0.05),
            Text(
              'Type of Complaint:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedType,
              onChanged: (newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
              items: ['Booking Issue', 'Vehicle Condition', 'Customer Service', 'Other']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ),
              )
                  .toList(),
            ),

          ],
        ),
      ),
      bottomNavigationBar:  Container(
        padding: EdgeInsets.only(left: 12,right: 12,bottom: 8),
        height: mheight*0.08,
        width: mwidth,
        child: MaterialButton(
          color: Colors.deepPurple.shade800,
          onPressed: _submit,
          child: Text("Submit Complain", style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }

Future<void> _submit() async {

  // if (form!.validate()) {
  //   setState(() {
  //     isLoading = true;
  //   });
  SharedPreferences s=await SharedPreferences.getInstance();
    final login_url = Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Insert_API/Complain_Insert.php");
    final response = await http
        .post(login_url, body: {
     "Complain":_complaintController.text,
      "Login_Id":s.getString('id'),
       "Vehicle_Id":widget.v_id,
       "Complain_Status":1


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



