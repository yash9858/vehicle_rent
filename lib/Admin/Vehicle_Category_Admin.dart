
import 'dart:convert';
import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:rentify/Admin/Category_add_admin.dart';
import 'package:rentify/Admin/Vehicle_Add_Admin.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class Admin_CategoryPage extends StatefulWidget {
  const Admin_CategoryPage({super.key});

  @override
  State<Admin_CategoryPage> createState() => _Admin_CategoryPageState();
}

// ignore: camel_case_types
class _Admin_CategoryPageState extends State<Admin_CategoryPage> {
  String? data;
  var getUser;
  bool isLoading = false;
  TextEditingController NameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  void initState() {
    super.initState();
    getdata();
  }

  Future getdata() async {
    setState(() {
      isLoading = true;
    });
    http.Response response = await http.get(Uri.parse(
        "https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Category_Admin.php"));
    if (response.statusCode == 200) {
      data = response.body;
      setState(() {
        isLoading = false;
        getUser = jsonDecode(data!)["users"];
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

  TextEditingController name1 = TextEditingController();

  Future uploadImageMedia(File? fileImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final mimeTypeData = lookupMimeType(fileImage!.path, headerBytes: [0xFF, 0xD8])?.split('/');
    final imageUploadRequest = http.MultipartRequest('POST',
        Uri.parse("https://road-runner24.000webhostapp.com/API/Insert_API/Vehicle_Category_Insert.php"));
    final file = await http.MultipartFile.fromPath(
      'Category_Image',
      fileImage.path,
      contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
    );

    imageUploadRequest.fields['Category_Name'] = name1.text;
    imageUploadRequest.files.add(file);

    try {
      setState(() {
        isLoading = true;
      });

      final streamedResponse = await imageUploadRequest.send();
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        if (streamedResponse.statusCode == 200) {
          setState(() {
            isLoading = false;
          });
          print(name1.text);
          print(_image);
          var logindata;
          logindata = jsonDecode(value);
          print(logindata['message']);
          Fluttertoast.showToast(
            msg: logindata['message'].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
          );
          Navigator.of(context).pop();
          print(streamedResponse.stream);
          print(value);
        } else {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
            msg: "Something went wrong",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
          );
          print(value);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // var name = ['HatchBack', 'sedan', 'Suv', 'BodyType'];
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
        title: const Text('All Category'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(color: Colors.deepPurple),) :
      ListView.builder(
          itemCount: getUser.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(padding: EdgeInsets.symmetric(
                horizontal: mdwidth * 0.025, vertical: mdheight * 0.005),
                child: Card(

                  elevation: 5.0,
                  shadowColor: Colors.deepPurple.shade800,
                  semanticContainer: true,
                  surfaceTintColor: Colors.deepPurple.shade800,
                  child: Padding(
                    padding: EdgeInsets.all(mdheight * 0.017),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text('Category Id : ' +
                                          getUser[index]["Category_Id"]),

                                      SizedBox(height: mdheight * 0.01,),
                                      SizedBox(height: mdheight * 0.01,),
                                      Text('Category Name : ' +
                                          getUser[index]["Category_Name"]),
                                      SizedBox(height: mdheight * 0.01,),
                                    ],
                                  )),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        getUser[index]["Category_Image"],
                                        height: mdheight * 0.1,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ]
                              ),
                            ]
                        ),
                        SizedBox(height: mdheight * 0.015,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MaterialButton(onPressed: () {
                              showDialog(context: context, builder: (context) {
                                return Dialog(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: mdwidth * 0.03),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            SizedBox(height: mdheight * 0.02),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: mdwidth * 0.05,
                                                right: mdwidth * 0.01,),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Center(
                                                      child: Stack(
                                                        children: [
                                                          const CircleAvatar(
                                                            radius: 60,
                                                            backgroundImage: AssetImage(
                                                                "assets/img/Logo.jpg"),
                                                          ),
                                                          Positioned(
                                                            left: 80,
                                                            bottom: 1,
                                                            child: CircleAvatar(

                                                              child: IconButton(
                                                                  onPressed: (){
                                                                   // Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin_Add_Vehicle(id:getUser[index]["Category_Id"])));
                                                                  },//_getImage,
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .edit)),
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                  SizedBox(
                                                    height: mdheight * 0.02,),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                        fillColor: Colors.grey
                                                            .shade100,
                                                        filled: true,
                                                        hintText: 'Enter A Category Name',
                                                        border: OutlineInputBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(15)
                                                        )
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: mdheight * 0.02,),
                                            MaterialButton(onPressed: () {
                                              Navigator.pop(context);
                                            },
                                                color: Colors.deepPurple
                                                    .shade800,
                                                elevation: 5.0,
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .all(
                                                        Radius.circular(15))),
                                                child: const Text(
                                                  'Update Category',
                                                  style: TextStyle(
                                                    color: Colors.white,),)),
                                            SizedBox(height: mdheight * 0.01),
                                          ]
                                      ),
                                    ));
                              });
                            },
                                color: Colors.deepPurple.shade800,
                                padding: EdgeInsets.symmetric(
                                    horizontal: mdwidth * 0.05,
                                    vertical: mdwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(mdheight * 0.015)),
                                ),
                                child: const Text('Edit Category',
                                  style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                            MaterialButton(onPressed: () {
                              CoolAlert.show(context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Do you Remove Category',
                                  confirmBtnColor: Colors.red,
                                  animType: CoolAlertAnimType.slideInDown,
                                  backgroundColor: Colors.red,
                                  cancelBtnTextStyle: const TextStyle(
                                    color: Colors.black,
                                  ));
                            },
                                color: Colors.red,
                                padding: EdgeInsets.symmetric(
                                    horizontal: mdwidth * 0.05,
                                    vertical: mdwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(mdheight * 0.015)),
                                ),
                                child: const Text('Delete Category',
                                  style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Category_add()));
          // showDialog(context: context, builder: (context) {
          //   return Dialog(
          //       child: Padding(
          //         padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.03),
          //         child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               SizedBox(height: mdheight * 0.02),
          //               Padding(
          //                 padding: EdgeInsets.only(left: mdwidth * 0.05,
          //                   right: mdwidth * 0.01,),
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Center(
          //                         child: Stack(
          //                           children: [
          //                             const CircleAvatar(
          //                               radius: 60,
          //                               backgroundImage: AssetImage(
          //                                   "assets/img/Logo.jpg"),
          //                             ),
          //                             Positioned(
          //                               left: 80,
          //                               bottom: 1,
          //                               child: CircleAvatar(
          //
          //                                 child: IconButton(
          //                                     onPressed: _getImage,
          //                                     icon: const Icon(Icons.edit)),
          //                               ),
          //                             )
          //                           ],
          //                         )),
          //                     SizedBox(height: mdheight * 0.02,),
          //                     Form(
          //                       key: _formKey,
          //                       child: TextFormField(
          //                         controller: name1,
          //                         decoration: InputDecoration(
          //                             fillColor: Colors.grey.shade100,
          //                             filled: true,
          //                             hintText: 'Enter A Category Name',
          //                             border: OutlineInputBorder(
          //                                 borderRadius: BorderRadius.circular(
          //                                     15)
          //                             )
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               SizedBox(height: mdheight * 0.02,),
          //               MaterialButton(
          //                   onPressed:() {uploadImageMedia(_image);},
          //                   color: Colors.deepPurple.shade800,
          //                   elevation: 5.0,
          //                   shape: const RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.all(
          //                           Radius.circular(15))),
          //                   child: const Text('Add Category', style: TextStyle(
          //                     color: Colors.white,),)),
          //               SizedBox(height: mdheight * 0.01),
          //             ]
          //         ),
          //       )
          //   );
          // });
        },
        backgroundColor: Colors.deepPurple.shade800,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

}