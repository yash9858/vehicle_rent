import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rentify/AuthPages/login_screen.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;

  var isLoading = false.obs;
  var visiblePass = true.obs;
  var visibleConfirm = true.obs;

  void togglePasswordVisibility() {
    visiblePass.value = !visiblePass.value;
  }

  void toggleConfirmVisibility() {
    visibleConfirm.value = !visibleConfirm.value;
  }

  Future<void> forgetPass() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      isLoading.value = true;

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
        isLoading.value = false;
        Fluttertoast.showToast(
            msg: "Password reset email sent",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2
        );
        Get.offAll(() => LoginPage());
      }
      catch (e) {
        isLoading.value = false;
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2);
      }
    }
  }
}

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final ForgetPasswordController controller = Get.put(ForgetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
            "Forget Password",
            style: TextStyle(
                color: Colors.black, fontSize: 20
            )
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(
          child: CircularProgressIndicator(
              color: Colors.deepPurple
          )
      )
          : Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: controller.emailController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Email must not be empty";
                    } else {
                      if (
                      RegExp(r"^[a-zA-Z0-9]+[^#$%&*]+[a-zA-Z0-9]+@[a-z]+\.[a-z]{2,3}").hasMatch(val)) {
                        return null;
                      }
                      else {
                        return "Enter a valid Email";
                      }
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(
                        vertical: Get.size.height * 0.025
                    ),
                    filled: true,
                    hintText: "Enter Your Email ",
                    prefixIcon: const Icon(
                        Icons.email_outlined
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                    height: Get.size.height * 0.04
                ),
                TextFormField(
                  obscureText: controller.visiblePass.value,
                  controller: controller.passwordController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Use Proper Password ";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(
                        vertical: Get.size.height * 0.025
                    ),
                    filled: true,
                    hintText: "New Password ",
                    prefixIcon: const Icon(
                        Icons.key
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(controller.visiblePass.value
                          ? Icons.visibility
                          : Icons.visibility_off
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                    height: Get.size.height * 0.04
                ),
                TextFormField(
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Enter Confirm Password ";
                    } else if (val != controller.passwordController.text) {
                      return "Passwords Do Not Match";
                    }
                    return null;
                  },
                  obscureText: controller.visibleConfirm.value,
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(
                        vertical: Get.size.height * 0.025
                    ),
                    filled: true,
                    hintText: "Confirm Password ",
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
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: Get.size.height * 0.04),
                ElevatedButton(
                  onPressed: controller.forgetPass,
                  child: const Text('Reset Password'),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
