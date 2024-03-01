import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'package:flutter/Material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class update_Vehicle extends StatefulWidget {
  final int val;
  const update_Vehicle({super.key,required this.val});

  @override
  State<update_Vehicle> createState() => _update_VehicleState();
}

// ignore: camel_case_types
class _update_VehicleState extends State<update_Vehicle> {

  TextEditingController NameController = TextEditingController();

  TextEditingController NumberController = TextEditingController();
  TextEditingController TypeController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController PriceController = TextEditingController();



  String? data;
  var getUser;
  bool isLoading=false;

  void initState(){
    super.initState();
    getdata();

  }

  Future getdata() async{
    setState(() {
      isLoading = true;
    });
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Vehicle_Admin.php"));
    if(response.statusCode==200){
      data=response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
        NameController.text = getUser[widget.val]["Vehicle_Name"];
        NumberController.text = getUser[widget.val]["Vehicle_Number"];
        TypeController.text = getUser[widget.val]["Vehicle_Type"];
        DescriptionController.text = getUser[widget.val]["Vehicle_Description"];
        PriceController.text = getUser[widget.val]["Rent_Price"];
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
   // SharedPreferences prefs = await SharedPreferences.getInstance();
    final mimeTypeData = lookupMimeType(fileImage.path, headerBytes: [0xFF, 0xD8])?.split('/');
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse("https://road-runner24.000webhostapp.com/API/Update_API/Vehicle_Update.php"));
    final file = await http.MultipartFile.fromPath('Vehicle_Image', fileImage.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));

    imageUploadRequest.fields['Vehicle_Name'] = NameController.text;
    imageUploadRequest.fields['Vehicle_Number'] = NumberController.text;
    imageUploadRequest.fields['Vehicle_Type'] = TypeController.text;
    imageUploadRequest.fields['Rent_Price'] = PriceController.text;
    imageUploadRequest.fields['Vehicle_Description'] = DescriptionController.text;


    imageUploadRequest.fields['Vehicle_Id'] = getUser[widget.val]["Vehicle_Id"];
    imageUploadRequest.files.add(file);
    try {
      //_isLoading = true;
      final streamedResponse = await imageUploadRequest.send();
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        if(streamedResponse.statusCode==200){
          setState(() {
            //_isLoading=false;
          });
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
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdwidth = MediaQuery.sizeOf(context).width;
    return isLoading ?  Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
    :Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text(' Update Vehicle Details'),
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
                       CircleAvatar(
                        radius: 60,
                        child: _image==null?Image.network(getUser[widget.val]["Vehicle_Image"],height: 150,width: 150,fit: BoxFit.fill,):
                        Image.file(
                          _image!,height: 150,width: 150,
                          fit: BoxFit.fill,),

                        // backgroundImage:
                        // AssetImage(
                        //     "assets/img/Logo.jpg"),
                      ),
                      Positioned(
                        left: 80,
                        bottom: 1,
                        child: CircleAvatar(

                          child: IconButton(
                             onPressed: _getImage,
                              icon:const Icon(Icons.edit)),
                        ),
                      )
                    ],
                  )),
              SizedBox(height: mdheight * 0.04),
              Form(

                  child: Column(children: [
                    TextFormField(
                      controller: NameController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter name";
                        }
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Enter Vehicle Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                          )
                      ),
                    ),
                    SizedBox(height: mdheight * 0.025,),
                    TextFormField(
                      controller: NumberController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Number";
                        }
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Enter Vehicle Number',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                          )
                      ),
                    ),
                    SizedBox(height: mdheight * 0.025,),
                    TextFormField(
                      controller: TypeController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Vehicle Type";
                        }
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Enter Vehicle Type',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                          )
                      ),
                    ),
                    SizedBox(height: mdheight * 0.025,),
                    TextFormField(
                      controller: DescriptionController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Descripation";
                        }
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Enter Vehicle Description',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                          )
                      ),
                    ),
                    SizedBox(height: mdheight * 0.025,),
                    TextFormField(
                      controller: PriceController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Price";
                        }
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Enter Rent Price',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)
                          )
                      ),
                    ),
                  ],)),

              SizedBox(height: mdheight * 0.04,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(mdheight * 0.02),
                  color: Colors.deepPurple.shade800,
                ),
                height: mdheight * 0.06,
                width: mdwidth * 0.7,
                child: MaterialButton(
                  onPressed: (){
                    uploadImageMedia(_image!);

                   // Navigator.pop(context);
                  },

                  child: Text('Update Details',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: mdheight * 0.025,
                          fontWeight: FontWeight.bold)),
                ),
              )],
          ),
        ),
      ),
    );
  }
}
