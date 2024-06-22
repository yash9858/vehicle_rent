import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Complain extends StatefulWidget {
    final String vid;
    const Complain({super.key,required this.vid});

  @override
  State<Complain> createState() => _ComplainState();
}

class _ComplainState extends State<Complain> {
  TextEditingController complaintController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedType = 'Booking Issue';
  dynamic logindata;
  dynamic data;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Complain", style: TextStyle(fontSize: mheight * 0.030),),
        elevation: 0,
      ),
      body: isLoading ? const Center(
          child: CircularProgressIndicator(color: Colors.white)) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: mheight * 0.02),
            const Text(
              'Describe your complaint:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: mheight * 0.03),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: complaintController,
                maxLines: 5,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Type your Complain here";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type your complaint here...',
                ),
              ),
            ),
            SizedBox(height: mheight * 0.05),
            const Text(
              'Type of Complaint:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedType,
              onChanged: (newValue) {
                setState(() {
                  _selectedType = newValue!;
                  complaintController.text = newValue;
                });
              },
              items: [
                'Booking Issue',
                'Vehicle Condition',
                'Customer Service',
                'Other'
              ].map<DropdownMenuItem<String>>(
                    (String value) =>
                    DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
              ).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
        height: mheight * 0.08,
        width: mwidth,
        child: MaterialButton(
          color: Colors.deepPurple.shade800,
          onPressed: _submit,
          child: const Text(
            "Submit Complain", style: TextStyle(color: Colors.white),),
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
          "https://road-runner24.000webhostapp.com/API/Insert_API/Complain_Insert.php");
      final response = await http
          .post(loginUrl, body: {
        "Complain": complaintController.text,
        "Login_Id": s.getString('id'),
        "Vehicle_Id": widget.vid,
        "Complain_Status": "1"
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
}