import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rentify/Admin/select_category.dart';
import 'package:rentify/Admin/update_vehicle.dart';

class AdminVehiclePage extends StatefulWidget {
  const AdminVehiclePage({super.key});

  @override
  State<AdminVehiclePage> createState() => _AdminVehiclePageState();
}

class _AdminVehiclePageState extends State<AdminVehiclePage> {
  String? data;
  String? data2;
  dynamic getUser;
  dynamic getUser2;
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
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Vehicle_Admin.php"));
    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
      });
    }
  }

  Future vehicle(String vid) async{
    http.Response response= await http.post(Uri.parse(
      "https://road-runner24.000webhostapp.com/API/Delete_API/Vehicle.php",
    ), body: {'Vehicle_Id' : vid});
    if(response.statusCode==200){
      data2=response.body;
      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data2!)["users"];
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
        title: const Text('Vehicle List'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body : isLoading ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
          : ListView.builder(
          itemCount: getUser.length,
          itemBuilder: (BuildContext context, int index)
          {
            return Padding(padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.025, vertical: mdheight * 0.005),
                child: Card(
                  elevation: 5.0,
                  shadowColor: Colors.deepPurple.shade800,
                  semanticContainer: true,
                  surfaceTintColor: Colors.deepPurple.shade800,
                  child: Padding(
                    padding: EdgeInsets.all(mdheight * 0.017),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children :[
                              Expanded(
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('Vehicle Id : '),
                                        Text(getUser[index]["Vehicle_Id"]),
                                      ],
                                    ),
                                    SizedBox(height: mdheight * 0.01),
                                    Row(
                                      children: [
                                        const Text('Vehicle Name : '),
                                        Text(getUser[index]["Vehicle_Name"]),
                                      ],
                                    ),
                                    SizedBox(height: mdheight * 0.01),
                                    Row(
                                      children: [
                                        const Text('Vehicle Type : '),
                                        Text(getUser[index]["Vehicle_Type"]),
                                      ],
                                    ),
                                    SizedBox(height: mdheight * 0.01),
                                    Row(
                                      children: [
                                        const Text('Rent Price: '),
                                        Text(getUser[index]["Rent_Price"]+'/day'),
                                      ],
                                    ),
                                    SizedBox(height: mdheight * 0.01),
                                    const Row(
                                      children: [
                                        Text('Vehicle Description : ')
                                      ],
                                    ),
                                    Text(getUser[index]["Vehicle_Description"],maxLines: 3),
                                    SizedBox(height: mdheight * 0.01),
                                  ],
                                )),
                                  Expanded(
                                    child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children:[
                                      Image.network(getUser[index]["Vehicle_Image"],
                                          height : mdheight * 0.15,
                                          fit: BoxFit.cover,
                                        ),
                                    ]),
                                  ),
                            ]
                        ),
                        SizedBox(height:  mdheight * 0.015,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MaterialButton(onPressed: (){
                              Get.to(() => UpdateVehicle(val:index));
                            },
                                color: Colors.deepPurple.shade800,
                                padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                                ),
                                child: const Text('Edit Vehicle', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                )),
                            MaterialButton(onPressed: (){
                              CoolAlert.show(context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Do you Remove Vehicle',
                                  confirmBtnColor: Colors.red,
                                  onConfirmBtnTap: (){
                                    vehicle(getUser[index]["Vehicle_Id"]).whenComplete(() {getdata();});
                                  },
                                  animType: CoolAlertAnimType.slideInDown,
                                  backgroundColor: Colors.red,
                                  cancelBtnTextStyle: const TextStyle(
                                    color: Colors.black,
                                  ));
                            },
                                color: Colors.red,
                                padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                                ),
                                child: const Text('Delete Vehicle', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(() => const Category());
        },
        backgroundColor: Colors.deepPurple.shade800,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

