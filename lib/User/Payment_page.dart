import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentify/User/Add_Card.dart';
import 'package:rentify/User/User_DashBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Payment_page extends StatefulWidget {
  final String v2_id;
  final String price;
  final String startd;
  final String startt;
  final String returnd;
  final String returnt;
  final String starty;
  final String startm;
  final String returnm;
  final String returny;

  const Payment_page({super.key ,required this.v2_id,required this.price,
    required this.starty,
    required this.startm,
    required this.startd,
    required this.startt,
    required this.returnd,
    required this.returny,
    required this.returnm,
    required this.returnt
    });

  @override
  State<Payment_page> createState() => _Payment_pageState();
}

class _Payment_pageState extends State<Payment_page> {

  bool isLoading=true;
  var data;
  var data2;
  var data3;
  var getUser;
  var getUser2;
  var bid;
  var bstat;
  var total_price;


  void initState(){
    super.initState();
    booking();
    total_price = calculateTotalPrice(DateTime(int.parse(widget.starty),int.parse(widget.startm), int.parse(widget.startd)), double.parse(widget.startt),  DateTime(int.parse(widget.returny),int.parse(widget.returnm),int.parse(widget.returnd)), double.parse(widget.returnt));
  }

  double calculateTotalPrice(DateTime startDate, double startHour, DateTime endDate, double endHour) {
    // Define price per date
    double pricePerDate = double.parse(widget.price);
    // Calculate total number of days
    int totalDays = endDate.difference(startDate).inDays;
    // If the same day, but different hours, consider it as one day
    if (totalDays == 0 && endHour > startHour) {
      totalDays = 0;
    }
    // Calculate total price
    double totalPrice = totalDays * pricePerDate;
    // If the start and end hours are different, add extra charge
    if (endHour > startHour) {
      totalPrice += (endHour - startHour) * (pricePerDate / 24);
    }
    return totalPrice;
  }


  Future booking() async{
    SharedPreferences share=await SharedPreferences.getInstance();
    http.Response response= await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/User_Fetch_API/Payment_Booking_Fetch.php"),
        body: {'Login_Id':share.getString('id')});
    if(response.statusCode==200) {
      data = response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
        bid = jsonDecode(data!)["users"][0]["Booking_Id"];
        payment();
      });
    }
  }

  Future payment() async{
    SharedPreferences share=await SharedPreferences.getInstance();
    http.Response response= await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Insert_API/Payment_Insert.php"),
        body: {
          'Payment_Mode': selectedOption,
          'Booking_Id': bid,
          'Total_Price': total_price.toString(),
          'Login_Id':share.getString('id')});
    if(response.statusCode==200) {
      data2 = response.body;
      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data2!)["users"];
      });
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UserDasboard()), (route) => false);
    }
  }



  Future Bstatus() async{
    http.Response response= await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Update_API/Booking_Status_Update_Payment.php"),
        body: {
          'Booking_Id': bid,});
    if(response.statusCode==200) {
      data3 = response.body;
      print(data3);
      setState(() {
        isLoading=false;
        bstat=jsonDecode(data3!)["users"];

      });
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UserDasboard()), (route) => false);
    }
  }


  var selectedOption;
var total;
var x;
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
                ListTile(
                  title: const Text('Total Price',style: TextStyle(fontSize: 17)),
                  trailing: Text("₹"+total_price.toString(),style: TextStyle(fontSize: 17)),
                ),
                SizedBox(height: mheight*0.02,),
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
            // Bstatus();
          },
          child: Text("Confirm Payment",style: TextStyle(fontSize: 15),),
        ),
      ),
    );
  }
}
