import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedBackUser extends StatefulWidget {
  final int num;
  final String vid;
  final String type;
  const FeedBackUser({
    super.key,
    required this.num,
    required this.vid,
    required this.type
  });

  @override
  State<FeedBackUser> createState() => _FeedBackUserState();
}

class _FeedBackUserState extends State<FeedBackUser> {
  bool isLoading=true;
  dynamic data;
  dynamic allRat;

  @override
  void initState(){
    super.initState();
    allRating();
  }

  Future allRating() async{
    setState(() {
      isLoading=true;
    });
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Car_Details_Feedback.php",
    ),body: {'Vehicle_Id' : widget.vid});
    if(response.statusCode==200) {
      data = response.body;
      setState(() {
        isLoading=false;
        allRat=jsonDecode(data!)["users"];
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
        body:  isLoading ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
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
                                itemCount: allRat.length,
                                itemBuilder: (BuildContext context,int index){
                                  return Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            trailing: Text(allRat[index]["Feedback_Time"].toString(), style: const TextStyle(color: Colors.black),),
                                            title: Text(allRat[index]["Name"],style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                                            subtitle: RatingBar.builder(
                                              ignoreGestures: true,
                                              initialRating: double.parse(allRat[index]["Ratings"]),
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
                                            leading: Image.network(allRat[index]["Profile_Image"],height: mdheight * 0.5,width: mdwidth * 0.1,),
                                          ),
                                          Padding(
                                              padding:const EdgeInsets.all(10),
                                              child: Text(allRat[index]["Comment"], style: const TextStyle(
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
            padding: const EdgeInsets.all(15),
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
                            Review(vid: widget.vid, type: widget.type,vNum: widget.num,)
                          ],
                        ),
                      );
                    });
                  }, child: const Text("Write Review", style: TextStyle(fontSize: 17),)),
            )
        ));
  }
}
class Review extends StatefulWidget {
  final int vNum;
  final String vid;
  final String type;
  const Review({super.key,required this.vid, required this.type, required this.vNum});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {

  dynamic logindata;
  bool isLoading=false;
  dynamic data;
  TextEditingController comment = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      if (comment.text.trim().isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences s = await SharedPreferences.getInstance();
        final loginUrl = Uri.parse(
            "https://road-runner24.000webhostapp.com/API/Insert_API/Feedback_Insert.php");
        final response = await http
            .post(loginUrl, body: {
          "Login_Id": s.getString('id'),
          "Vehicle_Id":widget.vid,
          "Ratings":rating.toString(),
          "Comment":comment.text,
        });
        if (response.statusCode == 200) {
          logindata = jsonDecode(response.body);
          data =
          jsonDecode(response.body)['user'];
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
            Get.back();
            Get.off(()=> FeedBackUser(num: widget.vNum, vid: widget.vid, type: widget.type));
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
      else {
        Fluttertoast.showToast(
            msg: "Comment cannot be empty",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2
        );
      }
    }
  }

  double rating=1;

  @override
  Widget build(BuildContext context) {
    return Column(
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
              initialRating: 1,
              minRating: 1,
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(onPressed: (){
                Get.back();
              }, child:const Text("Cancel") ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                  onPressed: (){
                    _submit();
                  },
                  child:const Text("Submit")),
            ],
          )]
    );
  }
}
