import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'car_details.dart';
import 'package:http/http.dart' as http;

class CategoryVehicleUser extends StatefulWidget {
  final String val;
  final String name;
  const CategoryVehicleUser({super.key,required this.val,required this.name});

  @override
  State<CategoryVehicleUser> createState() => _CategoryVehicleUserState();
}

class _CategoryVehicleUserState extends State<CategoryVehicleUser> {
  String? data;
  String?val;
  dynamic getUser;
  bool isLoading=true;

  @override
  void initState(){
    super.initState();
    getdata();
  }

  Future getdata() async{
    Map sendData ={
      'cat_id': widget.val
    };
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Category_vehicle_fetch.php"),body:sendData);
    if(response.statusCode==200) {
      data = response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["Vehicle"];
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
      title: Text(widget.name,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: mheight*0.033),),
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
    ),
      body:isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),):
           Container(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: mheight * 0.27, // Adjust this value
                crossAxisSpacing: 5,
                mainAxisSpacing: 5
            ),
            itemCount:  getUser.length,
            itemBuilder: (BuildContext context,int index){
              return GestureDetector(
                onTap: (){
                  Get.to(()=> CarDetail(val:index, carId:getUser[index]["Vehicle_Id"],carName:getUser[index]["Vehicle_Name"],type:getUser[index]["Vehicle_Type"],descripation:getUser[index]["Vehicle_Description"],price:getUser[index]["Rent_Price"],image:getUser[index]["Vehicle_Image"]));
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
                          padding: const EdgeInsets.only(left: 7,right: 7,top: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(widget.name,style: const TextStyle(color: Colors.blueGrey),)),
                              const Icon(Icons.info_outline,color: Colors.blueGrey,)
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius:  const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: Image.network(
                            getUser[index]["Vehicle_Image"],
                            fit: BoxFit.cover,
                            height: mheight * 0.16,
                            width: mwidth * 0.5,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:  const EdgeInsets.only(
                                left: 4, bottom: 2, right: 4),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    getUser[index]["Vehicle_Name"],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("₹",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          ),
                                          Text("${getUser[index]["Rent_Price"]}",
                                              style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                          ),
                                          const Text("/Day",
                                            style: TextStyle(
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
