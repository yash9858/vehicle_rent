import 'package:flutter/material.dart';

class Edit_Profile extends StatefulWidget {
  const Edit_Profile({super.key});

  @override
  State<Edit_Profile> createState() => _Edit_ProfileState();
}

class _Edit_ProfileState extends State<Edit_Profile> {

  void _showDatePicker(){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }
  int _value = 1;
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text('Edit Profile'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(mdheight * 0.02),
          child: Column(
            children: [
              Center(
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(
                            "assets/img/Logo.jpg"),
                      ),
                      Positioned(
                        left: 80,
                        bottom: 1,
                        child: CircleAvatar(

                          child: IconButton(
                              onPressed: (){

                              },
                              icon:const Icon(Icons.edit)),
                        ),
                      )
                    ],
                  )),
              SizedBox(height: mdheight * 0.04),
              TextField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Enter Your Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: mdheight * 0.025,),
              TextField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Enter Your Address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: mdheight * 0.025,),
              TextField(
                keyboardType: TextInputType.datetime,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Enter Your DOB',
                    suffixIcon: IconButton(
                      onPressed: _showDatePicker,
                      icon: Icon(Icons.calendar_month),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: mdheight * 0.025,),
              TextField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Enter Your Licence Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
              ),
              SizedBox(height: mdheight * 0.025,),
              Row(
                  children:[
                    Radio(
                      value: 1,
                      groupValue: _value,
                      onChanged: (value){
                        setState(() {
                          _value = value!;
                        });
                      },
                    ),
                    Text('Male', style: TextStyle(fontSize: 18)),
                    Radio(
                      value: 2,
                      groupValue: _value,
                      onChanged: (value){
                        setState(() {
                          _value = value!;
                        });
                      },
                    ),
                    Text('Female', style: TextStyle(fontSize: 18)),
                    Radio(
                      value: 3,
                      groupValue: _value,
                      onChanged: (value){
                        setState(() {
                          _value = value!;
                        });
                      },
                    ),
                    Text('Other', style: TextStyle(fontSize: 18)),
                  ]),
              SizedBox(height: mdheight * 0.04,),
              Container(
                  height: MediaQuery.sizeOf(context).height * 0.050,
                  width: MediaQuery.sizeOf(context).width * 0.70,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(mdheight * 0.015),
                  ),
                  child:ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(mdheight * 0.02),
                        )),
                    child: Text('Save Details',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: mdheight * 0.025,
                            fontWeight: FontWeight.bold)),
                  )
              )],
          ),
        ),
      ),
    );
  }
}