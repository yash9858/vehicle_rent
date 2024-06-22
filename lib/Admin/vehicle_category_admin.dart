import 'dart:convert';
import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:rentify/Admin/category_add_admin.dart';
import 'package:rentify/Admin/edit_category.dart';

class AdminCategoryPage extends StatefulWidget {
  const AdminCategoryPage({super.key});

  @override
  State<AdminCategoryPage> createState() => _AdminCategoryPageState();
}

class _AdminCategoryPageState extends State<AdminCategoryPage> {
  String? data;
  String? data2;
  dynamic getUser;
  dynamic getUser2;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();

  @override
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

  Future cat(String cid) async{
    http.Response response= await http.post(Uri.parse(
      "https://road-runner24.000webhostapp.com/API/Delete_API/Category_Vehicle.php",
    ), body: {'Category_Id' : cid});
    if(response.statusCode==200){
      data2=response.body;
      setState(() {
        isLoading=false;
        getUser2=jsonDecode(data2!)["users"];
      });
    }
  }
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
    if (kDebugMode) {
      print(_image);
    }
  }

  TextEditingController name1 = TextEditingController();

  Future uploadImageMedia(File? fileImage) async {
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
          if (kDebugMode) {
            print(name1.text);
          }
          if (kDebugMode) {
            print(_image);
          }
          dynamic logindata;
          logindata = jsonDecode(value);
          if (kDebugMode) {
            print(logindata['message']);
          }
          Fluttertoast.showToast(
            msg: logindata['message'].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
          );
          Get.back();
          if (kDebugMode) {
            print(streamedResponse.stream);
          }
          if (kDebugMode) {
            print(value);
          }
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
        title: const Text('All Category'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: isLoading ? const Center(
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text('Category Id : ' ),
                                          Text(getUser[index]["Category_Id"]),
                                        ],
                                      ),
                                      SizedBox(height: mdheight * 0.01,),
                                      Row(
                                        children: [
                                          const Text('Category Name : '),
                                          Text(getUser[index]["Category_Name"]),
                                        ],
                                      ),
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
                            MaterialButton(
                              onPressed:(){
                                Get.to(() => EditCategory(val:index));
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
                                  onConfirmBtnTap: ()
                                  {
                                    cat(getUser[index]["Category_Id"]).whenComplete(() {getdata();});
                                  },
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
          Get.to(() => const CategoryAdd());
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