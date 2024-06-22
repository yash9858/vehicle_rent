import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rentify/login_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool visiblePass = true;
  bool visibleConfirm = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:isLoading ? const Center(
          child: CircularProgressIndicator(color: Colors.white)) : Container(
          height: double.maxFinite,
          decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.deepPurple.shade400],
          ),
        ),
        child: Form(
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
                  controller: nameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please Enter name";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                    filled: true,
                    errorStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
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
                      }
                      else {
                        return "Enter a valid Email";
                      }
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                    filled: true,
                    errorStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
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
                    if (val!.isEmpty) {
                      return "Enter Password ";
                    }
                    else if (val.length >= 20) {
                      return "Password is too long (max 20 characters)";
                    }
                    return null;
                  },
                  obscureText: visiblePass,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                    filled: true,
                    errorStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock),
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
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  obscureText: visibleConfirm,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter Confirm Password ";
                    }
                    else if (val != passwordController.text) {
                      return "Passwords Do Not Match";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                    filled: true,
                    errorStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    hintText: "Confirm Password",
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
                    ),
                  ),
                ),
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
                      "Create Account",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Text("You Have Already An Account?",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: size.height * 0.020)),
                      TextButton(onPressed: (){
                        Get.to(()=> const LoginPage());
                      },
                        child: Text('Sign In',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: const Color.fromRGBO(225, 225, 225, 0.9),
                              color: const Color.fromRGBO(225, 225, 225, 0.9),
                              fontSize: size.height * 0.023,)),)
                    ]
                ),
              ],
            ),
          ),
        ),
        )
      ),
    );
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });
      final loginUrl = Uri.parse(
          "https://road-runner24.000webhostapp.com/API/Insert_API/Login.php");
      final response = await http
          .post(loginUrl, body: {
        "Email": emailController.text,
        "Password": passwordController.text,
        "User_Name": nameController.text,
        "Role": "1",
        "Status": "0",
      });
      if (response.statusCode == 200) {
        dynamic loginData;
        loginData = jsonDecode(response.body);
        if (kDebugMode) {
          print(loginData);
        }
        setState(() {
          isLoading = false;
        });
        if (loginData['error'] == false) {
          Fluttertoast.showToast(
              msg: loginData['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
          Get.offAll(const LoginPage());
        }else{
          Fluttertoast.showToast(
              msg: loginData['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
        }
      }
    }
  }
}