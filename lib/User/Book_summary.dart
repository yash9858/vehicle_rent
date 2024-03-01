//shri Gneshay Nam:


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentify/Admin/CancelBooking_Admin.dart';
import 'package:rentify/User/Cancel_booking.dart';
class Book_summary extends StatefulWidget {

  const Book_summary({super.key});


  @override
  State<Book_summary> createState() => _Book_summaryState();
}


class _Book_summaryState extends State<Book_summary> {
DateTime _dateTime=DateTime(2023,1,12);
TimeOfDay _timeOfDay = TimeOfDay(hour: 8,minute: 10);
void _showdatepicker(){
  showDatePicker(
      context: context,
      firstDate: DateTime(2020), lastDate: DateTime(2025), initialDate: _dateTime,).then((value){
        setState(() {
          _dateTime=value!;
        });
  });
  
}

void _showtimepicker(){
  showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
    setState(() {
      _timeOfDay=value!;
    });
  });
}
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Book Summary",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: mheight*0.030),),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,

      ),
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.only(top:15,left: 15,right: 15,),
          child: Column(
            children: [
              //car
              Row(

                children: [
                  //Image
                  Container(

                    child:
                  Image.network("https://i.pinimg.com/736x/5f/33/2d/5f332d3fbad470d3109cab05fb99beb6.jpg",fit: BoxFit.contain,
                    height: mheight*0.15,width: mwidth*0.4,

                  )
                    ,),
                  SizedBox(width: mwidth*0.02,),
                  Expanded(child: Column(
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
                      SizedBox(height: mheight*0.01,),

                      //Car Name
                      Text("Kia Seltos Htk",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      SizedBox(height: mheight*0.03,),
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
                    ],
                  ))

                ],
              ),

              Divider(
                height: mheight*0.05,

              ),
              //Calender

              Container(
                child: Column(
                  children: [
                    //pick up time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("Pick-Up Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                       Text(_timeOfDay.format(context).toString(),style: TextStyle(fontSize: 16,)),

                     ],
                    ),

                    SizedBox(height: mheight*0.02,),
                    //Pick up date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Pick-Up Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        Text(DateFormat('d MMM yy').format(_dateTime),style: TextStyle(fontSize: 16,)),

                      ],
                    ),

                    SizedBox(height: mheight*0.02,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Return  Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        Text(_timeOfDay.format(context).toString(),style: TextStyle(fontSize: 16,)),

                      ],
                    ),

                     SizedBox(height: mheight*0.02,),
                    //Pick up date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Return Date",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        Text(DateFormat('d MMM yy').format(_dateTime),style: TextStyle(fontSize: 16,)),

                      ],
                    ),
                  ],
                ),
              ),

              Divider(
                height: mheight*0.05,
              ),

              //Amount
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                        Text("₹450/day",),
                      ],
                    ),
                    SizedBox(height: mheight*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Days",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                        Text("5"),
                      ],
                    ),
                    Divider(
                      height: mheight*0.05,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                        Text("₹5990/day"),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: mheight*0.08,),




            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.only(bottom: 5,left: 10,right: 10),
        width: double.infinity,
        height: mheight*0.08,
        child: MaterialButton(
          color: Colors.deepPurple.shade800,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Cancel_booking_user()));
          },
          child: Text("Cancel", style: TextStyle(color: Colors.white),),
        ),
      ),
    );

  }
}

