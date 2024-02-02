import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class Edit_profile extends StatefulWidget {
  const Edit_profile({super.key});

  @override
  State<Edit_profile> createState() => _Edit_profileState();
}

class _Edit_profileState extends State<Edit_profile> {

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Profile",style: TextStyle(color: Colors.black,fontSize: 20),),

          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
      body:SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        Positioned(
                          left: 80,
                          bottom: 1,
                          child: CircleAvatar(

                            child: IconButton(
                                onPressed: (){

                                },
                                icon:Icon(Icons.camera_alt_outlined)),
                          ),
                        )
                      ],
                    ))),


            SizedBox(
              height: mHeight * 0.03,
            ),

            //Name
            Text("Name",style: TextStyle(fontSize: 18,),),
            TextField(



            )

        ]),
      )
    ));
  }
}


