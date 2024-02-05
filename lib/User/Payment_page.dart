import 'package:flutter/material.dart';
import 'package:rentify/User/Add_Card.dart';

class Payment_page extends StatefulWidget {
  const Payment_page({super.key});

  @override
  State<Payment_page> createState() => _Payment_pageState();
}

class _Payment_pageState extends State<Payment_page> {
  var selectedOption;
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Payment Methods",style: TextStyle(color: Colors.black,fontSize: mheight*0.030),),
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
                      value: 1,
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
      bottomSheet:  Container(
        padding: EdgeInsets.only(left: 12,right: 12,bottom: 8),
        height: mheight*0.07,
        width: mwidth,
        child: ElevatedButton(
          onPressed: (){},
          child: Text('Confirm Payment'),
        ),
      ),
    );

  }
}
