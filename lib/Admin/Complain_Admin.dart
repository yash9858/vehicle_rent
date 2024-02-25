// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:flutter/Material.dart';
import 'package:http/http.dart' as http;

class Admin_ComplainPage extends StatefulWidget {
  const Admin_ComplainPage({super.key});

  @override
  State<Admin_ComplainPage> createState() => _Admin_ComplainPageState();
}

class _Admin_ComplainPageState extends State<Admin_ComplainPage> {
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
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Complain_Admin.php"));
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
        title: const Text('Complains'),
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
                        Text(getUser[index]["Complain_Timestamp"]),
                      ],
                    ),
                    SizedBox(height: mdheight * 0.01,),
                     Text('Vehicle Name: '+getUser[index]["Vehicle_Name"]),
                    SizedBox(height: mdheight * 0.01,),
                     Text('Complain Description: '+getUser[index]["Complain"]),
                    SizedBox(height: mdheight * 0.01,),
                     Text('Complain Status :'+getUser[index]["Complain_Status"]),
                    SizedBox(height: mdheight * 0.01,),
                  ],
                ),
              ),
            ));
          }),
    );
  }
}
