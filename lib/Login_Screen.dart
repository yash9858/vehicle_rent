// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentify/Admin/Admin_DashBoard.dart';
import 'package:rentify/Forget_Password.dart';
import 'package:rentify/User/Complete_Profile.dart';
import 'package:rentify/User/User_DashBoard.dart';
import 'Register_Screen.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  const LoginPage ({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var logindata;
  var data;
  bool isLoading = false;
  bool visible = true;

  @override
  Widget build(BuildContext context) {
     var size=MediaQuery.sizeOf(context);
    return isLoading ? Center(child: CircularProgressIndicator(color: Colors.deepPurple))
        :Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.deepPurple.shade400],
          ),
        ),
       child:Form(
         key: formKey,
         child: SingleChildScrollView(
         child: Padding(
           padding: EdgeInsets.symmetric(vertical: size.height* 0.01, horizontal: size.height * 0.03),
           child: Column(
             children: [
               Lottie.asset('assets/img/login.json',
                 height: size.height * 0.35,
               ),
               Text(
                 "Welcome Back!",
                 style: TextStyle(
                   fontWeight: FontWeight.w600,
                   fontSize: 18,
                   color: Colors.black.withOpacity(0.7),
                 ),
               ),
               SizedBox(height: size.height * 0.005),
               const Text(
                 "Log In Your Account",
                 style: TextStyle(
                   fontWeight: FontWeight.bold,
                   fontSize: 28,
                   color: Colors.black,
                 ),
               ),
               SizedBox(height: size.height * 0.025),
               TextFormField(
                 controller:emailController,
                 keyboardType: TextInputType.text,
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
                 decoration: InputDecoration(
                   contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                   filled: true,
                   hintText: "Email",
                   errorStyle: TextStyle(
                     color: Colors.black,
                     fontSize: 14,
                   ),
                   prefixIcon: const Icon(Icons.person),
                   fillColor: Colors.white,
                   border: OutlineInputBorder(
                     borderSide: BorderSide.none,
                     borderRadius: BorderRadius.circular(20),
                   ),
                 ),
               ),
               SizedBox(height: size.height * 0.025),
               TextFormField(
                 controller:passwordController,
                 obscureText: visible,
                 keyboardType: TextInputType.text,
                 validator: (val) {
                   if (val!.isEmpty
                       ) {
                     return "Use Proper Password ";
                   }
                   return null;
                 },
                 decoration: InputDecoration(
                   contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                   filled: true,
                   hintText: "Password",
                   errorStyle: TextStyle(
                     color: Colors.black,
                     fontSize: 14,
                   ),
                   prefixIcon: const Icon(Icons.key),
                   suffixIcon: IconButton(icon:Icon(visible ? Icons.visibility
                   : Icons.visibility_off),
                   onPressed: (){
                     setState(() {
                       visible =! visible;
                     });
                   },
                   ),
                   fillColor: Colors.white,
                   border: OutlineInputBorder(
                     borderSide: BorderSide.none,
                     borderRadius: BorderRadius.circular(20),
                   ),
                 ),
               ),
               SizedBox(height: size.height * 0.01),
               Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children:[
                     TextButton(onPressed: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> Forget_password()));
                     },
                       child: Text('Forget Password ?',
                           style: TextStyle(
                             color: Colors.black,
                             fontWeight: FontWeight.w600,
                             fontSize: size.height * 0.020,)),)
                   ]),
               SizedBox(height: size.height * 0.025),
               MaterialButton(
                 padding: EdgeInsets.zero,
                 onPressed: _submit,
                 child: Container(
                   alignment: Alignment.center,
                   height: size.height * 0.080,
                   decoration:  BoxDecoration(
                     boxShadow: const [
                       BoxShadow(
                         blurRadius: 45,
                         color: Color.fromRGBO(120, 37, 139, 0.25),
                       )
                     ],
                     borderRadius: BorderRadius.circular(35),
                     color: const Color.fromRGBO(225, 225, 225, 0.6),
                   ),
                   child: const Text(
                     "Login",
                     style: TextStyle(
                       color: Colors.black,
                       fontWeight: FontWeight.w800,
                       fontSize: 20,
                     ),
                   ),
                 ),
               ),
               SizedBox(height: size.height * 0.025),
               Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children:[
                     Text("Don't Have An Account?",
                         style: TextStyle(
                             color: Colors.black,
                             fontWeight: FontWeight.w500,
                             fontSize: size.height * 0.022)),
                     TextButton(onPressed: (){
                       Navigator.push(context , MaterialPageRoute(builder: (context) => const RegisterPage()));
                     },
                       child: Text('Sign Up',
                           style: TextStyle(
                             decoration: TextDecoration.underline,
                             decorationColor: const Color.fromRGBO(225, 225, 225, 0.9),
                             color: const Color.fromRGBO(225, 225, 225, 0.9),
                             fontSize: size.height * 0.023,)),)
                   ]),
             ],
           ),
         ),
       ),)

      ),
    );
  }

Future<void> _submit() async {
  final form = formKey.currentState;
  if (form!.validate()) {
    setState(() {
      isLoading = true;
    });
    final loginUrl = Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Insert_API/Checklogin.php");
    final response = await http
        .post(loginUrl, body: {
      "Email": emailController.text,
      "Password": passwordController.text
    });
    if (response.statusCode == 200) {
      logindata = jsonDecode(response.body);
      data = jsonDecode(response.body)['user'];
      print(data);
      setState(() {
        isLoading = false;
      });
      if (logindata['error'] == false) {
        SharedPreferences setpreference = await SharedPreferences.getInstance();
        setpreference.setString('id', data['Login_Id'].toString());
        setpreference.setString('uname', data['User_Name'].toString());
        setpreference.setString('email', data['Email'].toString());
        setpreference.setString('Role', data['Role'].toString());
        setpreference.setString('status', data['Status'].toString());
        setpreference.setString('vid', data['Vehicle_Id'].toString());
        if(data["Role"]=="1")
          {
           if(data["Status"] == "1")
             {
               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>  UserDasboard()), (Route<dynamic> route) => false);
             }
           else
             {
                 Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => complete_Profile()), (Route<dynamic> route) => false);
             }
          }
        else
          {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Admin_DashBoard()), (Route<dynamic> route) => false);
          }
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

