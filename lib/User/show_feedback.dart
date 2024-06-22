import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShowFeedback extends StatefulWidget {
  final int num;
  final String vid;
  final String type;
  const ShowFeedback({super.key, required this.num, required this.vid,required this.type});

  @override
  State<ShowFeedback> createState() => _ShowFeedbackState();
}

class _ShowFeedbackState extends State<ShowFeedback>{
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
      body:  isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
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
    );
  }
}