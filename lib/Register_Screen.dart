import 'package:flutter/material.dart';
import 'DashBoard_Screen.dart';
import 'Login_Screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
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
                      'Registration ',
                      style: TextStyle(
                          color: Colors.white, fontSize: mdheight * 0.050),
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                    Text(
                      'Create Account',
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
                            topRight: Radius.circular(mdheight * 0.14)),
                      ),
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: mdheight * 0.03,
                              right: mdheight * 0.03,
                              top: mdheight * 0.12),
                          child: SingleChildScrollView(
                              child: Column(children: [
                                Center(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        hintText: 'Enter Username',
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20)
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(height: mdheight * 0.020),
                                Center(
                                  child: TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        hintText: 'Enter Email',
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20)
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(height: mdheight * 0.020),
                                Center(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock),
                                        fillColor: Colors.grey.shade100,
                                        filled: true,
                                        hintText: 'Enter Password',
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20)
                                        )
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
                                        hintText: 'Enter Confirm Password',
                                        suffixIcon: Icon(Icons.remove_red_eye_rounded),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20)
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(height: mdheight * 0.040),
                                Center(
                                    child: MaterialButton(
                                        onPressed: () {
                                          // ignore: non_constant_identifier_names
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                  const HomePage()));
                                        },
                                        child: Container(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.05,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: mdwidth * 0.035),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      mdheight * 0.025),
                                              color:
                                                  Colors.deepPurple.shade800),
                                          child: Center(
                                            child: Text('Create Account',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: mdheight * 0.022,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ))),
                                SizedBox(
                                  height: mdheight * 0.03,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("You have Already An Account?",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: mdheight * 0.021)),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginPage()));
                                        },
                                        child: Text('Sign In',
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.deepPurple,
                                              fontSize: mdheight * 0.020,
                                            )),
                                      )
                                    ])
                              ])))))
            ])));
  }
}
