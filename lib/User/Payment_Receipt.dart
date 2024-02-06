// ignore_for_file: camel_case_types, file_names

import 'package:flutter/Material.dart';

class Payment_Receipt extends StatefulWidget {
  const Payment_Receipt({super.key});

  @override
  State<Payment_Receipt> createState() => _Payment_ReceiptState();
}

class _Payment_ReceiptState extends State<Payment_Receipt> {
  var name = ['Vehicle', 'Type', 'Category','Booking Date And Time'];
  var val = ['Toyota', 'Car', 'SUV', '3 feb 18.00'];
  var date = [ 'Pick Up Date', 'Return Date', 'Payment Mode'];
  var dval = ['4 Feb', '7 Feb', 'Online'];
  var price= ['Amount', 'Total Hour', 'Total Price'];
  var pval =['20.0', '72', '1440' ];
  var user = ['Name', 'Phone No:', 'Payment Id'];
  var uval = ['yash', '****', '864335'];
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Payment Details",style: TextStyle(color: Colors.black,fontSize: 20),),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
          children:[
            ListView.builder(
                shrinkWrap: true,
                itemCount: user.length,
                itemBuilder: (context, int index)
                {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(user[index], style: const TextStyle(fontSize: 16),),
                        Text(uval[index], style: const TextStyle(fontSize: 16),),
                      ],
                    ),
                  );
                }),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
                itemCount: name.length,
                itemBuilder: (context, int index)
            {
              return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name[index], style: const TextStyle(fontSize: 16),),
                      Text(val[index], style: const TextStyle(fontSize: 16),),
                    ],
                  ),
              );
            }),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Address', style: TextStyle(fontSize: 16),),
                  SizedBox(width: 100,),
                  Expanded(child: Text('NGCCA Navgujarat near asharam road, ahemdabad', style: TextStyle(fontSize: 16),)),
                ],
              ),
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
                itemCount: date.length,
                itemBuilder: (context, int index)
            {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(date[index], style: const TextStyle(fontSize: 16),),
                    Text(dval[index], style: const TextStyle(fontSize: 16),),
                  ],
                ),
              );
            }),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
                itemCount: price.length,
                itemBuilder: (context, int index)
            {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price[index], style: const TextStyle(fontSize: 16),),
                    Text(pval[index], style: const TextStyle(fontSize: 16),),
                  ],
                ),
              );
            }),
          ]
        )),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 5,left: 10,right: 10),
        width: double.infinity,
        height: mdheight*0.08,
        child: ElevatedButton(
          onPressed: (){},
          child: const Text("Continue", style: TextStyle(fontSize: 17),),
        ),
      ),
    );
  }
}
