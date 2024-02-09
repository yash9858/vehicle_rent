import 'package:flutter/material.dart';
import 'package:rentify/User/Available_car.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override

  Widget build(BuildContext context) {
    var mheight = MediaQuery.sizeOf(context).height;
    var mwidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      //  backgroundColor: Colors.transparent,
        title: Text("Category",style: TextStyle(color: Colors.white,fontSize: mheight*0.030,fontWeight: FontWeight.bold),),
    //    iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,

      ),
      body: Container(
        padding: EdgeInsets.only(top: 20,),
        child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 5,
          crossAxisCount: 3,
          crossAxisSpacing: 5
        ),
            itemCount: 7,
            itemBuilder: (BuildContext context,int index){
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Car()));
            },
            child:  Column(
              children: [
                Card(
                  elevation: 5,

                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(10),
                    child: Image.network(
                      "https://t3.ftcdn.net/jpg/05/12/61/78/360_F_512617800_Y3fLiMSaoBYsZt9x8AysMBZv3sMh1cbd.jpg",
                      fit: BoxFit.cover,
                      height: mwidth * 0.17,
                    ),
                  ),
                ),
                Text(
                  "SUV",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
