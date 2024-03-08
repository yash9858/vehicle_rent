import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/User/Car_Details.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    var mheight=MediaQuery.sizeOf(context).height;
    var mwidth=MediaQuery.sizeOf(context).width;

   return Scaffold(
     appBar: AppBar(
       centerTitle: true,
       title: const Text("Favorite Vehicles",style: TextStyle(color: Colors.black,fontSize: 20),),
       elevation: 0,
       backgroundColor: Colors.transparent,
       iconTheme: const IconThemeData(color: Colors.black),
     ),
     body: Container(
       padding: EdgeInsets.only(left: 10,right: 10),

       child: GridView.builder(
           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 2,
               mainAxisExtent: mheight * 0.27, // Adjust this value
               crossAxisSpacing: 5,
               mainAxisSpacing: 5
           ),
           itemCount: 5,//getUser2.length,
           itemBuilder: (BuildContext context,int index){
             return GestureDetector(
               onTap: (){
                 //Navigator.push(context, MaterialPageRoute(builder: (context)=> car_detail(val:index, carid:getUser2[index]["Vehicle_Id"])));
               },
               child: Container(

                   child:  Card(
                       borderOnForeground: true,

                       elevation: 6,
                       shape: RoundedRectangleBorder(

                           borderRadius: BorderRadius.circular(12)),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Padding(
                             padding: EdgeInsets.only(left: 7,right: 7,top: 3),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text('Category_Name'),
                                 //Text(getUser2[index]["Vehicle_Name"],style: TextStyle(color: Colors.grey),),
                                 Icon(LineIcons.heart,color: Colors.red,)
                               ],
                             ),
                           ),
                           ClipRRect(
                             borderRadius:  BorderRadius.only(
                                 topLeft: Radius.circular(12),
                                 topRight: Radius.circular(12)),
                             child: Image.asset(
                               "assets/img/bullet.jpeg"
                            //   getUser2[index]["Vehicle_Image"],
                              , fit: BoxFit.cover,
                               height: mheight * 0.16,
                               width: mwidth * 0.5,
                             ),
                           ),
                           Expanded(
                             child: Padding(
                               padding:  EdgeInsets.only(
                                   left: 4, bottom: 2, right: 4),
                               child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   mainAxisAlignment:
                                   MainAxisAlignment.spaceEvenly,
                                   children: [
                                     Text(
                                     //  getUser2[index]["Category_Name"],
                                     'Vehicle Name' , style: TextStyle(
                                           fontSize: 15,
                                           fontWeight: FontWeight.bold),
                                     ),
                                     Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.spaceBetween,
                                       children: [
                                         Text(
                                         //  "₹" +getUser2[index]["Rent_Price"] +
                                               "₹320/ Day",
                                           style: TextStyle(
                                               fontSize: 15,
                                               fontWeight: FontWeight.bold),
                                         ),
                                         Row(
                                           children: [
                                             const Text("4.1"),
                                             Icon(
                                               Icons.star,
                                               color: Colors.orange,
                                               size: 18,
                                             )
                                           ],
                                         )
                                       ],
                                     ),
                                   ]),
                             ),
                           )
                         ],
                       ))
               ),
             );
           }),
     ),
   );
  }
}
