import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rentify/User/Available_car.dart';
import 'package:http/http.dart' as http;

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

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
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/DashBoard_Category_Fetch.php"));
    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
      });
    }
  }

  @override

  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Category",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: mheight*0.033),),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
      :Container(
        padding: EdgeInsets.only(top: 20,),
        child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 5,
          crossAxisCount: 3,
          crossAxisSpacing: 5
        ),
            itemCount: getUser.length,
            itemBuilder: (BuildContext context,int index){
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Car()));
            },
            child:  Column(
              children: [
                Card(
                  elevation: 5,

                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(10),
                    child: Image.network(
                      getUser[index]["Category_Image"],
                      fit: BoxFit.cover,
                      height: mwidth * 0.17,
                    ),
                  ),
                ),
                Text(
                  getUser[index]["Category_Name"],
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
