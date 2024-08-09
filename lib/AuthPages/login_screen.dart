import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:rentify/AuthPages/forget_password.dart';
import 'package:rentify/AuthPages/register_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rentify/Admin/admin_dashboard.dart';
import 'package:rentify/User/ProfilePages/complete_profile.dart';
import 'package:rentify/User/HomePages/user_dash_board.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var isPasswordVisible = true.obs;

  Future<void> login() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      isLoading.value = true;

      try{
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email:emailController.text.toString(),
          password: passwordController.text.toString(),
        );
        DocumentSnapshot userDoc= await firestore.collection("Users").doc(userCredential.user!.email).get();

        if (userDoc.exists){
          Map<String ,dynamic> userData = userDoc.data() as Map < String , dynamic >;

          if (userData["Role"] == "Admin"){
            Get.offAll(() => const AdminDashBoard());
          }
          else{
            if(userData["Status"] == "1"){
              Get.offAll(() => const UserDashboard());
            }
            else{
              Get.offAll(() => const CompleteProfile());
            }
          }
        }
        else{
          Fluttertoast.showToast(
              msg: "User Not Found",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
          isLoading.value = false;
        }
      }
      on FirebaseAuthException catch(e){
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2
        );
        isLoading.value = false;
      }
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible(!isPasswordVisible.value);
  }
}

class LoginPage extends StatelessWidget {

  final LoginController loginController = Get.put(LoginController());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => loginController.isLoading.value
            ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
            : Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.deepPurple.shade400],
            ),
          ),
          child: Form(
            key: loginController.formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: Get.size.height * 0.01, horizontal: Get.size.height * 0.03),
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/img/login.json',
                      height: Get.size.height * 0.35,
                    ),
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: Get.size.height * 0.005),
                    const Text(
                      "Log In Your Account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: Get.size.height * 0.025),
                    TextFormField(
                      controller: loginController.emailController,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val!.isEmpty) {
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
                        contentPadding: EdgeInsets.symmetric(vertical: Get.size.height * 0.025),
                        filled: true,
                        hintText: "Email",
                        errorStyle: const TextStyle(
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
                    SizedBox(height: Get.size.height * 0.025),
                    Obx(() => TextFormField(
                      controller: loginController.passwordController,
                      obscureText: loginController.isPasswordVisible.isTrue,
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Use Proper Password ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: Get.size.height * 0.025),
                        filled: true,
                        hintText: "Password",
                        errorStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.key),
                        suffixIcon: IconButton(
                          icon: Icon(loginController.isPasswordVisible.isTrue
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: loginController.togglePasswordVisibility,
                        ),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    ),
                    SizedBox(height: Get.size.height * 0.01),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.to(() => ForgetPassword());
                            },
                            child: Text('Forget Password ?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Get.size.height * 0.020,
                                )),
                          ),
                        ]),
                    SizedBox(height: Get.size.height * 0.025),
                    MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: loginController.login,
                      child: Container(
                        alignment: Alignment.center,
                        height: Get.size.height * 0.080,
                        decoration: BoxDecoration(
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
                    SizedBox(height: Get.size.height * 0.025),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                                "Don't Have An Account?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: Get.size.height * 0.022)),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Get.to(() => RegisterPage());
                              },
                              child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color.fromRGBO(225, 225, 225, 0.9),
                                    color: const Color.fromRGBO(225, 225, 225, 0.9),
                                    fontSize: Get.size.height * 0.023,
                                  )),
                            ),
                          )
                        ]),
                  ],
                ),
              ),
            ),
          ),
        ),
        ));
  }
}
