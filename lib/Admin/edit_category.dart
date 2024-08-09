import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class EditCategory extends StatefulWidget {
  final int val;

  const EditCategory({super.key, required this.val});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  TextEditingController name = TextEditingController();
  dynamic categoryData;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    getCategoryData();
  }

  Future<void> getCategoryData() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('Categories').get();
      setState(() {
        categoryData = snapshot.docs;
        name.text = categoryData[widget.val]['Cat_Name'];
      });
    }
    catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to fetch category data",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
    if (kDebugMode) {
      print(_image);
    }
  }

  Future<void> uploadImageMedia() async {
    try {
      String? imageUrl;

      if (_image != null) {
        final storageRef = FirebaseStorage.instance.ref().child('categories').child(name.text);
        await storageRef.putFile(_image!);
        imageUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('Categories').doc(categoryData[widget.val].id).update({
        'Cat_Name': name.text,
        if (imageUrl != null) 'Cat_Image': imageUrl,
      });

      Fluttertoast.showToast(
        msg: "Category updated successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );

      Get.back();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
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
        title: const Text('Edit Category'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: categoryData != null
          ? Padding(
        padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.03),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: mdheight * 0.02),
            Padding(
              padding: EdgeInsets.only(
                left: mdwidth * 0.05,
                right: mdwidth * 0.01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          child: _image == null
                              ? Image.network(
                            categoryData[widget.val]['Cat_Image'],
                            height: 150,
                            width: 150,
                            fit: BoxFit.fill,
                          )
                              : Image.file(
                            _image!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          left: 80,
                          bottom: 1,
                          child: CircleAvatar(
                            child: IconButton(
                              onPressed: _getImage,
                              icon: const Icon(Icons.edit),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: mdheight * 0.02),
                  Form(
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: 'Enter A Category Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: mdheight * 0.02),
            MaterialButton(
              onPressed: uploadImageMedia,
              color: Colors.deepPurple.shade800,
              elevation: 5.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: const Text(
                'Update Category',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: mdheight * 0.01),
          ],
        ),
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
