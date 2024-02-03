import 'package:flutter/material.dart';
import 'package:rentify/User/Book_summary.dart';

class History_page extends StatefulWidget {
  const History_page({super.key});

  @override
  State<History_page> createState() => _History_pageState();
}

class _History_pageState extends State<History_page> {


  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
        titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: mdheight * 0.025,
        ),
          title: const Text('Booking History'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
        color: Colors.white,
        ),
    centerTitle: true,
        ),
      body: Container(
        padding: EdgeInsets.only(top: 5,left: 8,right: 8),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return      Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
              elevation: 6,
              child: Row(

                children: [
                  //Image
                  Container(

                    child:
                    Image.network("https://imgd-ct.aeplcdn.com/664x415/n/cw/ec/148477/thar-right-front-three-quarter-5.jpeg?isig=0&q=80",fit: BoxFit.contain,
                      height: mdheight*0.15,width: mwidth*0.4,

                    )
                    ,),

                  SizedBox(width: mwidth*0.02,),


                  Expanded(

                      child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //Category
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                              decoration: BoxDecoration(
                                  color: Colors.pink.shade50,
                                  borderRadius: BorderRadius.circular(6)
                              ),
                              child: Text("suv")),
                          Row(
                            children: [
                              const Text("4.1"),
                              Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 18,
                              )
                            ],
                          )
                        ],),
                      SizedBox(height: mdheight*0.01,),

                      //Car Name
                      Text("Kia Seltos Htk",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      // SizedBox(height: mheight*0.01,),
                      //last Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Money
                          Row(
                            children: [
                              Text(
                                "₹750",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text("/day"),
                            ],
                          ),
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Book_summary()));
                          }, child: Text("View"))
                        ],
                      ),
                    ],
                  ))

                ],
              ),
            );

          },
        ),
      ),
    );
  }
}
