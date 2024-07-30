import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rentify/AuthPages/login_screen.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var visiblePass = true.obs;
  var visibleConfirm = true.obs;

  void togglePasswordVisibility() {
    visiblePass.value = !visiblePass.value;
  }

  void toggleConfirmVisibility() {
    visibleConfirm.value = !visibleConfirm.value;
  }

  Future<void> submit() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      isLoading.value = true;
      final loginUrl = Uri.parse(
          "https://road-runner24.000webhostapp.com/API/Update_API/Forget_Password.php");
      final response = await http.post(loginUrl, body: {
        "Email": emailController.text,
        "Password": passwordController.text
      });
      isLoading.value = false;
      if (response.statusCode == 200) {
        final logindata = jsonDecode(response.body);
        if (logindata['error'] == false) {
          Get.offAll(() => LoginPage());
        } else {
          Fluttertoast.showToast(
              msg: logindata['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2);
        }
      }
    }
  }
}
