import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentify/User/user_dash_board.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class CompleteProfile extends StatefulWidget {

  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() =>CompleteProfileState();
}

class CompleteProfileState extends State<CompleteProfile> {
  TextEditingController user = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController li = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  dynamic logindata;
  dynamic data;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  uploadImageMedia(File fileImage) async {
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
          dynamic logindata;
          logindata = jsonDecode(value);
          Fluttertoast.showToast(
              msg: logindata['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
          Get.back();
        } else {
          setState(() {
          });
          Fluttertoast.showToast(
              msg: "Something went wrong",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
          if (kDebugMode) {
            print(value);
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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

  String _value = "Male";

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Complete Profile",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20
            ),),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: isLoading ? const Center(
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
                                    return null;
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
                                  return null;
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
                                  return null;
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
                                      borderRadius: BorderRadius.circular(mdheight * 0.02)),
                                ),
                              ),
                              SizedBox(height: mdheight * 0.025,),
                              TextFormField(
                                controller: li,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Please Enter Lincence";
                                  }
                                  return null;
                                },
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
                              TextFormField(
                                controller: phone,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "enter Phone number";
                                  }
                                  else {
                                    if (RegExp(
                                        r"^[0-9]{10}$")
                                        .hasMatch(val)) {
                                      return null;
                                    } else {
                                      return "please enter 10 digit number";
                                    }
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: 'Enter Your Phone No',
                                  labelText: "Phone No",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(mdheight * 0.02)),
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
                            _submit2(user.toString(), dob.toString(), phone.toString(), li.toString(), address.toString());
                            uploadImageMedia(_image!);
                            Get.off(()=>const UserDashboard());
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

  Future<void> _submit2(String user, String db,String num,String li, String add) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final loginUrl = Uri.parse("https://road-runner24.000webhostapp.com/API/Update_API/Login_Status.php");
    final response = await http.post(loginUrl, body: {"Login_Id": prefs.getString('id'),});
    if (response.statusCode == 200) {
      logindata = jsonDecode(response.body);
      data = jsonDecode(response.body)['user'];
      setState(() {
        isLoading = false;
      });
      if (logindata['error'] == false) {
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