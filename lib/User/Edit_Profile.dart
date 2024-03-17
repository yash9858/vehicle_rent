// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rentify/User/Profile.dart';
import 'package:rentify/User/User_DashBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class Edit_Profile extends StatefulWidget {

  Edit_Profile({super.key});

  @override
  State<Edit_Profile> createState() => _Edit_ProfileState();
}

class _Edit_ProfileState extends State<Edit_Profile> {

  TextEditingController user = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController li = TextEditingController();
  TextEditingController address = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var data;
  var getUser2;
  bool isLoading=true;
  void initState(){
    super.initState();
    getdata();
  }

  Future getdata() async{
    SharedPreferences share=await SharedPreferences.getInstance();
    http.Response response= await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Edit_Profile_User.php"),
        body: {'Login_Id':share.getString('id')});
    if(response.statusCode==200) {
      data = response.body;

      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data!)["users"];
        user.text = getUser2[0]["Name"];
        dob.text = getUser2[0]["Dob"];
        li.text = getUser2[0]["Lincence_Number"];
        address.text = getUser2[0]["Address"];
        _value=getUser2[0]["Gender"];
      });
    }
  }
  final ImagePicker _picker = ImagePicker();
  File? _image;
  Future _getImage() async {

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
    print(_image);
  }
  uploadImageMedia(File fileImage) async {
    print(fileImage);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final mimeTypeData = lookupMimeType(fileImage.path, headerBytes: [0xFF, 0xD8])?.split('/');
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse("https://road-runner24.000webhostapp.com/API/Update_API/Edit_Profile.php"));
    final file = await http.MultipartFile.fromPath('Profile_Image', fileImage.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));

    imageUploadRequest.fields['Name'] = user.text;
    imageUploadRequest.fields['Lincence_Number'] = li.text;
    imageUploadRequest.fields['Dob'] = dob.text;
    imageUploadRequest.fields['Address'] = address.text;
    imageUploadRequest.fields['Gender'] = _value.toString();



    imageUploadRequest.fields['Login_Id'] = prefs.getString('id')!;
    print(prefs.getString('heelo'));
    imageUploadRequest.files.add(file);
    try {
      //_isLoading = true;
      final streamedResponse = await imageUploadRequest.send();
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        if(streamedResponse.statusCode==200){
          var logindata;
          logindata = jsonDecode(value);
          print(logindata);
          Fluttertoast.showToast(
              msg: logindata['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
          Navigator.of(context).pop();
          print(streamedResponse.stream);
          print(value);
        }else{
          Fluttertoast.showToast(
              msg: "Something went wrong",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
          print(value);
        }
      });
    } catch (e) {
      print(e);
    }
  }
  // String  _genderRadioBtnVal="Male";
  // void _handleGenderChange(String value) {
  //   setState(() {
  //     _genderRadioBtnVal = value;
  //   });
  // }
  String _value="";
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Edit Profile",style: TextStyle(color: Colors.black,fontSize: 20),),

          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
            : SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(mdheight * 0.02),
                child: Column(
                    children: [
                      Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                child: _image==null?Image.network(getUser2[0]["Profile_Image"],height: 150,width: 150,fit: BoxFit.fill,):
                                Image.file(
                                  _image!,height: 150,width: 150,
                                  fit: BoxFit.fill,),
                                // child:Image.network (
                                //   getUser2[0]["Profile_Image"]
                                // ),
                              ),
                              Positioned(
                                left: 80,
                                bottom: 1,
                                child: CircleAvatar(
                                  child: IconButton(
                                      onPressed: (){
                                        _getImage();
                                      },
                                      icon:const Icon(Icons.edit)),
                                ),
                              )
                            ],
                          )),
                      SizedBox(height: mdheight * 0.04),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextField(
                                  controller: user,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Enter Your Name",
                                    labelText: "Name",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(mdheight * 0.02)),
                                  )),
                              SizedBox(height: mdheight * 0.025,),
                              TextField(
                                controller: address,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: 'Enter Your Address',
                                  labelText: "Address",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(mdheight * 0.02)),
                                ),
                              ),
                              SizedBox(height: mdheight * 0.025,),
                              TextField(
                                controller: dob,
                                keyboardType: TextInputType.datetime,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: 'YYYY-MM-DD',
                                  labelText: "Date Of Birth",
                                  prefixIcon: Icon(Icons.calendar_month),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(mdheight * 0.02)),
                                ),
                              ),
                              SizedBox(height: mdheight * 0.025,),
                              TextFormField(
                                controller: li,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: 'Enter Your Licence Number',
                                  labelText: "Licence Number",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(mdheight * 0.02)),
                                ),
                              ),
                              SizedBox(height: mdheight * 0.025,),
                            ],
                          )),
                      Row(
                          children:[
                            Radio(
                              value: "Male",
                              groupValue: _value,
                              onChanged: (value){
                                setState(() {
                                  _value = value as String;
                                });
                              },
                            ),
                            const Text('Male', style: TextStyle(fontSize: 18)),
                            Radio(
                              value: "Female",
                              groupValue: _value,
                              onChanged: (value){
                                setState(() {
                                  _value = value as String;
                                });
                              },
                            ),
                            const Text('Female', style: TextStyle(fontSize: 18)),
                            Radio(
                              value: "Other",
                              groupValue: _value,
                              onChanged: (value){
                                setState(() {
                                  _value = value as String;

                                });
                              },
                            ),
                            const Text('Other', style: TextStyle(fontSize: 18)),
                          ]),


                      SizedBox(height: mdheight * 0.03,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(mdheight * 0.02),
                          color: Colors.deepPurple.shade800,
                        ),
                        height: mdheight*0.07,
                        width: mdwidth,
                        child: MaterialButton(
                          onPressed: (){
                            uploadImageMedia(_image!);
                            getdata().whenComplete(() => Navigator.pop(context));
                          },
                          child: Text('Save Details',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: mdheight * 0.025,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ]))
        ));
  }
}