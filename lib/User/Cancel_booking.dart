import 'package:flutter/material.dart';

class Cancel_booking extends StatefulWidget {
  const Cancel_booking({super.key});

  @override
  State<Cancel_booking> createState() => _Cancel_bookingState();
}

class _Cancel_bookingState extends State<Cancel_booking> {
  var selectedOption;
  var Reason=['Schedule change',
    'Book Another Car',
    'Found a Better Alternative',
    'Want to Book another car',
    'My Reason is not listed',
    'Other'
  ];
  @override

  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cancel Booking",style: TextStyle(color: Colors.black,fontSize: 20),),

        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body:  SingleChildScrollView(
        physics: BouncingScrollPhysics(),


        child: Container(
          padding: EdgeInsets.only(top: 5,right: 8,left: 8),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 19),
                child: Text("Please Select the reason for cancellation:",style: TextStyle(color: Colors.grey,fontSize: 15),),
              ),
              SizedBox(height: mheight*0.02,),

              for (String option in [
                'Schedule change',
                'Book Another Car',
                'Found a Better Alternative',
                'Want to Book another car',
                'My Reason is not listed',
                'Other'
              ])

                RadioListTile(
                  title: Text(option,style: TextStyle(fontSize: 18),),
                  value: option,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value.toString();
                    });
                  },
                ),
              // SizedBox(height: 20),
              // Text('Selected Option: $selectedOption'),

              Divider(height: mheight*0.04,),

              Container(
                padding: EdgeInsets.only(left: 12,right: 12),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  cursorColor: Colors.deepPurple.shade800,
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: "Enter Your Reason",
                      focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple.shade800)
                      ),
                      border: const OutlineInputBorder()
                  ),
                ),
              ),

              //button
              SizedBox(height: mheight*0.08,),
               Container(
                 padding: EdgeInsets.only(left: 12,right: 12,),
                 height: mheight*0.07,
                 width: mwidth,
                 child: ElevatedButton(
                   onPressed: (){},
                   child: Text('Cancel Ride'),
                 ),
               )
            ],
          ),
        ),
      ),

    );
  }
}
