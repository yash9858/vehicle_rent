import 'package:flutter/material.dart';
import 'package:rentify/New_password.dart';


class Forget_password extends StatefulWidget {
  const Forget_password({super.key});

  @override
  State<Forget_password> createState() => _Forget_passwordState();
}

class _Forget_passwordState extends State<Forget_password> {
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;

      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Forget Password",
            style: TextStyle(color: Colors.black,fontSize: 20),),

          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
     body:
     Padding(
       padding: EdgeInsets.all(16),
       child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextField(
             // controller: emailController,
              decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: mdheight * 0.025),
                filled: true,
                hintText: "Enter Your Email ",
                prefixIcon: const Icon(Icons.email_outlined),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),),
              keyboardType: TextInputType.emailAddress,

            ),

            SizedBox(height: mdheight*0.04),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>New_password()));
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
     )
     );

  }
}

