import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/Login_Screen.dart';
import 'package:rentify/User/About_us.dart';
import 'package:rentify/User/Cancel_booking.dart';
import 'package:rentify/User/Edit_Profile.dart';
import 'package:http/http.dart' as http;
import 'package:rentify/User/Favorite_Vehicle.dart';
import 'package:rentify/User/Help_Center.dart';
import 'package:rentify/User/History.dart';
import 'package:rentify/User/Payment_Receipt.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  var data;
  var getUser2;
  bool isLoading=false;
  void initState(){
    super.initState();
    getdata();
  }

  Future getdata() async{
    SharedPreferences share=await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Profile_User.php"),
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
        body: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
        : SingleChildScrollView(
          child: Column(children: [
            // User Image

             Padding(
                padding: EdgeInsets.only(top: 0),
                child: Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            getUser2[0]["Profile_Image"],
                        ),
                        )],
                    ))),
            SizedBox(
              height: mHeight * 0.03,
            ),
            Text(getUser2[0]["Name"],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: mHeight * 0.05,
            ),
            Column(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context , MaterialPageRoute(builder: (context)=> const Edit_Profile()));
                  },
                child: ListTile(
                  leading: const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.deepPurple,
                  ),
                  title: const Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing:IconButton(
                    onPressed: (){
                      Navigator.push(context , MaterialPageRoute(builder: (context)=> const Edit_Profile()));
                    },
                    icon: const Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                ))),
                const Divider(),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const History_page()));
                  },
                child: ListTile(
                  leading: const Icon(LineIcons.car,color: Colors.deepPurple,),
                  title: const Text(
                    "My Bookings",
                    style: TextStyle(fontSize: 20)
                  ),
                  trailing:IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const History_page()));
                    },
                    icon: const Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                ))),
                const Divider(),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Favorite()));
                  },
                  child:ListTile(
                  leading: const Icon(LineIcons.heart,color: Colors.deepPurple,),
                  title: const Text(
                    "Favorite Vehicles",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing:
                  IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Favorite()));
                    },
                    icon:const Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                ))),
                const Divider(),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const HelpCenter()));
                  },
                  child:ListTile(
                  leading: const Icon(Icons.headset_mic_outlined,color: Colors.deepPurple,),
                  title: const Text(
                    "Help Center",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing:IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const HelpCenter()));
                    },
                    icon: const Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                ))),
                const Divider(),
                InkWell(
                  child:ListTile(
                  leading: const Icon(Icons.policy_outlined,color: Colors.deepPurple,),
                  title: const Text(
                    "Privacy Policy",
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                ))),
                const Divider(),
                InkWell(
                  onTap: (){
                  //  Navigator.push(context, MaterialPageRoute(builder: (context)=> const FeedBack_User()));
                  },
                  child: ListTile(
                    leading: const Icon(Icons.payment_outlined,color: Colors.deepPurple,),
                    title: const Text(
                      "Payment"
                          ,
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing:IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const Payment_Receipt()));
                      },
                      icon: const Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                    ))),
                const Divider(),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Cancel_booking()));
                  },
                  child:ListTile(
                    leading: const Icon(Icons.cancel_outlined,color: Colors.deepPurple,),
                    title: const Text(
                      "Cancel Booking",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing:IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const Cancel_booking()));
                      },
                      icon: const Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                    ))),
                const Divider(),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const About_us()));
                  },
                child:ListTile(
                    leading: const Icon(Icons.info_outline,color: Colors.deepPurple,),
                    title: const Text(
                      "About_Us",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing:IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const About_us()));
                      },
                      icon: const Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                    ))),
                const Divider(),
                InkWell(
                  onTap: () async {
                    final pref = await SharedPreferences.getInstance();
                    await pref.clear();
                    await pref.setBool('seen', true);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
                  },
                child: ListTile(
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
