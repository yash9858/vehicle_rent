import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';


// ignore: camel_case_types
class Admin_Add_Vehicle extends StatefulWidget {
  final String id;
  final String name;
  const Admin_Add_Vehicle({super.key,required this.id ,required this.name});

  @override
  State<Admin_Add_Vehicle> createState() => _Admin_Add_VehicleState();
}

// ignore: camel_case_types
class _Admin_Add_VehicleState extends State<Admin_Add_Vehicle> {

  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
    print(_image);
  }

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController type = TextEditingController();

  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();

  uploadImageMedia(File fileImage) async {
    print(fileImage);
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final mimeTypeData = lookupMimeType(
        fileImage.path, headerBytes: [0xFF, 0xD8])?.split('/');
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Insert_API/Vehicle.php"));
    final file = await http.MultipartFile.fromPath(
        'Vehicle_Image', fileImage.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));

    imageUploadRequest.fields['Vehicle_Name'] = name.text;
    imageUploadRequest.fields['Vehicle_Number'] = number.text;
    imageUploadRequest.fields['Vehicle_Type'] = type.text;
    imageUploadRequest.fields['Rent_Price'] = price.text;
    imageUploadRequest.fields['Vehicle_Description'] = description.text;
    imageUploadRequest.fields['Category_Id'] = widget.id;

    imageUploadRequest.files.add(file);
    try {
      _isLoading = true;
      final streamedResponse = await imageUploadRequest.send();
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        if (streamedResponse.statusCode == 200) {
          setState(() {
            _isLoading = false;
          });
          var logindata;
          logindata = jsonDecode(value);

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
            _isLoading = false;
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
    var mdheight = MediaQuery
        .sizeOf(context)
        .height;
    var mdwidth = MediaQuery
        .sizeOf(context)
        .width;
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text('Vehicle Details'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
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
                        child:_image==null?Image.asset(
                          "assets/img/Logo.jpg",height: 150,width: 150,fit: BoxFit.fill,):Image.file(_image!,height: 150,width: 150,fit: BoxFit.fill,),
                      ),
                      Positioned(
                        left: 80,
                        bottom: 1,
                        child: CircleAvatar(

                          child: IconButton(
                              onPressed: _getImage,
                              icon: const Icon(Icons.edit)),
                        ),
                      )
                    ],
                  )),
              SizedBox(height: mdheight * 0.04),
              Form(
                //  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: name,
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
                      controller: number,
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
                      controller: type,
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
                      controller: description,
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
                      controller: price,
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
                  onPressed: () {
                    uploadImageMedia(_image!);
                  },
                  child: Text('Add Vehicle',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: mdheight * 0.025,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

// Future<void> _submit() async {
//   final form = _formKey.currentState;
//   if (form!.validate()) {
//     setState(() {
//       isLoading = true;
//     });
//     final login_url = Uri.parse(
//         "https://road-runner24.000webhostapp.com/API/Insert_API/Vehicle.php");
//     final response = await http
//         .post(login_url, body: {
//       "Vehicle_Name": NameController.text,
//       "Vehicle_Number": NumberController.text,
//       "Vehicle_Type": TypeController.text,
//       "Vehicle_Description": DescriptionController.text,
//       "Rent_Price": PriceController.text,
//       //"Vehicle_Image": NameController.text,
//
//       "Availability": "1",
//       "Category_Id": "1",
//
//     });
//     if (response.statusCode == 200) {
//       logindata = jsonDecode(response.body);
//       data =
//       jsonDecode(response.body)['user'];
//       print(logindata);
//       setState(() {
//         isLoading = false;
//       });
//       if (logindata['error'] == false) {
//         Fluttertoast.showToast(
//             msg: logindata['message'].toString(),
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.BOTTOM,
//             timeInSecForIosWeb: 2
//         );
//
//       }else{
//         Fluttertoast.showToast(
//             msg: logindata['message'].toString(),
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.BOTTOM,
//             timeInSecForIosWeb: 2
//         );
//       }
//     }
//   }
//
// }
//
// }
}
