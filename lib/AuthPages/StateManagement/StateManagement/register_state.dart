import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rentify/AuthPages/login_screen.dart';

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
      try{
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString(),
        );

        String name = nameController.text.toString();
        String email = emailController.text.toString();
        String role = "User";
        String status = "0";
        var id = userCredential.user!.email;

        await firestore.doc(id).set({
          'Name' : name,
          'Email' : email,
          'Role' : role,
          'Status' : status,
        });

        Fluttertoast.showToast(
            msg: "SuccessFul Register User",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
          );
          Get.offAll(() => LoginPage()
        );
          isLoading.value = false;
      }
      on FirebaseAuthException catch(e){
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
        );
        isLoading.value = false;
    }
      // final loginUrl = Uri.parse("https://road-runner24.000webhostapp.com/API/Insert_API/Login.php");
      // final response = await http.post(loginUrl, body: {
      //   "Email": emailController.text,
      //   "Password": passwordController.text,
      //   "User_Name": nameController.text,
      //   "Role": "1",
      //   "Status": "0",
      // });
      // if (response.statusCode == 200) {
      //   final loginData = jsonDecode(response.body);
      //   if (loginData['error'] == false) {
      //     Fluttertoast.showToast(
      //       msg: loginData['message'].toString(),
      //       toastLength: Toast.LENGTH_LONG,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 2,
      //     );
      //     Get.offAll(() => LoginPage());
      //   } else {
      //     Fluttertoast.showToast(
      //       msg: loginData['message'].toString(),
      //       toastLength: Toast.LENGTH_LONG,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 2,
      //     );
      //   }
      // }
    }
  }
}
