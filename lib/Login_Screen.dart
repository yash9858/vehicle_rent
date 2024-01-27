import 'package:flutter/material.dart';
import 'package:rentify/Admin/Admin_DashBoard.dart';
import 'package:sign_button/sign_button.dart';
import 'DashBoard_Screen.dart';
import 'Register_Screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
        body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Colors.deepPurple.shade900,
              Colors.deepPurple.shade800,
              Colors.deepPurple.shade400
            ])),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: mdheight * 0.09),
              Padding(
                padding: EdgeInsets.only(
                    bottom: mdheight * 0.02, left: mdheight * 0.025),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white, fontSize: mdheight * 0.050),
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                          color: Colors.white, fontSize: mdheight * 0.020),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(mdheight * 0.14)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: mdheight * 0.03,
                      right: mdheight * 0.03,
                      top : mdheight * 0.12,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                        children: [
                          Center(
                          child: TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: 'Enter Username',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                ),
                            ),
                          ),
                        ),
                      SizedBox(height: mdheight * 0.020),
                      Center(
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.vpn_key_rounded),
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: 'Enter Password',
                              suffixIcon: Icon(Icons.remove_red_eye_rounded),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: mdheight * 0.010),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomePage()));
                              },
                              child: Text('Forget Password ?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: mdheight * 0.020,
                                  )),
                            )
                          ]),
                      SizedBox(height: mdheight * 0.03),
                      Center(
                        child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.050,
                            width: MediaQuery.sizeOf(context).width * 0.60,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(mdheight * 0.025),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Admin_DashBoard()));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple.shade800,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(mdheight * 0.50),
                                  )),
                              child: Text('Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: mdheight * 0.025,
                                      fontWeight: FontWeight.bold)),
                            )),
                      ),
                      SizedBox(height: mdheight * 0.04),
                      Text('Login With Social Media',
                          style: TextStyle(
                              color: Colors.black, fontSize: mdheight * 0.026)),
                      SizedBox(height: mdheight * 0.04),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SignInButton.mini(
                                buttonType: ButtonType.apple, onPressed: () {}),
                            SignInButton.mini(
                                buttonType: ButtonType.google,
                                onPressed: () {}),
                            SignInButton.mini(
                                buttonType: ButtonType.facebook,
                                onPressed: () {}),
                          ]),
                      SizedBox(
                        height: mdheight * 0.04,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't Have An Account?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: mdheight * 0.021)),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage()));
                              },
                              child: Text('Sign Up',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.deepPurple,
                                    fontSize: mdheight * 0.020,
                                  )),
                            )
                          ])
                    ]),
                  ),
                ),
              ))
            ])));
  }
}
