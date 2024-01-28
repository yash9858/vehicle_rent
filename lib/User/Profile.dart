import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

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
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                            "https://launchwebsitedesign.com/wp-content/uploads/2017/09/josh-d-avatar.jpg"),
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
                      Icons.person,
                      color: Colors.deepPurple,
                    ),
                    title: Text(
                      "Your Profile",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(LineIcons.car,color: Colors.deepPurple,),
                    title: Text(
                      "Booking History",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                  ),

                  Divider(),
                  ListTile(
                    leading: Icon(LineIcons.heart,color: Colors.deepPurple,),
                    title: Text(
                      "Favorite Car",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.policy_outlined,color: Colors.deepPurple,),
                    title: Text(
                      "Private Policy",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.policy,color: Colors.deepPurple,),
                    title: Text(
                      "Private Policy",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.policy,color: Colors.deepPurple,),
                    title: Text(
                      "Private Policy",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.policy,color: Colors.deepPurple,),
                    title: Text(
                      "Private Policy",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,color: Colors.deepPurple,),
                  ),


                ],
              )
            ]),
          ),
        )
    );
  }
}
