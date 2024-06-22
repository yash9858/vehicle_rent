import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rentify/login_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  dynamic logindata;
  dynamic data;
  bool isLoading = false;
  bool visiblePass = true;
  bool visibleConfirm = true;

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Forget Password",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20
            )
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
     body:isLoading ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple)) :
     Form(
       key: formKey,
       child: SingleChildScrollView(
       child: Padding(
         padding: const EdgeInsets.all(16),
         child: Column(
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
                obscureText: visiblePass,
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
                  suffixIcon: IconButton(icon:Icon(visiblePass ? Icons.visibility
                      : Icons.visibility_off),
                    onPressed: (){
                      setState(() {
                        visiblePass =! visiblePass;
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
                  else if(val != passwordController.text){
                    return "Passwords Do Not Match";
                  }
                  return null;
                },
                obscureText: visibleConfirm,
                decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: mdheight * 0.025),
                  filled: true,
                  hintText: "Confirm Password ",
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(icon:Icon(visibleConfirm ? Icons.visibility
                      : Icons.visibility_off),
                    onPressed: (){
                      setState(() {
                        visibleConfirm =! visibleConfirm;
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
                child: const Text('Reset Password'),
                  ),
                ],
              ),
            ),
          )
        )
      );
  }

Future<void> _submit() async {
  final form = formKey.currentState;
  if (form!.validate()) {
    setState(() {
      isLoading = true;
    });
    final loginUrl = Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Update_API/Forget_Password.php");
    final response = await http
        .post(loginUrl, body: {
      "Email": emailController.text,
      "Password": passwordController.text
    });
    if (response.statusCode == 200) {
      logindata = jsonDecode(response.body);
      data = jsonDecode(response.body)['user'];
      setState(() {
        isLoading = false;
      });
      if (logindata['error'] == false) {
        Get.offAll(()=> const LoginPage());
      }else{
        Fluttertoast.showToast(
            msg: logindata['message'].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2
        );
      }
    }
  }}
}


