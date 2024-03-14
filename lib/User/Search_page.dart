import 'package:flutter/material.dart';
import 'package:rentify/User/Search_fetch_vehicle.dart';

class Search_page extends StatefulWidget {
  const Search_page({super.key});

  @override
  State<Search_page> createState() => _Search_pageState();
}

class _Search_pageState extends State<Search_page> {
  TextEditingController _controller = TextEditingController();
  String _searchText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.only(top: 15,left: 8,right: 8),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Search_fetch(vname: _controller.text)));
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 20, // Just for demonstration
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Item $index'),
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
