import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rentify/User/User_DashBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class complete_Profile extends StatefulWidget {

  complete_Profile({super.key});

  @override
  State<complete_Profile> createState() =>complete_ProfileState();
}

class complete_ProfileState extends State<complete_Profile> {

  TextEditingController user = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController li = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var logindata;
  var data;
  var getuser;

  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future getdata() async{
    SharedPreferences share=await SharedPreferences.getInstance();
    http.Response response= await http.post(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Update_API/Available_Status.php"),
        body: {'Login_Id':share.getString('id')});
    if(response.statusCode==200) {
      data = response.body;
      setState(() {
        getuser=jsonDecode(data!)["users"];
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => UserDasboard()),
              (route) => false);
    }
  }

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
    final mimeTypeData = lookupMimeType(
        fileImage.path, headerBytes: [0xFF, 0xD8])?.split('/');
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Insert_API/Details_Insert.php"));
    final file = await http.MultipartFile.fromPath(
        'Profile_Image', fileImage.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));

    imageUploadRequest.fields['Name'] = user.text;
    imageUploadRequest.fields['Lincence_Number'] = li.text;
    imageUploadRequest.fields['Dob'] = dob.text;
    imageUploadRequest.fields['Address'] = address.text;
    imageUploadRequest.fields['Phone_No'] = phone.text;
    imageUploadRequest.fields['Gender'] = _value;

    imageUploadRequest.fields['Login_Id'] = prefs.getString('id')!;
    imageUploadRequest.files.add(file);
    try {
      final streamedResponse = await imageUploadRequest.send();
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        if (streamedResponse.statusCode == 200) {
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
        } else {
          setState(() {
            //_isLoading=false;
          });
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


  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }

  // String  _genderRadioBtnVal="Male";
  // void _handleGenderChange(String value) {
  //   setState(() {
  //     _genderRadioBtnVal = value;
  //   });
  // }
  String _value = "Male";

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery
        .sizeOf(context)
        .height;
    var mdwidth = MediaQuery
        .sizeOf(context)
        .width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Complete Profile",
            style: TextStyle(color: Colors.black, fontSize: 20),),

          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: isLoading ? Center(
          child: CircularProgressIndicator(color: Colors.deepPurple),)
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
                                child: _image == null ? Image.asset(
                                  "assets/img/Logo.jpg", height: 150,
                                  width: 150,
                                  fit: BoxFit.fill,) : Image.file(
                                  _image!, height: 150,
                                  width: 150,
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
                                      onPressed: () {
                                        _getImage();
                                      },
                                      icon: const Icon(Icons.edit)),
                                ),
                              )
                            ],
                          )),
                      SizedBox(height: mdheight * 0.04),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Please Enter name";
                                    }
                                  },
                                  controller: user,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Enter Your Name",
                                    labelText: "Name",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            mdheight * 0.02)),
                                  )),
                              SizedBox(height: mdheight * 0.025,),
                              TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Please Enter Address";
                                  }
                                },
                                controller: address,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: 'Enter Your Address',
                                  labelText: "Address",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          mdheight * 0.02)),
                                ),
                              ),
                              SizedBox(height: mdheight * 0.025,),
                              TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Please Enter Date of Birth";
                                  }
                                },
                                controller: dob,
                                keyboardType: TextInputType.datetime,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: 'Enter Your DOB',
                                  labelText: "Date Of Birth",
                                  prefixIcon: IconButton(
                                    onPressed: _showDatePicker,
                                    icon: const Icon(Icons.calendar_month),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          mdheight * 0.02)),
                                ),
                              ),
                              SizedBox(height: mdheight * 0.025,),
                              TextFormField(
                                controller: li,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Please Enter Lincence";
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: 'Enter Your Licence Number',
                                  labelText: "Licence Number",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          mdheight * 0.02)),
                                ),
                              ),
                              SizedBox(height: mdheight * 0.025,),
                              TextFormField(
                                controller: phone,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Please Enter Phone No";
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: 'Enter Your Phone No',
                                  labelText: "Phone No",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          mdheight * 0.02)),
                                ),
                              ),
                              SizedBox(height: mdheight * 0.025,),
                            ],
                          )),
                      Row(
                          children: [
                            Radio(
                              value: "Male",
                              groupValue: _value,
                              onChanged: (value) {
                                setState(() {
                                  _value = value!;
                                });
                              },
                            ),
                            const Text('Male', style: TextStyle(fontSize: 18)),
                            Radio(
                              value: "Female",
                              groupValue: _value,
                              onChanged: (value) {
                                setState(() {
                                  _value = value!;
                                });
                              },
                            ),
                            const Text(
                                'Female', style: TextStyle(fontSize: 18)),
                            Radio(
                              value: "Other",
                              groupValue: _value,
                              onChanged: (value) {
                                setState(() {
                                  _value = value!;
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
                        height: mdheight * 0.07,
                        width: mdwidth,
                        child: MaterialButton(
                          onPressed: () {
                            _submit2();
                            uploadImageMedia(_image!);
                            getdata();
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

  Future<void> _submit2() async {
    // final form = formKey.currentState;
    // if (form!.validate()) {
    //   setState(() {
    //     isLoading = true;
    //   });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final login_url = Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Update_API/Login_Status.php");
    final response = await http
        .post(login_url, body: {
      "Login_Id": prefs.getString('id'),

    });
    if (response.statusCode == 200) {
      logindata = jsonDecode(response.body);
      data = jsonDecode(response.body)['user'];
      print(data);
      print(prefs.getString('id'));
      setState(() {
        isLoading = false;
      });
      if (logindata['error'] == false) {
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Home()), (Route<dynamic> route) => false);
      } else {
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