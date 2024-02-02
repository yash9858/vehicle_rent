import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/Login_Screen.dart';
import 'package:rentify/User/Edit_Profile.dart';
import 'package:rentify/User/Feedback_User.dart';
import 'package:rentify/User/Help_Center.dart';
import 'package:rentify/User/History.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var mHeight=MediaQuery.sizeOf(context).height;
    var mwidth=MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Profile",style: TextStyle(color: Colors.black,fontSize: 20),),

          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body:
        SingleChildScrollView(
          child: Container(
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
                                "https://launchwebsitedesign.com/wp-content/uploads/2017/09/josh-d-avatar.jpg"),
                          ),
                          // Positioned(
                          //   left: 80,
                          //   bottom: 1,
                          //   child: CircleAvatar(
                          //
                          //       child: IconButton(
                          //         onPressed: (){
                          //
                          //         },
                          //       icon:Icon(Icons.edit)),
                          //       ),
                          // )
                        ],
                      ))),
              SizedBox(
                height: mHeight * 0.03,
              ),
              Text(
                "Esther Howard",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: mHeight * 0.05,
              ),
              Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.account_circle_outlined,
                      color: Colors.deepPurple,
                    ),
                    title: Text(
                      "Edit Profile",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing:IconButton(
                      onPressed: (){
                        Navigator.push(context , MaterialPageRoute(builder: (context)=> Edit_Profile()));
                      },
                      icon: Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                  )),
                  Divider(),
                  ListTile(
                    leading: Icon(LineIcons.car,color: Colors.deepPurple,),
                    title: Text(
                      "My Bookings",
                      style: TextStyle(fontSize: 20)
                    ),
                    trailing:IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>History_page()));
                      },
                      icon: Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                  )),

                  Divider(),
                  ListTile(
                    leading: Icon(LineIcons.heart,color: Colors.deepPurple,),
                    title: Text(
                      "Favorite Vehicles",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing:
                    IconButton(
                      onPressed: (){},
                      icon:Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                  )),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.headset_mic_outlined,color: Colors.deepPurple,),
                    title: Text(
                      "Help Center",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing:IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> HelpCenter()));
                      },
                      icon: Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                  )),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.policy_outlined,color: Colors.deepPurple,),
                    title: Text(
                      "Privacy Policy",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                  )),
                  Divider(),
                  ListTile(
                      leading: Icon(Icons.info_outline,color: Colors.deepPurple,),
                      title: Text(
                        "About Us",
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing:IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedBack_User()));
                        },
                        icon: Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                      )),
                  Divider(),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
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
          ),
        )
    );
  }
}
