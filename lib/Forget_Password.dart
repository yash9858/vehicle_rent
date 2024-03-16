import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


class Forget_password extends StatefulWidget {
  const Forget_password({super.key});

  @override
  State<Forget_password> createState() => _Forget_passwordState();
}

class _Forget_passwordState extends State<Forget_password> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var logindata;
  var data;
  bool isLoading = false;
  bool visiblepass = true;
  bool visibleconfirm = true;

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;

      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Forget Password",
            style: TextStyle(color: Colors.black,fontSize: 20),),

          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
     body:isLoading ? const Center(child: CircularProgressIndicator(color: Colors.black)) :
     Form(
       key: formKey,
       child: Padding(
         padding: EdgeInsets.all(16),
         child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              TextFormField(
                controller: emailController,
                validator: (val) {
                  if (val!.isEmpty
                  ) {
                    return "Email must not be empty";
                  } else {
                    if (RegExp(
                        r"^[a-zA-Z0-9]+[^#$%&*]+[a-zA-Z0-9]+@[a-z]+\.[a-z]{2,3}")
                        .hasMatch(val)) {
                      return null;
                    } else {
                      return "Enter a valid Email";
                    }
                  }
                },
                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: mdheight * 0.025),
                  filled: true,
                  hintText: "Enter Your Email ",
                  prefixIcon: const Icon(Icons.email_outlined),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),),
                keyboardType: TextInputType.emailAddress,

              ),

              SizedBox(height: mdheight*0.04),
              TextFormField(
                obscureText: visiblepass,
                 controller: passwordController,
                validator: (val) {
                  if (val!.isEmpty
                  ) {
                    return "Use Proper Password ";
                  }
                  return null;
                },
                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: mdheight * 0.025),
                  filled: true,
                  hintText: "New Password ",
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(icon:Icon(visiblepass ? Icons.visibility
                      : Icons.visibility_off),
                    onPressed: (){
                      setState(() {
                        visiblepass =! visiblepass;
                      });
                    },
                  ),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),),
                keyboardType: TextInputType.text,

              ),
              SizedBox(height: mdheight*0.04),
              TextFormField(
                validator: (val) {
                  if (val!.isEmpty
                  ) {
                    return "Enter Confirm Password ";
                  }
                  else if(val != passwordController){
                    return "Password Are Not Match";
                  }
                },
                obscureText: visibleconfirm,
                // controller: emailController,
                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: mdheight * 0.025),
                  filled: true,
                  hintText: "Confirm Password ",
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(icon:Icon(visibleconfirm ? Icons.visibility
                      : Icons.visibility_off),
                    onPressed: (){
                      setState(() {
                        visibleconfirm =! visibleconfirm;
                      });
                    },
                  ),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),),
                keyboardType: TextInputType.text,

              ),
              SizedBox(height: mdheight*0.04),
              ElevatedButton(
              onPressed: _submit,
                child: Text('Reset Password'),
              ),
            ],
          ),
       ),
     )
     );

  }

Future<void> _submit() async {
  final form = formKey.currentState;
  if (form!.validate()) {
    setState(() {
      isLoading = true;
    });
    final login_url = Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Update_API/Forget_Password.php");
    final response = await http
        .post(login_url, body: {
      "Email": emailController.text,
      "Password": passwordController.text
    });
    if (response.statusCode == 200) {
      logindata = jsonDecode(response.body);
      data =
      jsonDecode(response.body)['user'];
      print(data);
      setState(() {
        isLoading = false;
      });
      if (logindata['error'] == false) {
       // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Home()), (Route<dynamic> route) => false);
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
}


