import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentify/User/Add_Card.dart';
import 'package:rentify/User/User_DashBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Payment_page extends StatefulWidget {
  const Payment_page({super.key});

  @override
  State<Payment_page> createState() => _Payment_pageState();
}

class _Payment_pageState extends State<Payment_page> {

  bool isLoading=false;
  var data;
  var data2;
  var getUser2;
  var getUser3;
  var bid;


  void initState(){
    super.initState();
    booking();
    payment();
  }


  Future booking() async{
    SharedPreferences share=await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/User_Fetch_API/Payment_Booking_Fetch.php"),
        body: {'Login_Id':share.getString('id')});
    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data!)["users"];
        bid = jsonDecode(data!)["users"][0]["Booking_Id"];
      });
    }
  }
  Future payment() async{
    SharedPreferences share=await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Insert_API/Payment_Insert.php"),
        body: {
          'Payment_Mode': selectedOption,
          'Booking_Id': bid,
          'Total_Price': "3000",
          'Login_Id':share.getString('id')});
    if(response.statusCode==200) {
      data2 = response.body;
      print(data2);
      setState(() {
        isLoading=false;
        getUser3=jsonDecode(data2!)["users"];
      });
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UserDasboard()), (route) => false);
    }
  }




  var selectedOption;

  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Payment Methods",style: TextStyle(color: Colors.black,fontSize: mheight*0.030, fontWeight: FontWeight.bold),),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,

      ),
      body: Container(
        padding: EdgeInsets.only(top: 15,right: 15,left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Cash

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("Cash",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: mheight*0.01,),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),

                  child: ListTile(
                    leading: Icon(Icons.money,color: Colors.deepPurple.shade400,),
                    title: const Text('cash',style: TextStyle(color: Colors.grey)),
                    trailing: Radio(
                      value: 'cash',
                      activeColor: Colors.deepPurple.shade400,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                          print("Button value: $value");
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: mheight*0.02,),

            //Credit Card
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("Card",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: mheight*0.01,),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),

                  child: ListTile(
                    leading: Icon(Icons.credit_card_outlined,color: Colors.deepPurple.shade400,),
                    title: const Text('Add Card',style: TextStyle(color: Colors.grey),),
                    trailing: IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Credit_Card()));
                      },
                    icon: Icon(Icons.arrow_forward_ios,color: Colors.deepPurple.shade400,)),
                  ),
                ),
              ],
            ),



            SizedBox(height: mheight*0.05,),
            //other option
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("More Payment Options",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: mheight*0.01,),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),

                  child: Column(
                    children: [

                      for (String option in [
                        'paypal',
                        'Google pay',
                        'Paytm'
                      ])

                        RadioListTile(
                          title: Text(option,style: TextStyle(fontSize: 18,),),
                          value: option,
                          activeColor: Colors.deepPurple.shade400,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value.toString();
                            });
                          },
                        ),

                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 5,left: 10,right: 10),
        width: double.infinity,
        height: mheight*0.08,
        child: ElevatedButton(
          onPressed: (){
            payment();
          },
          child: Text("Confirm Payment",style: TextStyle(fontSize: 15),),
        ),
      ),
    );

  }
}
