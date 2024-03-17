// ignore_for_file: file_names, depend_on_referenced_packages, camel_case_types
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedBack_User extends StatefulWidget {
  final int num;
  final String v_id;
  final String v_type;
  const FeedBack_User({super.key, required this.num, required this.v_id,required this.v_type});

  @override
  State<FeedBack_User> createState() => _FeedBack_UserState();
}

class _FeedBack_UserState extends State<FeedBack_User> {



  bool isLoading=false;
  var data;
  var allrat;

  void initState(){
    super.initState();
    allrating();
  }

  Future allrating() async{
    setState(() {
      isLoading = true;
    });

    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Car_Details_Feedback.php",
    ),body: {'Vehicle_Id' : widget.v_id});

    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        allrat=jsonDecode(data!)["users"];
      });
    }
  }

  double rating = 0;
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Review And Rating",style: TextStyle(color: Colors.black,fontSize: 20),),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body:
        isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),): allrat.length==0?
        Container(
          child: Center(
            child: Text("Be the first person to give Feedback",style:TextStyle(fontSize: 18)
            ),
          ),
        )
            : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top:15,left: 15,right: 15),
              child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: allrat.length,
                                itemBuilder: (BuildContext context,int index){
                                  return Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            trailing: Text(allrat[index]["Feedback_Time"].toString(), style: TextStyle(color: Colors.black),),
                                            title: Text(allrat[index]["Name"],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                                            subtitle: RatingBar.builder(
                                              ignoreGestures: true,
                                              initialRating: double.parse(allrat[index]["Ratings"]),
                                              minRating: 0,
                                              direction: Axis.horizontal,
                                              itemSize: 25,
                                              itemCount: 5,
                                              allowHalfRating: true,
                                              itemBuilder: (context,_) => const Icon(Icons.star, color: Colors.amber,),
                                              onRatingUpdate: (value) {
                                                setState(() {
                                                  rating = value;
                                                });
                                              },
                                            ),
                                            leading: Image.network(allrat[index]["Profile_Image"],height: mdheight * 0.5,width: mdwidth * 0.1,),
                                          ),
                                          Padding(
                                              padding:EdgeInsets.all(10),
                                              child: Text(allrat[index]["Comment"], style: TextStyle(
                                                color: Colors.black,),))
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 1,
                                      ),
                                    ],
                                  );
                                }),
                            SizedBox(height: mdheight * 0.012,),
                          ]),
                    ),
                  ]),
            )),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.all(15),
            child: SizedBox(
              height: mdheight*0.07,
              width: mdwidth*0.50,

              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade800, // Background color
                  ),
                  onPressed: (){
                    showDialog(context: context, builder: (context){
                      return AlertDialog(
                        content:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            review(v_id: widget.v_id,)
                          ],
                        ),
                        // actionsAlignment: MainAxisAlignment.spaceBetween,
                        // actions: [
                        //   OutlinedButton(onPressed: (){
                        //     Navigator.pop(context);
                        //   }, child:const Text("Cancel") ),
                        //   ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(mdheight * 0.02),
                        //           )),
                        //       onPressed: (){
                        //         // Navigator.pop(context);
                        //
                        //       },
                        //       child:const Text("Submit")),
                        // ],
                      );
                    });
                  }, child: const Text("Write Review", style: TextStyle(fontSize: 17),)),
            )));
  }
}
class review extends StatefulWidget {
  String v_id;
  review({super.key,required this.v_id});
  @override
  State<review> createState() => _reviewState();
}

class _reviewState extends State<review> {
  var logindata;
  bool isLoading=false;
  var data;
  TextEditingController comment = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        isLoading = true;



      });
      SharedPreferences s = await SharedPreferences.getInstance();
      final login_url = Uri.parse(
          "https://road-runner24.000webhostapp.com/API/Insert_API/Feedback_Insert.php");
      final response = await http
          .post(login_url, body: {

        "Login_Id": s.getString('id'),
        "Vehicle_Id":widget.v_id,
        "Ratings":rating.toString(),
        "Comment":comment.text,

      });
      if (response.statusCode == 200) {
        logindata = jsonDecode(response.body);
        data =
        jsonDecode(response.body)['user'];
        print(logindata);
        setState(() {
          isLoading = false;

        });
        if (logindata['error'] == false) {
          Fluttertoast.showToast(
              msg: logindata['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) => ()),
          //         (route) => false);
        } else {
          Fluttertoast.showToast(
              msg: logindata['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
        }
      }
    }
  }

  double rating=0;
  @override
  Widget build(BuildContext context) {
    return

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Rating & Review",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
          const SizedBox(
            height: 5,
          ),
          Text("Rating($rating/5.0)",),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: RatingBar.builder(
              initialRating: 0,
              minRating: 0,
              direction: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context,_) => const Icon(Icons.star,color: Colors.amber,),
              onRatingUpdate: (value) {
                setState(() {
                  rating=value;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Write your Review"),
          const SizedBox(
            height: 5,
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: comment,
              validator: (val) {
                if (val!.isEmpty
                ) {
                  return "Type your Feedback  here";
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              cursorColor: Colors.deepPurple.shade800,
              decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  hintText: "Enter Your Review",
                  focusedBorder:OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple.shade800)
                  ),
                  border: const OutlineInputBorder()
              ),
            ),
          ),
          //  actionsAlignment: MainAxisAlignment.spaceBetween,
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              OutlinedButton(onPressed: (){
                Navigator.pop(context);
              }, child:const Text("Cancel") ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                  onPressed: (){
                    // Navigator.pop(context);
                    _submit().whenComplete(() => FeedBack_User);
                  },
                  child:const Text("Submit")),
            ],

          )]);
  }
}
