import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'package:rentify/User/search_page.dart';
import 'package:rentify/User/available_bike.dart';
import 'package:rentify/User/available_car.dart';
import 'package:rentify/User/bike_details.dart';
import 'package:rentify/User/car_details.dart';
import 'package:rentify/User/category.dart';
import 'package:rentify/User/category_vehicle_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  String? data;
  String? data2;
  String? data3;
  dynamic getUser;
  dynamic getUser2;
  dynamic x;
  dynamic getUser3;
  dynamic getUser4;
  bool isLoading=true;

  @override
  void initState(){
    super.initState();
    getdata();
    getdata4();
  }

  Future getdata() async{
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/DashBoard_Category_Fetch.php"));
    if(response.statusCode==200) {
      data = response.body;
      setState(() {
        getdata2();
        getUser=jsonDecode(data!)["users"];
      });
    }
  }

  Future getdata2() async{
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/DashBoard_Car_Fetch.php"));
    if(response.statusCode==200) {
      data2 = response.body;
      setState(() {
        getdata3();
        getUser2=jsonDecode(data2!)["users"];
      });
    }
  }

  Future getdata3() async{
    SharedPreferences setpreference = await SharedPreferences.getInstance();
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/DashBoard_Bike_Fetch.php"));
    if(response.statusCode==200) {
      data = response.body;
      setState(() {
        x=setpreference.getString('uname');
        isLoading=false;
        getUser3=jsonDecode(data!)["users"];
      });
    }
  }

  Future getdata4() async{
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/DashBoard_Arrive.php"));
    if(response.statusCode==200) {
      data3 = response.body;
      setState(() {
        getUser4=jsonDecode(data3!)["users"];
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
        elevation: 0,
        title: Row(
          children: [
            const Text(
              "Hy,",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                 ),
            ),
            const SizedBox(
              width: 5,
            ),
            isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.transparent),)
                : Text(x.toString(), style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
            )
          ],
        ),
        actions: [
           Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black,
                child: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.transparent),)
                : Text(x.toString().characters.first,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ))
        ],
      ),
      body: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
          :SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15,top: 6),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            SearchBar(
              onTap: (){
                Get.to(()=> const SearchPage());
              },
              shape: MaterialStateProperty.all(const ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              )),
              leading: const Icon(Icons.search),
              hintText: "Find your vehicle",
              hintStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.grey)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Category",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                TextButton(
                    onPressed: () {
                      Get.to(()=> const Category());
                    },
                    child: const Text("View all",  style: TextStyle(color: Colors.grey),)),
              ],
            ),
            SizedBox(
              height: mheight*0.12,
              child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                      mainAxisSpacing: 1
              ),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                  onTap: (){
                    Get.to(()=> CategoryVehicleUser(val: getUser[index]["Category_Id"], name: getUser[index]["Category_Name"]));
                  },
                  child: Column(
                    children: [
                      Card(
                        elevation: 5,
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(10),
                          child: Image.network(
                            getUser[index]["Category_Image"],
                            fit: BoxFit.cover,
                            height: mwidth * 0.15,
                          ),
                        ),
                      ),
                       Text(
                          getUser[index]["Category_Name"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                );
              }),
            ),
            SizedBox(height: mheight*0.01,),
            Container(
              padding: const EdgeInsets.only(left: 5,right: 5),
              width: double.infinity,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "New Arrives",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: mheight*0.01,),
            SizedBox(
              height: mheight * 0.295,
              child: PageView.builder(
                itemCount: getUser4.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap:() =>
                    {
                      Get.to(()=> CarDetail(val:index, carId:getUser4[index]["Vehicle_Id"],carName:getUser4[index]["Vehicle_Name"],type:getUser4[index]["Vehicle_Type"],descripation:getUser4[index]["Vehicle_Description"],price:getUser4[index]["Rent_Price"],image:getUser4[index]["Vehicle_Image"])),
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getUser4[index]["Vehicle_Name"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.indigo.shade50,
                                      borderRadius: BorderRadius.circular(12),),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5,right: 5),
                                      child: Text(getUser4[index]["Vehicle_Type"],style: const TextStyle(fontSize: 18),),
                                    ))
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text( getUser4[index]["Category_Name"], style: const TextStyle()),
                            ),
                            Image.network(
                              getUser4[index]["Vehicle_Image"],
                              fit: BoxFit.cover,
                              height: mheight * 0.17,
                              width: mwidth*0.78,
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    const Text("₹",
                                      style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,)
                                    ),
                                    Text(getUser4[index]["Rent_Price"],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Text("/day", style: TextStyle(
                                  fontSize: 17,),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 5,right: 5),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Available Cars",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(()=> const Car());
                      },
                      child: const Text(
                        "View More",
                        style: TextStyle(color: Colors.grey),
                      ))
                ],
              ),
            ),
               SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.23,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 5
                  ),
                  itemCount: 10,
                  itemBuilder: (context, int index) {
                      return GestureDetector(
                          onTap: (){
                            Get.to(()=> CarDetail(val:index, carId:getUser2[index]["Vehicle_Id"],carName:getUser2[index]["Vehicle_Name"],type:getUser2[index]["Vehicle_Type"],descripation:getUser2[index]["Vehicle_Description"],price:getUser2[index]["Rent_Price"],image:getUser2[index]["Vehicle_Image"]));
                      },
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 7, right: 7, top: 3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.indigo.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(getUser2[index]["Category_Name"],
                                        style: const TextStyle(color: Colors.blueGrey),),
                                    ),
                                    const Icon(LineIcons.infoCircle, color: Colors.blueGrey,)
                                  ],
                                ),
                              ),
                             Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: Image.network(
                                      getUser2[index]["Vehicle_Image"],
                                      height: mheight * 0.12,
                                      width: mwidth * 0.5,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4, bottom: 2, right: 4),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(getUser2[index]["Vehicle_Name"],
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),),
                                            Row(
                                              children: [
                                                const Text(
                                                    "₹",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold)),
                                                Text(
                                                  getUser2[index]["Rent_Price"],
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                const Text(
                                                  "/ Day",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold
                                                    )
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
                      );
                  },
                ),
              ),
            Container(
              padding: const EdgeInsets.only(left: 5,right: 5),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Available Bikes",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(()=> const Bike());
                      },
                      child: const Text(
                        "View More",
                        style: TextStyle(color: Colors.grey),
                      ))
                ],
              ),
            ),
            SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.23,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 5
                  ),
                  itemCount: 10,
                  itemBuilder: (context, int index) {
                      return  GestureDetector(
                          onTap: (){
                            Get.to(()=>BikeDetail(val1:index, bikeId:getUser3[index]["Vehicle_Id"],bikeName:getUser3[index]["Vehicle_Name"],type:getUser3[index]["Vehicle_Type"],descripation:getUser3[index]["Vehicle_Description"],price:getUser3[index]["Rent_Price"],image:getUser3[index]["Vehicle_Image"]));
                      },
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:  const EdgeInsets.only(left: 7, right: 7, top: 3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.indigo.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(getUser3[index]["Category_Name"],
                                        style: const TextStyle(color: Colors.blueGrey),),
                                    ),
                                    const Icon(LineIcons.infoCircle, color: Colors.blueGrey,)
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12)),
                                child: Image.network(
                                  getUser3[index]["Vehicle_Image"],
                                  fit: BoxFit.fitWidth,
                                  height: mheight * 0.15,
                                  width: mwidth * 0.75,),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4, bottom: 2, right: 4),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                                Text(
                                                  getUser3[index]["Vehicle_Name"],
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                            Row(
                                              children: [
                                                const Text(
                                                    "₹",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold)),
                                                Text(
                                                  getUser3[index]["Rent_Price"],
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                const Text(
                                                    "/ Day",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ]),
                                ),
                              )
                            ],
                          )));
                    }
                ),
            ),
          ]),
        ),
      ),
    );
  }
}