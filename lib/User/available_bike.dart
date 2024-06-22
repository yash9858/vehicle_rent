import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rentify/User/bike_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bike extends StatefulWidget {
  const Bike({super.key});

  @override
  State<Bike> createState() => _BikeState();
}

class _BikeState extends State<Bike> {
  bool isLoading=true;
  dynamic data;
  dynamic getUser2;
  dynamic bikeId;

  @override
  void initState(){
    super.initState();
    bikeData();
  }

  Future bikeData() async{
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/DashBoard_Bike_Fetch.php"));
    if(response.statusCode==200) {
      data = response.body;
      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data!)["users"];
      });
    }
  }

  dynamic nam;
  dynamic d;
  dynamic c;

  void fav() async {
    SharedPreferences s=await SharedPreferences.getInstance();
    final loginUrl = Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Update_API/Favorites2.php");
    final response = await http
        .post(loginUrl, body: {
        'Login_Id':s.getString('id'),
        'Vehicle_Id': nam,
      },
    );
    if (response.statusCode == 200) {
      d = response.body;
      if (kDebugMode) {
        print(d);
      }
      setState(() {
        c = jsonDecode(d!)['users'];
      });
    }
    else {
      setState(() {
        isLoading=false;
      });
      if (kDebugMode) {
        print("Failed to fetch data. Status code: ${response.statusCode}");
      }
    }
  }

  dynamic d1;
  dynamic c1;

  void fav2() async {
    SharedPreferences s=await SharedPreferences.getInstance();
    final loginUrl = Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Update_API/Favorites.php");
    final response = await http
        .post(loginUrl, body: {
      'Login_Id':s.getString('id'),
      'Vehicle_Id': bikeId,
    },
    );
    if (response.statusCode == 200) {
      d1 = response.body;
      if (kDebugMode) {
        print(d);
      }
      setState(() {
        c1 = jsonDecode(d1!)['users'];
        isLoading=false;
      });
    }
    else {
      setState(() {
        isLoading=false;
      });
      if (kDebugMode) {
        print("Failed to fetch data. Status code: ${response.statusCode}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var mheight=MediaQuery.sizeOf(context).height;
    var mwidth =MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Available Bikes",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: mheight*0.030),),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
      :Container(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: mheight * 0.27, // Adjust this value
                crossAxisSpacing: 5,
                mainAxisSpacing: 5
            ),
            itemCount: getUser2.length,
            itemBuilder: (context,int index){
              return GestureDetector(
                onTap: (){
                  Get.to(()=> BikeDetail(val1:index, bikeId:getUser2[index]["Vehicle_Id"],bikeName:getUser2[index]["Vehicle_Name"],type:getUser2[index]["Vehicle_Type"],descripation:getUser2[index]["Vehicle_Description"],price:getUser2[index]["Rent_Price"],image:getUser2[index]["Vehicle_Image"]));
                },
                child: Card(
                    borderOnForeground: true,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:  const EdgeInsets.only(left: 7,right: 7,top: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(getUser2[index]["Category_Name"],style: const TextStyle(color: Colors.blueGrey),)),
                              const Icon(Icons.info_outline,color: Colors.blueGrey,)
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius:  const BorderRadius.only(
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
                            padding: const EdgeInsets.only(
                                left: 4, bottom: 2, right: 4),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                   Text(
                                    getUser2[index]["Vehicle_Name"],
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,

                                    children: [
                                      Row(
                                        children: [
                                          const Text("₹"),
                                          Text(
                                            "${getUser2[index]["Rent_Price"]}/ Day",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        )
                      ],
                    )),
              );
            }),
      ),
    );
  }
}