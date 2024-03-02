import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:rentify/Admin/Category_add_admin.dart';
import 'package:rentify/User/Available_bike.dart';
import 'package:rentify/User/Available_car.dart';
import 'package:rentify/User/Bike_Details.dart';
import 'package:rentify/User/Car_Details.dart';
import 'package:rentify/User/Category.dart';
import 'package:rentify/User/Category_Vehicle_User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  String? data;
  var getUser;
  var getUser2;
  var x;
  var getUser3;
  bool isLoading=false;

  void initState(){
    super.initState();
    getdata();
    getdata2();
    getdata3();
  }

  Future getdata() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/DashBoard_Category_Fetch.php"));
    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
      });
    }
  }

  Future getdata2() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/DashBoard_Car_Fetch.php"));
    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data!)["users"];
      });
    }
  }
  Future getdata3() async{
    SharedPreferences setpreference = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
      x=setpreference.getString('uname');
    });
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/DashBoard_Bike_Fetch.php"));
    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser3=jsonDecode(data!)["users"];
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
       // iconTheme: const IconThemeData(color: Colors.deepPurple),
        backgroundColor: Colors.deepPurple.shade800,
        elevation: 0,
        title: Row(
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            Text(
              "Hy,",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                 ),
            ),
            SizedBox(
              width: 5,
            ),
            isLoading ?  Center(child: CircularProgressIndicator(color: Colors.transparent),)
            :Text(x, style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
            )
          ],
        ),
        actions: [
          const Padding(
              padding: EdgeInsets.all(8),
              child: CircleAvatar(

                backgroundColor: Colors.black,
                child: Text("S"),
              ))
        ],
      ),
      body: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
          :SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15,top: 6),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //Header Text



            SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            Container(
              child: SearchBar(
                // elevation: MaterialStateProperty.all(5),
                shape: MaterialStateProperty.all(const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                )),
                leading: const Icon(Icons.search),
                  trailing: [
              IconButton(
              icon: const Icon(Icons.keyboard_voice_rounded),
              onPressed: () {
                print('Use voice command');
              },
            ),

          ],

                hintText: "Find your vehicle",

                hintStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.grey)),

                //  backgroundColor: MaterialStateProperty.all(
                //   const Color(0xffece6f5),
                //  ),
              ),
            ),
            //  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),


            //CATEGORY
            Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Category",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Category()));
                    },

                    child: Text("View all",  style: TextStyle(color: Colors.grey),)),
              ],
            ),

          //  SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),


            //SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),

            Container(
              height: mheight*0.12,
            //  color: Colors.deepPurple,
              child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                 physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                //mainAxisSpacing: 5,
                    mainAxisSpacing: 1

              ),
                  itemCount: 4,
                  itemBuilder: (BuildContext contect, int index){
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Category_Vehicle_User(val: getUser[index]["Category_Id"], name: getUser[index]["Category_Name"])));
                  },
                  child:  isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
                  :Column(
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
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                );
              }),
            ),
            SizedBox(height: mheight*0.01,),
            Container(
              padding: EdgeInsets.only(left: 5,right: 5),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Most popular",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  // TextButton(
                  //     onPressed: () {
                  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                  //     },
                  //     child: Text(
                  //       "View More",
                  //       style: TextStyle(color: Colors.grey),
                  //     ))
                ],
              ),
            ),

              //  height: mheight * 0.49,
              // padding: EdgeInsets.only(top: 3, left: 10, right: 10),
            SizedBox(height: mheight*0.01,),
            //card

            Container(
              height: mheight * 0.32,
              child: PageView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap:() =>
                    {
                    //  Navigator.push(context, MaterialPageRoute(builder: (context)=> car_detail())),
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
                                      "Tesla",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "Model3 Long Range",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  LineIcons.heart,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text("Compact", style: TextStyle()),
                            ),
                            Image.asset(
                              'assets/img/tesla.jpg',
                              fit: BoxFit.cover,
                              height: mheight * 0.17,
                              width: mwidth,
                           //   filterQuality: FilterQuality.high,


                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "₹750",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("/day"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ),
                                    Text("4.9"),
                                    Text("(25 Review)"),
                                  ],
                                ),
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




            // SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            //popular text
            Container(
              padding: EdgeInsets.only(left: 5,right: 5),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Car()));
                      },
                      child: Text(
                        "View More",
                        style: TextStyle(color: Colors.grey),
                      ))
                ],
              ),
            ),
            // SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
            //car card



               Container(
                height: MediaQuery.sizeOf(context).height * 0.25,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  physics:  BouncingScrollPhysics(),
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 5
                  ),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> car_detail(val:index, carid:getUser2[index]["Vehicle_Id"])));
                      },
                        child: Card(

                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child:isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
                          :Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 7, right: 7, top: 3),
                                child: isLoading ? Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.deepPurple),)
                                    : Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [

                                    Text(getUser2[index]["Category_Name"],
                                      style: TextStyle(color: Colors.grey),),
                                    Icon(LineIcons.heart, color: Colors.red,)
                                  ],
                                ),
                              ),
                              isLoading ? Center(
                                child: CircularProgressIndicator(
                                    color: Colors.deepPurple),)
                                  : Padding(
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
                                  padding: EdgeInsets.only(
                                      left: 4, bottom: 2, right: 4),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(getUser2[index]["Vehicle_Name"],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "₹"+getUser2[index]["Rent_Price"] +
                                                  "/ Day",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
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
                          )));
                  },
                ),
              ),



            //available text

            Container(
              padding: EdgeInsets.only(left: 5,right: 5),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Bike()));
                      },
                      child: Text(
                        "View More",
                        style: TextStyle(color: Colors.grey),
                      ))
                ],
              ),
            ),

            //Bike car
            Container(
                height: MediaQuery.sizeOf(context).height * 0.25,


                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  physics:  BouncingScrollPhysics(),
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 5
                  ),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                      return  GestureDetector(
                          onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>bike_detail(val1:index, bikeid:getUser3[index]["Vehicle_Id"])));
                      },
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(
                                    left: 7, right: 7, top: 3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [

                                    Text(getUser3[index]["Category_Name"],
                                      style: TextStyle(color: Colors.grey),),
                                    Icon(LineIcons.heart, color: Colors.red,)
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
                                //  child: Image.network("https://5.imimg.com/data5/SELLER/Default/2022/5/HR/UL/BO/3483248/royal-enfield-thunderbird-350-asphalt-500x500.png",fit: BoxFit.cover,),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4, bottom: 2, right: 4),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          getUser3[index]["Vehicle_Name"],
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
                                                  "₹" +getUser3[index]["Rent_Price"] +
                                                       "/ Day",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .bold),
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
