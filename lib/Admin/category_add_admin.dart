import 'dart:convert';
import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class CategoryAdd extends StatefulWidget {
  const CategoryAdd({super.key});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {

  bool isLoading = false;
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

  TextEditingController name=TextEditingController();

  uploadImageMedia(File fileImage) async {
    if (kDebugMode) {
      print(fileImage);
    }
    final mimeTypeData = lookupMimeType(fileImage.path, headerBytes: [0xFF, 0xD8])?.split('/');
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse("https://road-runner24.000webhostapp.com/API/Insert_API/Vehicle_Category_Insert.php"));
    final file = await http.MultipartFile.fromPath('Category_Image', fileImage.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));

    imageUploadRequest.fields['Category_Name'] = name.text;

    imageUploadRequest.files.add(file);
    try {
      isLoading = true;
      final streamedResponse = await imageUploadRequest.send();
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        if(streamedResponse.statusCode==200){
          setState(() {
            isLoading=false;
          });
          dynamic logindata;
          logindata = jsonDecode(value);

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
        }
        else{
          setState(() {
            isLoading=false;
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
          title: const Text('Add Category'),
          backgroundColor: Colors.deepPurple.shade800,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
        ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.03),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: mdheight * 0.02),
                Padding(
                  padding: EdgeInsets.only(left: mdwidth * 0.05,
                    right: mdwidth * 0.01,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(height: mdheight * 0.02,),
                      Form(
                        child: TextFormField(
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: 'Enter A Category Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: mdheight * 0.02,),
                MaterialButton(
                    onPressed:() { uploadImageMedia(_image!);},
                    color: Colors.deepPurple.shade800,
                    elevation: 5.0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(15))),
                    child: const Text('Add Category', style: TextStyle(
                      color: Colors.white,),)),
                SizedBox(height: mdheight * 0.01),
              ]
          ),
        )
    );
  }
}
