import 'dart:convert';

import 'package:flutter/Material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;


// ignore: camel_case_types
class Admin_FeedbackPage extends StatefulWidget {
  const Admin_FeedbackPage({super.key});

  @override
  State<Admin_FeedbackPage> createState() => _Admin_FeedbackPageState();
}

// ignore: camel_case_types
class _Admin_FeedbackPageState extends State<Admin_FeedbackPage> {
  String? data;
  var getUser;
  bool isLoading=false;

  void initState(){
    super.initState();
    getdata();
  }
  Future getdata() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Feedback_Admin.php"));
    if(response.statusCode==200){
      data=response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text('Feedbacks'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body:isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),) : ListView.builder(
        itemCount: getUser.length,
        itemBuilder: (BuildContext context, int index)
        {
          return Padding(padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.025, vertical: mdheight * 0.005),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.all(mdheight * 0.01),
                shadowColor: Colors.deepPurple.shade800,
                semanticContainer: true,
                surfaceTintColor: Colors.deepPurple.shade800,
                child: Padding(
                  padding: EdgeInsets.all(mdheight * 0.017),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('User Name: '+getUser[index]["Name"]),
                          Text(getUser[index]["Feedback_Time"]),
                        ],
                      ),
                      SizedBox(height: mdheight * 0.01,),
                       Text('Vehicle Name: '+getUser[index]["Vehicle_Name"]),
                      SizedBox(height: mdheight * 0.01,),
                      Text('Comments: '+getUser[index]["Comment"]),
                      SizedBox(height: mdheight * 0.01,),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(LineIcons.starAlt, color: Colors.amber,),
                          Icon(LineIcons.starAlt, color: Colors.amber,),
                          Icon(LineIcons.starAlt, color: Colors.amber,),
                          Icon(LineIcons.starHalf, color: Colors.amber),
                          Icon(LineIcons.star, color: Colors.amber,),
                          Text(getUser[index]["Ratings"]),
                        ],
                      )
                    ],
                  ),
                ),
              ));
        }),
    );
  }
}
