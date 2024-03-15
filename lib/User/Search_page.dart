import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rentify/User/Search_fetch_vehicle.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  String _searchText = '';
  bool isLoading = true;
  var data;
  var getUser;

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
          ? Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _searchText = _controller.text;
                          print(_searchText);
                        });
                        // Navigate to search fetch page with search text
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Search_fetch(vname: _controller.text)));
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
                          // Set the search text to the selected vehicle name
                          _controller.text = getUser[index]["Vehicle_Name"];
                          // Move the cursor to the end of the text
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