import 'package:flutter/material.dart';
import 'package:rentify/Admin/Admin_DashBoard.dart';
import 'Forget_Password.dart';
import 'Register_Screen.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.deepPurple],
          ),
        ),
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
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                    filled: true,
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.person),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.025),
                TextField(
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                    filled: true,
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.key),
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
                        Navigator.push(context , MaterialPageRoute(builder: (context) => const Forget_password()));
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
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Admin_DashBoard()));
                  },
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
        ),
      ),
    );
  }
}
