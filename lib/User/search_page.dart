import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rentify/User/search_fetch_vehicle.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  String searchText = '';
  bool isLoading = true;
  dynamic data;
  dynamic getUser;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    http.Response response = await http.post(Uri.parse("https://road-runner24.000webhostapp.com/API/User_Fetch_API/Vehicle_name.php"));
    if (response.statusCode == 200) {
      data = response.body;
      setState(() {
        isLoading = false;
        getUser = jsonDecode(data!)["users"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          searchText = _controller.text;
                        });
                        Get.to(()=> SearchFetch(vName: _controller.text));
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: getUser.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: (){
                        setState(() {
                          _controller.text = getUser[index]["Vehicle_Name"];
                          _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
                        });
                      },
                      title: Text(getUser[index]["Vehicle_Name"]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}