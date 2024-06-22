import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class UpdateVehicle extends StatefulWidget {
  final int? val;
  const UpdateVehicle({super.key,required this.val});

  @override
  State<UpdateVehicle> createState() => _UpdateVehicleState();
}


class _UpdateVehicleState extends State<UpdateVehicle> {

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

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
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Vehicle_Admin.php"));
    if(response.statusCode==200){
      data=response.body;
      setState(() {
        isLoading=false;
        getUser=jsonDecode(data!)["users"];
        nameController.text = getUser[widget.val]["Vehicle_Name"];
        numberController.text = getUser[widget.val]["Vehicle_Number"];
        typeController.text = getUser[widget.val]["Vehicle_Type"];
        descriptionController.text = getUser[widget.val]["Vehicle_Description"];
        priceController.text = getUser[widget.val]["Rent_Price"];
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
    if (kDebugMode) {
      print(_image);
    }
  }
  uploadImageMedia(File fileImage) async {
    if (kDebugMode) {
      print(fileImage);
    }
    final mimeTypeData = lookupMimeType(fileImage.path, headerBytes: [0xFF, 0xD8])?.split('/');
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse("https://road-runner24.000webhostapp.com/API/Update_API/Vehicle_Update.php"));
    final file = await http.MultipartFile.fromPath('Vehicle_Image', fileImage.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));

    imageUploadRequest.fields['Vehicle_Name'] = nameController.text;
    imageUploadRequest.fields['Vehicle_Number'] = numberController.text;
    imageUploadRequest.fields['Vehicle_Type'] = typeController.text;
    imageUploadRequest.fields['Rent_Price'] = priceController.text;
    imageUploadRequest.fields['Vehicle_Description'] = descriptionController.text;
    imageUploadRequest.fields['Vehicle_Id'] = getUser[widget.val]["Vehicle_Id"];
    imageUploadRequest.files.add(file);

    try {
      final streamedResponse = await imageUploadRequest.send();
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        if(streamedResponse.statusCode==200){
          setState(() {
          });
          dynamic logindata;
          logindata = jsonDecode(value);
          if (kDebugMode) {
            print(logindata);
          }
          Fluttertoast.showToast(
              msg: logindata['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2
          );
          Get.back();
          if (kDebugMode) {
            print(streamedResponse.stream);
          }
          if (kDebugMode) {
            print(value);
          }
        }else{
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
        title: const Text(' Update Vehicle Details'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.deepPurple),)
      :SingleChildScrollView(
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
                      controller: nameController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter name";
                        }
                        return null;
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
                      controller: numberController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Number";
                        }
                        return null;
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
                      controller: typeController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Vehicle Type";
                        }
                        return null;
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
                      controller: descriptionController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Description";
                        }
                        return null;
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
                      controller: priceController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please Enter Price";
                        }
                        return null;
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
