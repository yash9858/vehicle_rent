import 'package:flutter/material.dart';

class Category_Vehicle_User extends StatefulWidget {
  const Category_Vehicle_User({super.key});

  @override
  State<Category_Vehicle_User> createState() => _Category_Vehicle_UserState();
}

class _Category_Vehicle_UserState extends State<Category_Vehicle_User> {
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.transparent,
      title: Text("Select Date and Time",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: mheight*0.033),),
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
    ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: 9,
          itemBuilder: (context, int index)
          {
            return Card(
              child: Column(
                children: [
                  Container(),
                  Text('Name'),
                ],
              )
            );
        }),
    );
  }
}
