import 'dart:convert';
import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;

class AdminFeedbackPage extends StatefulWidget {
  const AdminFeedbackPage({super.key});

  @override
  State<AdminFeedbackPage> createState() => _AdminFeedbackPageState();
}


class _AdminFeedbackPageState extends State<AdminFeedbackPage> {

  String? data;
  dynamic getUser;
  bool isLoading=false;

  @override
  void initState(){
    super.initState();
    getdata();
  }

  Future getdata() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Feedback_Admin.php"));
    if(response.statusCode==200){
      data=response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
      });
    }
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy  HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text('Feedbacks'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body:isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),) : ListView.builder(
        itemCount: getUser.length,
        itemBuilder: (BuildContext context, int index)
        {
          return Padding(padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.025, vertical: mdheight * 0.005),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.all(mdheight * 0.01),
                shadowColor: Colors.deepPurple.shade800,
                semanticContainer: true,
                surfaceTintColor: Colors.deepPurple.shade800,
                child: Padding(
                  padding: EdgeInsets.all(mdheight * 0.017),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text('User Name: '),
                              Text(getUser[index]["Name"]),
                            ],
                          ),
                          Text(formatDate(getUser[index]["Feedback_Time"])),
                        ],
                      ),
                      SizedBox(height: mdheight * 0.01,),
                      Row(
                        children: [
                          const Text('Vehicle Name: '),
                          Text(getUser[index]["Vehicle_Name"]),
                        ],
                      ),
                      SizedBox(height: mdheight * 0.01,),
                      Row(
                        children: [
                          const Text('Comments: '),
                          Text(getUser[index]["Comment"]),
                        ],
                      ),
                      SizedBox(height: mdheight * 0.01,),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(getUser[index]["Ratings"]),
                          SizedBox(width: mdwidth * 0.002,),
                          const Icon(LineIcons.starAlt, color: Colors.amber),
                        ],
                      )
                    ],
                  ),
                ),
              ));
        }),
    );
  }
}
