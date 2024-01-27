import 'package:flutter/material.dart';

class Admin_PaymentPage extends StatefulWidget {
  const Admin_PaymentPage({super.key});

  @override
  State<Admin_PaymentPage> createState() => _Admin_PaymentPageState();
}

class _Admin_PaymentPageState extends State<Admin_PaymentPage> {
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdhwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
        titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: mdheight * 0.025,
    ),
    title: const Text('Payment List'),
    backgroundColor: Colors.deepPurple.shade800,
    iconTheme: const IconThemeData(
    color: Colors.white,
    ),
          centerTitle: true,
    ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index)
          {
            return Padding(padding: EdgeInsets.symmetric(horizontal: mdhwidth * 0.025, vertical: mdheight * 0.005),
                child: Card(
                  elevation: 5.0,
                  shadowColor: Colors.deepPurple.shade800,
                  semanticContainer: true,
                  surfaceTintColor: Colors.deepPurple.shade800,
                  child: Padding(
                    padding: EdgeInsets.all(mdheight * 0.017),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('User name :'),
                        SizedBox(height: mdheight * 0.01,),
                        const Text('Booking Id :'),
                        SizedBox(height: mdheight * 0.01,),
                        const Text('Vehicle Id : '),
                        SizedBox(height: mdheight * 0.01,),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Payment Mode : '),
                            Text('Payment TimeStamp'),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.01,),
                        const Text('Total Price : '),
                        SizedBox(height: mdheight * 0.01,),
                        const Text('Payment Status : '),
                        SizedBox(height: mdheight * 0.01,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(onPressed: (){
                            showDialog(context: context, builder: (context)
                            {
                              return Dialog(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: mdhwidth * 0.03),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: mdheight * 0.02),
                                          Padding(
                                            padding: EdgeInsets.only(left : mdhwidth * 0.05, right: mdhwidth * 0.01,),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children :[
                                                const Text('Cancle Id: 1'),
                                                SizedBox(height: mdheight * 0.01),
                                                const Text('Vehicle Id : 1'),
                                                SizedBox(height: mdheight * 0.01),
                                                const Text('Vehicle Name : Tesla'),
                                                SizedBox(height: mdheight * 0.01),
                                                const Text('Vehicle Type : Car'),
                                                SizedBox(height: mdheight * 0.01),
                                                const Text('Vehicle Description : This Is Fully Automated Car'),
                                                SizedBox(height: mdheight * 0.01),
                                                const Text('Rent Price: 500/day'),
                                                SizedBox(height: mdheight * 0.01),
                                                const Text('Availability : True'),
                                                SizedBox(height: mdheight * 0.01),
                                              ],
                                            ),
                                          ),
                                          MaterialButton(onPressed: (){
                                            Navigator.pop(context);
                                          },
                                              color: Colors.deepPurple.shade800,
                                              elevation: 5.0,
                                              child: const Text('Refund', style: TextStyle(color: Colors.white,),)),
                                          SizedBox(height: mdheight * 0.01),
                                        ]
                                    ),
                                  ));
                          });
                          },
                              color: Colors.deepPurple.shade800,
                              padding: EdgeInsets.symmetric(horizontal: mdhwidth * 0.05, vertical: mdhwidth * 0.01),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                              ),

                              child: const Text('Proceed Refund', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              )),
                        ],
                      ),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}
