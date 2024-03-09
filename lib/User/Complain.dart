import 'package:flutter/material.dart';
class Complain extends StatefulWidget {
  const Complain({super.key});

  @override
  State<Complain> createState() => _ComplainState();
}

class _ComplainState extends State<Complain> {
  @override
  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Complain",style: TextStyle(color: Colors.black,fontSize: mheight*0.030),),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
    );
  }
}

