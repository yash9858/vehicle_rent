import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rentify/User/Payment_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Select_date extends StatefulWidget {
  final int num;
  final String v_id;
  final String v_type;
  const Select_date({required this.num, required this.v_id,required this.v_type});

  @override
  State<Select_date> createState() => _Select_dateState();
}

class _Select_dateState extends State<Select_date> {

  TextEditingController startdate = TextEditingController();
  TextEditingController returndate = TextEditingController();
  TextEditingController starttime = TextEditingController();
  TextEditingController returntime = TextEditingController();
  final _formKey2 = GlobalKey<FormState>();
  var logindata;

  TextEditingController address = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading=false;
  var data;
  var data2;
  var data3;
  var data4;
  List list= [];
  var getUser;
  var getUser2;
  var getUser3;
  var getUser4;

  void initState(){
    super.initState();
    v_det();
    address_fetch();
    ratings();
    address_update();
  }

  Future v_det() async{
    setState(() {
      isLoading = true;
    });
    final loginUrl = Uri.parse(
        "https://road-runner24.000webhostapp.com/API/User_Fetch_API/Select_Fetch_Vehicle.php");

    final response = await http
        .post(loginUrl, body: {
      "Vehicle_Type": widget.v_type,
    });

    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
      });
    }
  }

  Future address_fetch() async{
    SharedPreferences share=await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/User_Fetch_API/Address_Booking.php"),
        body: {'Login_Id':share.getString('id')});
    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data!)["users"];
        address.text = getUser2[0]["Address"];
      });
    }
  }

  Future address_update() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    final form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });
      final login_url = Uri.parse(
          "https://road-runner24.000webhostapp.com/API/Update_API/Address_Booking.php");
      final response = await http
          .post(login_url, body: {
        "Login_Id": share.getString('id'),
        "Address": address.text,
      });
      if (response.statusCode == 200) {
        data2 = jsonDecode(response.body);
        getUser4 = jsonDecode(response.body)["users"];
        setState(() {
          isLoading = false;
        });
        if (data2['error'] == false) {
          Fluttertoast.showToast(
              msg: data2['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
          Navigator.push(context , MaterialPageRoute(builder: (context) => Payment_page()));
        }else{
          Fluttertoast.showToast(
              msg: data2['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
        }
      }
    }
  }


  Future ratings() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Car_Details_Feedback.php",
    ),body: {'Vehicle_Id' : widget.v_id});

    if(response.statusCode==200) {
      data3 = response.body;

      setState(() {
        isLoading=false;
        getUser3=jsonDecode(data3!)["users"];
        for(var data in getUser3){
          list.add(double.parse(data["Ratings"]));
        }
      }
      );
    }
  }

  double avg()
  {
    if(list.isEmpty)
      return 0.0;
    double sum = 0.0;
    for(var rating in list)
    {
      sum += rating;
    }
    return sum /list.length;
  }

  Future<void> _submit() async {
    SharedPreferences s=await SharedPreferences.getInstance();
    final form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        isLoading = true;
      });
      final login_url = Uri.parse(
          "https://road-runner24.000webhostapp.com/API/Insert_API/Booking_Insert.php");
      final response = await http
          .post(login_url, body: {
        "Start_Date": (_PickupDate.year).toString()+"-"+(_PickupDate.month).toString()+"-"+(_PickupDate.day).toString(),
        "Start_Time": (_PickupTime.hour).toString()+":"+(_PickupTime.minute).toString(),
        "Return_Date": (_ReturnDate.year).toString()+"-"+(_ReturnDate.month).toString()+"-"+(_ReturnDate.day).toString(),
        "Return_Time": (_ReturnTime.hour).toString()+":"+(_ReturnTime.minute).toString(),
        "Vehicle_Id": widget.v_id,
        "Vehicle_Type": widget.v_type,
        "Login_Id":s.getString('id'),
      });
      if (response.statusCode == 200) {
        logindata = jsonDecode(response.body);
        data = jsonDecode(response.body)['user'];
        setState(() {
          isLoading = false;
        });
        if (logindata['error'] == false) {
          Fluttertoast.showToast(
              msg: logindata['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
          Navigator.push(context , MaterialPageRoute(builder: (context) => Payment_page()));
        }else{
          Fluttertoast.showToast(
              msg: logindata['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
        }
      }
    }

  }

  DateTime _PickupDate=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  TimeOfDay _PickupTime = TimeOfDay(hour: DateTime.now().hour,minute: DateTime.now().minute);
  DateTime _ReturnDate=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  TimeOfDay _ReturnTime = TimeOfDay(hour: DateTime.now().hour,minute: DateTime.now().minute);

  void Pickupdate(){
    showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month , DateTime.now().day), lastDate: DateTime(2025), initialDate: _PickupDate,).then((value){
      setState(() {
        _PickupDate=value!;
      });
    });

  }
  void ReturnDate(){
    showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year, DateTime.now().month , DateTime.now().day), lastDate: DateTime(2025), initialDate: _PickupDate,).then((value){
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Select Date and Time",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: mheight*0.030),),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),

      body: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
      : SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top:15,left: 15,right: 15,),
          child: Form(
              key: _formKey2,
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(

                children: [
                  //Image
                  Container(

                    child:
                    Image.network(getUser[widget.num]["Vehicle_Image"],fit: BoxFit.contain,
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
                          isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
                          : Container(
                              padding: EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                              decoration: BoxDecoration(
                                  color: Colors.pink.shade50,
                                  borderRadius: BorderRadius.circular(6)
                              ),
                              child: Text(getUser[widget.num]["Category_Name"])),
                          isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
                          : Row(
                            children: [
                              Text(avg().toString()),
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
                      Text(getUser[widget.num]["Vehicle_Name"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      SizedBox(height: mheight*0.03,),
                      Row(
                        children: [
                          Text(
                            "₹"+getUser[widget.num]["Rent_Price"],
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
                          )),



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
              Form(
                key : _formKey,
                child: TextFormField(
                  controller: address,
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
                      border: const OutlineInputBorder(

                      )
                  ),
                ),
                ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 5,left: 10,right: 10),
        width: double.infinity,
        height: mheight*0.08,
        child: ElevatedButton(
          onPressed: (){
            address_update();
            _submit();
          },
          child: Text("Payment",style: TextStyle(fontSize: 15),),
        ),
      ),
    );
  }
}
