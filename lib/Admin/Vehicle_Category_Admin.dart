import 'package:flutter/Material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:rentify/Admin/Vehicle_Category_Add_Admin.dart';

class Admin_CategoryPage extends StatefulWidget {
  const Admin_CategoryPage({super.key});

  @override
  State<Admin_CategoryPage> createState() => _Admin_CategoryPageState();
}

class _Admin_CategoryPageState extends State<Admin_CategoryPage> {
  var name = ['HatchBack', 'sedan', 'Suv', 'BodyType'];
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    var mdhwidth = MediaQuery.sizeOf(context).width;
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
      body : ListView.builder(
          itemCount: name.length,
          itemBuilder: (BuildContext context, int index)
          {
            return Padding(padding: EdgeInsets.symmetric(horizontal: mdhwidth * 0.025, vertical: mdheight * 0.005),
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
                            children :[
                              Expanded(
                                child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Category Id : 1'),
                                  SizedBox(height: mdheight * 0.01,),
                                  const Text('Vehicle Id : 1'),
                                  SizedBox(height: mdheight * 0.01,),
                                  const Text('Category Name : sedan'),
                                  SizedBox(height: mdheight * 0.01,),
                                ],
                              )),
                               Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                  children:[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset('assets/img/Logo.jpg',
                                        height: mdheight * 0.15,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ]
                              ),
                            ]
                        ),
                        SizedBox(height:  mdheight * 0.015,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MaterialButton(onPressed: (){
                              showDialog(context: context, builder: (context)
                              {
                                return Dialog(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: mdhwidth * 0.03),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: mdheight * 0.02),
                                            Image.asset('assets/img/Logo.jpg',
                                              height: mdheight * 0.13,),
                                            SizedBox(height: mdheight * 0.02),
                                            Padding(
                                              padding: EdgeInsets.only(left : mdhwidth * 0.05, right: mdhwidth * 0.01,),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children :[
                                                  const Text('Category Id : 1'),
                                                  SizedBox(height: mdheight * 0.01),
                                                  const Text('Vehicle Id : 1'),
                                                  SizedBox(height: mdheight * 0.01),
                                                  const Text('Category Name : Tesla'),
                                                  SizedBox(height: mdheight * 0.01),
                                                ],
                                              ),
                                            ),
                                            MaterialButton(onPressed: (){
                                              Navigator.pop(context);
                                            },
                                                color: Colors.deepPurple.shade800,
                                                elevation: 5.0,
                                                child: const Text('Update', style: TextStyle(color: Colors.white,),)),
                                            SizedBox(height: mdheight * 0.01),
                                          ]
                                      ),
                                    ));
                              });
                            },
                                color: Colors.deepPurple.shade800,
                                padding: EdgeInsets.symmetric(horizontal: mdhwidth * 0.05, vertical: mdhwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                                ),
                                child: const Text('Edit Category', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                )),
                            MaterialButton(onPressed: (){
                              CoolAlert.show(context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Do you Remove Category',
                                  confirmBtnColor: Colors.redAccent.shade200,
                                  animType: CoolAlertAnimType.slideInDown,
                                  backgroundColor: Colors.redAccent.shade200,
                                  cancelBtnTextStyle: const TextStyle(
                                    color: Colors.black,
                                  ));
                            },
                                color: Colors.redAccent.shade200,
                                padding: EdgeInsets.symmetric(horizontal: mdhwidth * 0.05, vertical: mdhwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                                ),
                                child: const Text('Delete Category', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Vehicle_Category_Details()));
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

