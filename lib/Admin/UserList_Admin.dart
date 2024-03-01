import 'dart:convert';

import 'package:flutter/Material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class Admin_UserPage extends StatefulWidget {
  const Admin_UserPage({super.key});

  @override
  State<Admin_UserPage> createState() => _Admin_UserPageState();
}

// ignore: camel_case_types
class _Admin_UserPageState extends State<Admin_UserPage> {
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
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/User_Details_Admin.php"));
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
        title: const Text('User List'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body : isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),) : ListView.builder(
          itemCount: getUser.length,
          itemBuilder: (BuildContext context, int index)
          {
            return Padding(padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.025, vertical: mdheight * 0.005),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(mdheight * 0.01),
                  shadowColor: Colors.deepPurple.shade800,
                  surfaceTintColor: Colors.deepPurple.shade800,
                  child: Padding(
                    padding: EdgeInsets.all(mdheight * 0.017),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children :[
                            Expanded(
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Details Id : '+getUser[index]["Details_Id"]),
                                  SizedBox(height: mdheight * 0.01,),
                                  Text('User Name : '+getUser[index]["Name"]),
                                  SizedBox(height: mdheight * 0.01,),
                                   Text('Dob : '+getUser[index]["Dob"]),
                                  SizedBox(height: mdheight * 0.01,),
                                   Text('Gender : '+getUser[index]["Gender"]),
                                  SizedBox(height: mdheight * 0.01,),
                                   Text('Address :'+getUser[index]["Address"]),
                                  SizedBox(height: mdheight * 0.01,),
                                   Text('Licence Number : '+getUser[index]["Lincence_Number"]),
                                  SizedBox(height: mdheight * 0.01,),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                                children:[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(getUser[index]["Profile_Image"],
                                      height : mdheight * 0.15,

                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ]
                            ),
                          ]
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(onPressed: (){
                              CoolAlert.show(context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Do you Remove User',
                                  confirmBtnColor: Colors.red,
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

                              child: const Text('Delete User', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              )),
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
