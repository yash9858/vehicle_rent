import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:rentify/AuthPages/StateManagement/StateManagement/register_state.dart';
import 'package:rentify/AuthPages/login_screen.dart';

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
                        return "Please Enter name";
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
                        return "Enter Password ";
                      } else if (val.length >= 20) {
                        return "Password is too long (max 20 characters)";
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
                    onPressed: controller.submit,
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
