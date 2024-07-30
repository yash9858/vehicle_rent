import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/AuthPages/login_screen.dart';
import 'package:rentify/User/about_us.dart';
import 'package:rentify/User/edit_profile.dart';
import 'package:http/http.dart' as http;
import 'package:rentify/User/help_center.dart';
import 'package:rentify/User/history.dart';
import 'package:rentify/User/privacy_policy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  dynamic data;
  dynamic getUser2;
  bool isLoading=true;

  @override
  void initState(){
    super.initState();
    profile();
  }

  Future profile() async{
    setState(() {
      isLoading = true;
    });
    SharedPreferences share=await SharedPreferences.getInstance();
    http.Response response= await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/User_Fetch_API/Profile_User.php"),
        body: {'Login_Id':share.getString('id')});
    if(response.statusCode==200) {
      data = response.body;
      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data!)["users"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mHeight=MediaQuery.sizeOf(context).height;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Profile",style: TextStyle(color: Colors.black,fontSize: 20),),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
        : SingleChildScrollView(
          child: Column(children: [
            Padding(
                padding: EdgeInsets.only(top: mHeight * 0.02),
                child: Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            getUser2[0]["Profile_Image"],
                        ),
                        )],
                    )
                )),
            SizedBox(height: mHeight * 0.032,
            ),
            Text(getUser2[0]["Name"],
              style: const TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: mHeight * 0.05,
            ),
            Column(
              children: [
                InkWell(
                  onTap: (){
                    Get.to(()=> const EditProfile());
                  },
                child: ListTile(
                  leading: const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.deepPurple,
                  ),
                  title:  const Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing:IconButton(
                    onPressed: (){
                      Get.to(()=> const EditProfile());
                    },
                    icon: const Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                ))),
                const Divider(),
                InkWell(
                  onTap: (){
                    Get.to(()=> const HistoryPage());
                  },
                child: ListTile(
                  leading: const Icon(LineIcons.car,color: Colors.deepPurple,),
                  title: const Text(
                    "My Bookings",
                    style: TextStyle(fontSize: 20)
                  ),
                  trailing:IconButton(
                    onPressed: (){
                      Get.to(()=> const HistoryPage());
                    },
                    icon: const Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                ))),
                const Divider(),
                InkWell(
                  onTap: (){
                    Get.to(()=> const HelpCenter());
                  },
                  child:ListTile(
                  leading: const Icon(Icons.headset_mic_outlined,color: Colors.deepPurple,),
                  title: const Text(
                    "Help Center",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing:IconButton(
                    onPressed: (){
                      Get.to(()=> const HelpCenter());
                    },
                    icon: const Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                ))),
                const Divider(),
                InkWell(
                  onTap: (){
                    Get.to(()=> const PrivacyPolicyPage());
                  },
                  child:ListTile(
                  leading: const Icon(Icons.policy_outlined,color: Colors.deepPurple,),
                  title: const Text(
                    "Privacy Policy",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: IconButton(
                  onPressed: (){
                    Get.to(()=> const PrivacyPolicyPage());
                  },
                  icon: const Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                ))),
                const Divider(),
                InkWell(
                  onTap: (){
                    Get.to(()=> const AboutUs());
                  },
                child:ListTile(
                    leading: const Icon(Icons.info_outline_rounded,color: Colors.deepPurple,),
                    title: const Text(
                      "About_Us",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing:IconButton(
                      onPressed: (){
                        Get.to(()=> const AboutUs());
                      },
                      icon: const Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                    ))),
                  const Divider(),
                  InkWell(
                  onTap: () async{
                    final pref = await SharedPreferences.getInstance();
                    await pref.clear();
                    await pref.setBool('seen', true);
                    Get.offAll(()=> LoginPage());
                  },
                child: const ListTile(
                  leading: Icon(Icons.logout,color: Colors.deepPurple,),
                  title: Text(
                    "Log Out",
                    style: TextStyle(fontSize: 20),
                  ),
                )),
              ],
            )
          ]),
        )
    );
  }
}