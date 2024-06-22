import 'dart:convert';
import 'package:flutter/Material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:http/http.dart' as http;

class AdminUserPage extends StatefulWidget {
  const AdminUserPage({super.key});

  @override
  State<AdminUserPage> createState() => _AdminUserPageState();
}

// ignore: camel_case_types
class _AdminUserPageState extends State<AdminUserPage> {
  String? data;
  String? data2;
  dynamic getUser;
  dynamic getUser2;
  bool isLoading=true;

  @override
  void initState(){
    super.initState();
    getdata();
  }

  Future getdata() async{
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/User_Details_Admin.php"));
    if(response.statusCode==200){
      data=response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
      });
    }
  }

  Future user(String lid) async{
      http.Response response= await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Delete_API/User.php",
    ), body: {'Login_Id' : lid});
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
        title: const Text('User List'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body : isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),) : ListView.builder(
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
                              child : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text('Name : '),
                                      Text(getUser[index]["Name"]),
                                    ],
                                  ),
                                  SizedBox(height: mdheight * 0.01,),
                                   Row(
                                     children: [
                                       const Text('Dob : '),
                                       Text(getUser[index]["Dob"]),
                                     ],
                                   ),
                                  SizedBox(height: mdheight * 0.01,),
                                  Row(
                                    children: [
                                      const Text('Gender : '),
                                      Text(getUser[index]["Gender"]),
                                    ],
                                  ),
                                  SizedBox(height: mdheight * 0.01,),
                                  const Row(
                                    children: [
                                      Text('Address : '),
                                    ],
                                  ),
                                  Text(getUser[index]["Address"]),
                                  SizedBox(height: mdheight * 0.01,),
                                  const Row(
                                     children: [
                                       Text('Licence Number : '),
                                     ],
                                   ),
                                  Text(getUser[index]["Lincence_Number"]),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MaterialButton(onPressed: (){
                              CoolAlert.show(context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Do you Remove User',
                                  confirmBtnColor: Colors.red,
                                  onConfirmBtnTap: (){
                                    user(getUser[index]["Login_Id"]).whenComplete(() {getdata();});
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
