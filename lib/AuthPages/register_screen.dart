import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:rentify/AuthPages/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection("Users");
  var isLoading = false.obs;
  var visiblePass = true.obs;
  var visibleConfirm = true.obs;
  dynamic userId;

  void togglePasswordVisibility() {
    visiblePass.value = !visiblePass.value;
  }

  void toggleConfirmVisibility() {
    visibleConfirm.value = !visibleConfirm.value;
  }

  Future<void> signUp() async {
    final form = formKey.currentState;

    if (form!.validate()) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString(),
        );
        String name = nameController.text.toString();
        String email = emailController.text.toString();
        String role = "User";
        String status = "0";
        var id = userCredential.user!.email;

        var counterRef = FirebaseFirestore.instance.collection('Counter').doc('UserCounter');
        var counterSnapshot = await counterRef.get();
        if (counterSnapshot.exists) {
          userId = counterSnapshot.data()?['latestId'] + 1;
        }
        else {
          userId = 1;
        }
        await counterRef.set({'latestId': userId});
        await firestore.doc(id).set({
          'Uid' : userId,
          'User_Name': name,
          'Email': email,
          'Role': role,
          'Status': status,
        });
        Fluttertoast.showToast(
          msg: "Successful User Registration",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
        );
        Get.offAll(() => LoginPage());
        isLoading.value = false;
      }
      on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(
          msg: e.message ?? "Error occurred",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
        );
        isLoading.value = false;
      }
    }
  }
}

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.isLoading.value
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
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Get.size.height * 0.01,
                  horizontal: Get.size.height * 0.03),
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/img/register.json',
                    height: Get.size.height * 0.32,
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
                    "Create Account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: Get.size.height * 0.02),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: controller.nameController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please Enter Name";
                      }
                      if(RegExp(r'^[a-zA-Z\s]+$').hasMatch(val)){
                        if (val.length > 20) {
                          return "Name Are To Long";
                        }
                        return null;
                      }
                      else{
                        return "Enter Valid Name";
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: Get.size.height * 0.025),
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
                  SizedBox(height: Get.size.height * 0.02),
                  TextFormField(
                    controller: controller.emailController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Email Must Not Be Empty";
                      }
                      else {
                        if (!val.endsWith('@gmail.com')) {
                          return "Email Must Contain '@gmail.com'";
                        }
                        final emailParts = val.split('@');
                        final localPart = emailParts[0];
                        final domainPart = emailParts[1];
                        if (domainPart != 'gmail.com') {
                          return "Email Must Contain '@gmail.com'";
                        }
                        if (localPart.contains('.') || RegExp(r"[^a-zA-Z0-9]").hasMatch(localPart)) {
                          return "Only Alphanumeric Characters Allowed Before '@gmail.com'";
                        }
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: Get.size.height * 0.025),
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
                  SizedBox(height: Get.size.height * 0.02),
                  TextFormField(
                    controller: controller.passwordController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter Password";
                      } else if (val.length < 8 || val.length > 16) {
                        return "Password must be 8 to 16 characters long";
                      }
                      return null;
                    },
                    obscureText: controller.visiblePass.value,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: Get.size.height * 0.025),
                      filled: true,
                      errorStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(controller.visiblePass.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.size.height * 0.02),
                  TextFormField(
                    obscureText: controller.visibleConfirm.value,
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter Confirm Password ";
                      } else if (val != controller.passwordController.text) {
                        return "Passwords Do Not Match";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: Get.size.height * 0.025),
                      filled: true,
                      errorStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      hintText: "Confirm Password",
                      prefixIcon: const Icon(Icons.key),
                      suffixIcon: IconButton(
                        icon: Icon(controller.visibleConfirm.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: controller.toggleConfirmVisibility,
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.size.height * 0.025),
                  MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: controller.signUp,
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
                        "Create Account",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                            "You Have Already An Account?",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: Get.size.height * 0.020,
                            ),
                          )
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => LoginPage());
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor:
                            const Color.fromRGBO(225, 225, 225, 0.9),
                            color:
                            const Color.fromRGBO(225, 225, 225, 0.9),
                            fontSize: Get.size.height * 0.023,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
