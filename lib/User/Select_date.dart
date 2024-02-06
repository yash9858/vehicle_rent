

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:rentify/User/Payment_page.dart';


class Select_date extends StatefulWidget {
  const Select_date({super.key});

  @override
  State<Select_date> createState() => _Select_dateState();
}

class _Select_dateState extends State<Select_date> {
  DateTime _PickupDate=DateTime(2023,1,12);
  TimeOfDay _PickupTime = TimeOfDay(hour: 8,minute: 10);
  DateTime _ReturnDate=DateTime(2023,1,12);
  TimeOfDay _ReturnTime = TimeOfDay(hour: 8,minute: 10);
  void Pickupdate(){
    showDatePicker(
      context: context,
      firstDate: DateTime(2020), lastDate: DateTime(2025), initialDate: _PickupDate,).then((value){
      setState(() {
        _PickupDate=value!;


      });
    });

  }
  void ReturnDate(){
    showDatePicker(
      context: context,
      firstDate: DateTime(2020), lastDate: DateTime(2025), initialDate: _PickupDate,).then((value){
      setState(() {

        _ReturnDate=value!;

      });
    });

  }
  void PickupTime(){
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
      setState(() {
        _PickupTime=value!;

      });
    });
  }
  void ReturnTime(){
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
      setState(() {

        _ReturnTime=value!;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    //var time.text="helo";
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        title: Text("Select Date and Time",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: mheight*0.030),),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,

      ),





      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(top:15,left: 15,right: 15,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                height: mheight*0.07,

              ),


              //Pick up date and time
              Container(
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pick Up Date and Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                    SizedBox(height:mheight*0.025),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         //Time row
                        Container(
                          width:mwidth*0.4,
                          padding:EdgeInsets.only(left: 10,right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                           color:Colors.grey.shade100,
                            border: Border.all(
                              width: 1
                            )

                          ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(_PickupTime.format(context).toString(),style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                            IconButton(onPressed: PickupTime, icon: Icon(Icons.timer_outlined,color: Colors.deepPurple.shade400,))
                          ],
                        ),

                        ),


                        //Day Row
                        Container(
                          width:mwidth*0.4,
                          padding:EdgeInsets.only(left: 5,),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                               color:Colors.grey.shade100,
                              border: Border.all(
                                  width: 1
                              )

                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text(DateFormat('d MMM yy').format(_PickupDate),style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                              IconButton(onPressed: Pickupdate, icon: Icon(Icons.calendar_month_outlined,color: Colors.deepPurple.shade400,))
                            ],
                          ),

                        ),
                      ],
                    )

                  ],
                ),
              ),


              Divider(
                height: mheight*0.05,

              ),

              //Return Data and time
              Container(
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Return  Date and Time",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                    SizedBox(height:mheight*0.025),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Time row
                        Container(
                          width:mwidth*0.4,
                          padding:EdgeInsets.only(left: 10,right: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:Colors.grey.shade100,

                              border: Border.all(
                                  width: 1
                              )

                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text(_ReturnTime.format(context).toString(),style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                              IconButton(onPressed: ReturnTime, icon: Icon(Icons.timer_outlined,color: Colors.deepPurple.shade400,))
                            ],
                          ),

                        ),


                        //Day Row
                        Container(
                          width:mwidth*0.4,
                          padding:EdgeInsets.only(left: 5,),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                               color: Colors.grey.shade100,
                              border: Border.all(
                                  width: 1
                              )

                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text(DateFormat('d MMM yy').format(_ReturnDate),style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                              IconButton(onPressed: ReturnDate, icon: Icon(Icons.calendar_month_outlined,color: Colors.deepPurple.shade400,))
                            ],
                          ),

                        ),
                      ],
                    )

                  ],
                ),
              ),

              Divider(
                height: mheight*0.04,

              ),

              //Address
              Text("Address",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              SizedBox(height: mheight*0.01,),
              Container(
              //  padding: EdgeInsets.only(left: 12,right: 12),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  cursorColor: Colors.deepPurple.shade800,
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: "Enter Your Delivary Address",
                      focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple.shade800)
                      ),
                      border: const OutlineInputBorder()
                  ),
                ),
              ),



            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 5,left: 10,right: 10),
        width: double.infinity,
        height: mheight*0.08,
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Payment_page()));
          },
          child: Text("Payment",style: TextStyle(fontSize: 15),),
        ),
      ),
    );
  }
}
