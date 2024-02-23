import 'package:flutter/material.dart';

class Cancel_Bookings extends StatefulWidget {
  const Cancel_Bookings({super.key});

  @override
  State<Cancel_Bookings> createState() => _Cancel_BookingsState();
}

class _Cancel_BookingsState extends State<Cancel_Bookings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(" Cancel bookings"),
          backgroundColor: Color.fromRGBO(92, 198, 208, 1),
        ),
        body:ListView.builder(
            itemCount: 4,
            itemBuilder: (BuildContext context,int index){
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children:[
                        Text((index+1).toString()+". ",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("yash",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                      ]),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text("Booknig id : ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("3"),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text("Reason : ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Expanded(child: Text("Mood change"),
                          )],
                      ),
                      SizedBox(height: 10),
                      Text("Cancel Booking Date & Time : ",style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("2024-10-12"),
                      //Text("Booking Date & Time 17-11-2023,11:45 AM"),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            })
    );
  }
}
