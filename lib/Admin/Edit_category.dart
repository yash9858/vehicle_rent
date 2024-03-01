import 'dart:convert';

import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Edit_category extends StatefulWidget {
  final int val;

  const Edit_category({super.key, required this.val});

  @override
  State<Edit_category> createState() => _Edit_categoryState();
}

class _Edit_categoryState extends State<Edit_category> {
  TextEditingController name=TextEditingController();
  String ?data;
  var ne;
  void initState(){
    super.initState();
    getdata();
  }
  Future getdata() async{
    http.Response response= await http.get(Uri.parse("https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Category_Admin.php"));
    if(response.statusCode==200){
      data=response.body;
    }
    setState(() {
      ne=jsonDecode(data!)["users"];
      name.text=ne[widget.val]["Category_Name"];
    });
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
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse("https://road-runner24.000webhostapp.com/API/Update_API/Category_Update.php"));
    final file = await http.MultipartFile.fromPath('Category_Image', fileImage.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));

    imageUploadRequest.fields['Category_Name'] = name.text;
    imageUploadRequest.fields['Category_Id'] = ne[widget.val]["Category_Id"];
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
          title: const Text('Edit Category'),
          backgroundColor: Colors.deepPurple.shade800,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        body: ne!=null?
        Padding(
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
                              child:_image==null?Image.network(ne[widget.val]["Category_Image"],height: 150,width: 150,fit: BoxFit.fill,): //_image==null?
                              // Image.asset(
                              //   'assets/images/select.png',height: 150,width: 150,
                              //   fit: BoxFit.fill,)
                              Image.file(
                                _image!,height: 150,width: 150,
                                fit: BoxFit.fill,),
                          ),

                              //   child:_image==null?Image.asset(
                              //     "assets/img/Logo.jpg",height: 150,width: 150,fit: BoxFit.fill,):Image.file(_image!,height: 150,width: 150,fit: BoxFit.fill,),
                              // ),
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
                        //key: _formKey,
                        child: TextFormField(
                            controller: name,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: 'Enter A Category Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      15)
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
        ):Center(child: CircularProgressIndicator(),),
    );
  }
}
