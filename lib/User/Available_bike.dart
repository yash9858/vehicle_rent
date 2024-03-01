import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';

import 'package:rentify/User/Bike_Details.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Bike extends StatefulWidget {
  const Bike({super.key});

  @override
  State<Bike> createState() => _BikeState();
}

class _BikeState extends State<Bike> {

  bool isLoading=false;
  var data;
  var getUser2;

  void initState(){
    super.initState();
    getdata();
  }

  Future getdata() async{
    SharedPreferences setpreference = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/DashBoard_Bike_Fetch.php"));
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
    var mheight=MediaQuery.sizeOf(context).height;
    var mwidth =MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        title: Text("Available Bikes",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: mheight*0.033),),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,

      ),
      body:  isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
      :Container(
        padding: EdgeInsets.only(left: 10,right: 10),

        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: mheight * 0.27, // Adjust this value
                crossAxisSpacing: 5,
                mainAxisSpacing: 5
            ),
            itemCount: getUser2.length,
            itemBuilder: (BuildContext context,int index){
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>bike_detail(val1:index, bikeid:getUser2[index]["Vehicle_Id"])));
                },
                child: Container(

                    child:  Card(
                        borderOnForeground: true,

                        elevation: 6,
                        shape: RoundedRectangleBorder(

                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(left: 7,right: 7,top: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Text(getUser2[index]["Vehicle_Name"],style: TextStyle(color: Colors.grey),),
                                  Icon(LineIcons.heart,color: Colors.red,)
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius:  BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12)),
                              child: Image.network(
                                getUser2[index]["Vehicle_Image"],
                                fit: BoxFit.cover,
                                height: mheight * 0.16,
                                width: mwidth * 0.5,
                            )),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 4, bottom: 2, right: 4),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                       Text(
                                        getUser2[index]["Category_Name"],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                getUser2[index]["Rent_Price"] +
                                                    "/ Day",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text("4.1"),
                                              Icon(
                                                Icons.star,
                                                color: Colors.orange,
                                                size: 18,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ]),
                              ),
                            )
                          ],
                        ))
                ),
              );
            }),
      ),
    );
  }
}


