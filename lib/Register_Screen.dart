import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'Login_Screen.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController NameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ConfirmpasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var logindata;
  var data;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body:isLoading ? Center(child: CircularProgressIndicator(color: Colors.white)) : Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.deepPurple.shade400],
          ),
        ),
        child:Form(
          key: _formKey,
          child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01, horizontal: size.height* 0.03),
            child: Column(
              children: [
                Lottie.asset('assets/img/register.json',
                  height: size.height * 0.32,
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
                  "Create Account",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: NameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter name";
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                    filled: true,
                    hintText: "UserName",
                    prefixIcon: const Icon(Icons.person),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  controller: emailController,
                  validator: (val) {
                    if (val!.isEmpty )
                       {
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

                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                    filled: true,
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  controller: passwordController,
                  validator: (val) {
                    if (val!.isEmpty
                        ) {
                      return "Use Proper Password ";
                    }
                  },
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                    filled: true,
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  controller: ConfirmpasswordController,
                  validator: (val) {
                    if (val!.isEmpty
                      ) {
                      return " Password not same ";
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                    filled: true,
                    hintText: "Confirm Password",
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: const Icon(Icons.remove_red_eye),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.025),
                MaterialButton(
                  padding: EdgeInsets.zero,
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
                      "Create Account",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),

                    ),
                  ),
                onPressed: _submit,
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Text("You Have Already An Account?",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: size.height * 0.022)),
                      TextButton(onPressed: (){
                        Navigator.push(context , MaterialPageRoute(builder: (context) => const LoginPage()));
                      },
                        child: Text('Sign In',
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
    final form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });
      final login_url = Uri.parse(
          "https://road-runner24.000webhostapp.com/API/Insert_API/Login.php");
      final response = await http
          .post(login_url, body: {
        "Email": emailController.text,
        "Password": passwordController.text,
        "User_Name": NameController.text,
        "Role": "1",
        "Status": "0",

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
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false);
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