import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentify/Admin/vehicle_add_admin.dart';
import 'package:http/http.dart' as http;

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  String? data;
  dynamic getUser;
  bool isLoading=false;

  @override
  void initState(){
    super.initState();
    getdata();
  }

  Future getdata() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Category_Admin.php"));
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
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade800,
        title: Text(" Select Category",style: TextStyle(color: Colors.white,
          fontSize: mheight * 0.025,),),
        elevation: 0,

      ),
      body: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),) :  Container(
        padding: const EdgeInsets.only(top: 20,),
        child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 5,
            crossAxisCount: 3,
            crossAxisSpacing: 5
        ),
            itemCount: getUser.length,
            itemBuilder: (BuildContext context,int index){
              return GestureDetector(
                onTap: (){
                  Get.to(()=>AdminAddVehicle(id:getUser[index]["Category_Id"],name:getUser[index]["Category_Name"]));
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
