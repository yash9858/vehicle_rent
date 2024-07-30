import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rentify/Admin/admin_dashboard.dart';
import 'package:rentify/User/complete_profile.dart';
import 'package:rentify/User/user_dash_board.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isPasswordVisible = true.obs;

  Future<void> login() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      isLoading(true);

      final loginUrl = Uri.parse("https://road-runner24.000webhostapp.com/API/Insert_API/Checklogin.php");
      final response = await http.post(loginUrl, body: {
        "Email": emailController.text,
        "Password": passwordController.text
      });

      if (response.statusCode == 200) {
        var logindata = jsonDecode(response.body);
        var data = logindata['user'];

        isLoading(false);

        if (logindata['error'] == false) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('id', data['Login_Id'].toString());
          await prefs.setString('uname', data['User_Name'].toString());
          await prefs.setString('email', data['Email'].toString());
          await prefs.setString('Role', data['Role'].toString());
          await prefs.setString('status', data['Status'].toString());
          await prefs.setString('vid', data['Vehicle_Id'].toString());

          if (data["Role"] == "1") {
            if (data["Status"] == "1") {
              Get.offAll(() => const UserDashboard());
            } else {
              Get.offAll(() => const CompleteProfile());
            }
          } else {
            Get.offAll(() => const AdminDashBoard());
          }
        } else {
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

  void togglePasswordVisibility() {
    isPasswordVisible(!isPasswordVisible.value);
  }
}
