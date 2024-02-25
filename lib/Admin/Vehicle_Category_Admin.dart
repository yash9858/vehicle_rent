import 'dart:convert';

import 'package:flutter/Material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class Admin_CategoryPage extends StatefulWidget {
  const Admin_CategoryPage({super.key});

  @override
  State<Admin_CategoryPage> createState() => _Admin_CategoryPageState();
}

// ignore: camel_case_types
class _Admin_CategoryPageState extends State<Admin_CategoryPage> {
  String? data;
  var getUser;
  bool isLoading = false;


  void initState(){
    super.initState();
    getdata();
  }
  Future getdata() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Category_Admin.php"));
    if(response.statusCode==200){
      data=response.body;
      setState(() {
        isLoading = false;
        getUser=jsonDecode(data!)["users"];
      });
    }

  }
 // var name = ['HatchBack', 'sedan', 'Suv', 'BodyType'];
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
        title: const Text('All Category'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body : isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),) :ListView.builder(
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
                                child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text('Category Id : '+getUser[index]["Category_Id"]),

                                  SizedBox(height: mdheight * 0.01,),
                                  SizedBox(height: mdheight * 0.01,),
                                   Text('Category Name : '+getUser[index]["Category_Name"]),
                                  SizedBox(height: mdheight * 0.01,),
                                ],
                              )),
                               Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                  children:[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(getUser[index]["Category_Image"],
                                        height: mdheight * 0.1,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ]
                              ),
                            ]
                        ),
                        SizedBox(height:  mdheight * 0.015,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MaterialButton(onPressed: (){
                              showDialog(context: context, builder: (context)
                              {
                                return Dialog(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.03),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: mdheight * 0.02),
                                            Padding(
                                              padding: EdgeInsets.only(left : mdwidth * 0.05, right: mdwidth * 0.01,),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children :[
                                                  Center(
                                                      child: Stack(
                                                        children: [
                                                          const CircleAvatar(
                                                            radius: 60,
                                                            backgroundImage: AssetImage(
                                                                "assets/img/Logo.jpg"),
                                                          ),
                                                          Positioned(
                                                            left: 80,
                                                            bottom: 1,
                                                            child: CircleAvatar(

                                                              child: IconButton(
                                                                  onPressed: (){

                                                                  },
                                                                  icon:const Icon(Icons.edit)),
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                  SizedBox(height:  mdheight * 0.02,),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                        fillColor: Colors.grey.shade100,
                                                        filled: true,
                                                        hintText: 'Enter A Category Name',
                                                        border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(15)
                                                        )
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height:  mdheight * 0.02,),
                                            MaterialButton(onPressed: (){
                                             Navigator.pop(context);
                                            },
                                                color: Colors.deepPurple.shade800,
                                                elevation: 5.0,
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(15))),
                                                child: const Text('Update Category', style: TextStyle(color: Colors.white,),)),
                                            SizedBox(height: mdheight * 0.01),
                                          ]
                                      ),
                                    ));
                              });
                            },
                                color: Colors.deepPurple.shade800,
                                padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                                ),
                                child: const Text('Edit Category', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                )),
                            MaterialButton(onPressed: (){
                              CoolAlert.show(context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Do you Remove Category',
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
                                child: const Text('Delete Category', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
          showDialog(context: context, builder: (context)
          {
            return Dialog(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.03),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: mdheight * 0.02),
                        Padding(
                          padding: EdgeInsets.only(left : mdwidth * 0.05, right: mdwidth * 0.01,),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children :[
                              Center(
                                  child: Stack(
                                  children: [
                                  const CircleAvatar(
                                    radius: 60,
                                    backgroundImage: AssetImage(
                                        "assets/img/Logo.jpg"),
                                  ),
                                  Positioned(
                                    left: 80,
                                    bottom: 1,
                                    child: CircleAvatar(

                                      child: IconButton(
                                          onPressed: (){

                                          },
                                          icon:const Icon(Icons.edit)),
                                    ),
                                  )
                                ],
                              )),
                              SizedBox(height:  mdheight * 0.02,),
                              TextField(
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: 'Enter A Category Name',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15)
                                    )
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height:  mdheight * 0.02,),
                        MaterialButton(onPressed: (){
                          Navigator.pop(context);
                        },
                            color: Colors.deepPurple.shade800,
                            elevation: 5.0,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15))),
                            child: const Text('Add Category', style: TextStyle(color: Colors.white,),)),
                        SizedBox(height: mdheight * 0.01),
                      ]
                  ),
                ));
          });
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
