// ignore_for_file: file_names, depend_on_referenced_packages, camel_case_types
import 'package:flutter/material.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedBack_User extends StatefulWidget {
  const FeedBack_User({super.key});

  @override
  State<FeedBack_User> createState() => _FeedBack_UserState();
}

class _FeedBack_UserState extends State<FeedBack_User> {
  double rating = 0;
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
    title: const Text('Review And Rating'),
    backgroundColor: Colors.deepPurple.shade800,
    iconTheme: const IconThemeData(
    color: Colors.white,
    ),
    centerTitle: true,
    ),
      body:  SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.only(top:15,left: 15,right: 15),
        child: Column(
          children: [
        //car
        Row(
        children: [
        //Image
          Image.asset("assets/img/tesla.jpg",
            fit: BoxFit.contain,
            height: mdheight * 0.15,
            width: mdwidth * 0.4,
        ),
      SizedBox(width: mdwidth*0.015,),
      Expanded(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Container(
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                  decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(6)
                  ),
                  child: const Text("suv")),
          SizedBox(height: mdheight*0.01,),
          const Text("Kia Seltos Htk",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height: mdheight*0.02,),
        ],
      ))
      ],
    ),
    Divider(
    height: mdheight*0.03,
    ),
           const  Center(child:Text('How Is Your Rental', style: TextStyle(fontSize: 24),)),
            const Center(child:Text('Experience ?', style: TextStyle(fontSize: 23),)),
            Divider(
              height: mdheight*0.03,
            ),
      SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(mdheight * 0.012),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Ratings & Reviews",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(mdheight * 0.02),
                                  )),
                              onPressed: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                content: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    review()
                                  ],
                                ),
                                actionsAlignment: MainAxisAlignment.spaceBetween,
                                actions: [
                                  OutlinedButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child:const Text("Cancel") ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(mdheight * 0.02),
                                        )),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child:const Text("Submit")),
                                ],
                              );
                            });
                          }, child: const Text("Write Review")),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const RatingSummary(
                        counter: 15,
                        average: 4,
                        counterFiveStars: 7,
                        counterFourStars: 4,
                        counterThreeStars: 2,
                        counterTwoStars: 1,
                        counterOneStars: 1,
                      ),
                    ],
                  ),
                ),
              Divider(
                height: mdheight * 0.03,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (BuildContext context,int index){
                    return Column(
                        children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  trailing: const Text("Timestamp"),
                                  title: const Text("Name",style: TextStyle(fontWeight: FontWeight.bold,),),
                                  subtitle: RatingBar.builder(
                                          initialRating: 0,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          itemSize: 30,
                                          itemCount: 5,
                                          allowHalfRating: true,
                                          itemBuilder: (context,_) => const Icon(Icons.star,color: Colors.amber,),
                                          onRatingUpdate: (value) {
                                            setState(() {
                                              rating =value;
                                            });
                                          },
                                    ),
                                  leading: Image.asset("assets/img/Logo.jpg",height: mdheight * 0.5,width: mdwidth * 0.1,),
                                ),
                                const Padding(
                                    padding:EdgeInsets.all(10),
                                    child: Text("your review"))
                              ],
                            ),
                          const Divider(
                            thickness: 1,
                          ),
                        ],
                    );
                  }),
              SizedBox(height: mdheight * 0.012,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(mdheight * 0.02),
                  color: Colors.deepPurple.shade800,
                ),
                height: mdheight*0.07,
                width: mdwidth,
                child: MaterialButton(
                  onPressed: (){},
                  child: Text('See All Review',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: mdheight * 0.025,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: mdheight * 0.012,),
              ]),
      ),
    ]),
    )));
  }
}
class review extends StatefulWidget {
  const review({super.key});
  @override
  State<review> createState() => _reviewState();
}

class _reviewState extends State<review> {
  double rating=0;
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
              initialRating: 0,
              minRating: 0,
              direction: Axis.horizontal,
              itemCount: 5,
              allowHalfRating: true,
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
          TextField(
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
          )
    ]);
  }
}
