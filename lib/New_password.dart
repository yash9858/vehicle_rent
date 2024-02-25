import 'package:flutter/material.dart';


class New_password extends StatefulWidget {
  const New_password({super.key});

  @override
  State<New_password> createState() => _New_passwordState();
}

class _New_passwordState extends State<New_password> {
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
         // title: const Text("Forget Password",style: TextStyle(color: Colors.black,fontSize: 20),),

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
              Text("New Password",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

              SizedBox(height: mdheight*0.04),

              TextField(
                // controller: emailController,
                decoration: InputDecoration(  contentPadding: EdgeInsets.symmetric(vertical: mdheight * 0.025),
                  filled: true,
                  hintText: "Password ",
                  prefixIcon: const Icon(Icons.remove_red_eye_rounded),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),),
                keyboardType: TextInputType.emailAddress,

              ),
              SizedBox(height: mdheight*0.04),
              TextField(
                // controller: emailController,
                decoration: InputDecoration(  contentPadding: EdgeInsets.symmetric(vertical: mdheight * 0.025),
                  filled: true,
                  hintText: " Confirm Password ",
                  prefixIcon: const Icon(Icons.remove_red_eye_rounded),
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
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>New))
                },
                child: Text('Password'),
              ),
            ],
          ),
        )
    );
  }
}
