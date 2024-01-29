import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:rentify/Admin/Vehicle_Add_Admin.dart';

// ignore: camel_case_types
class Admin_VehiclePage extends StatefulWidget {
  const Admin_VehiclePage({super.key});

  @override
  State<Admin_VehiclePage> createState() => _Admin_VehiclePageState();
}

// ignore: camel_case_types
class _Admin_VehiclePageState extends State<Admin_VehiclePage> {
  var name = ['Tesla', 'BMW', 'Ferrari', 'Ford', 'Honda', 'Toyota'];
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
        title: const Text('Vehicle List'),
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
            return Padding(padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.025, vertical: mdheight * 0.005),
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
                            children :[
                              Expanded(
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Category Id : 1'),
                                  SizedBox(height: mdheight * 0.01),
                                  const Text('Vehicle Id : 1'),
                                  SizedBox(height: mdheight * 0.01),
                                  const Text('Vehicle Name : Tesla'),
                                  SizedBox(height: mdheight * 0.01),
                                  const Text('Vehicle Type : Car'),
                                  SizedBox(height: mdheight * 0.01),
                                  const Text('Vehicle Description : This Is Fully Automated Car'),
                                  SizedBox(height: mdheight * 0.01),
                                  const Text('Rent Price: 500/day'),
                                  SizedBox(height: mdheight * 0.01),
                                  const Text('Availability : True'),
                                  SizedBox(height: mdheight * 0.01),
                                ],
                              )),
                                  Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children:[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset('assets/img/Logo.jpg',
                                        height: mdheight * 0.2,
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
                                      padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.03),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: mdheight * 0.02),
                                            Image.asset('assets/img/Logo.jpg', height: mdheight * 0.13,),
                                            SizedBox(height: mdheight * 0.02),
                                            Padding(
                                              padding: EdgeInsets.only(left : mdwidth * 0.05, right: mdwidth * 0.01,),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children :[
                                                  const Text('Category Id : 1'),
                                                  SizedBox(height: mdheight * 0.01),
                                                  const Text('Vehicle Id : 1'),
                                                  SizedBox(height: mdheight * 0.01),
                                                  const Text('Vehicle Name : Tesla'),
                                                  SizedBox(height: mdheight * 0.01),
                                                  const Text('Vehicle Type : Car'),
                                                  SizedBox(height: mdheight * 0.01),
                                                  const Text('Vehicle Description : This Is Fully \nAutomated Car'),
                                                  SizedBox(height: mdheight * 0.01),
                                                  const Text('Rent Price: 500/day'),
                                                  SizedBox(height: mdheight * 0.01),
                                                  const Text('Availability : True'),
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
                              }
                              );
                            },
                                color: Colors.deepPurple.shade800,
                                padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                                ),
                                child: const Text('Edit Vehicle', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                )),
                            MaterialButton(onPressed: (){
                              CoolAlert.show(context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Do you Remove Vehicle',
                                  confirmBtnColor: Colors.redAccent.shade200,
                                  animType: CoolAlertAnimType.slideInDown,
                                  backgroundColor: Colors.redAccent.shade200,
                                  cancelBtnTextStyle: const TextStyle(
                                    color: Colors.black,
                                  ));
                            },
                                color: Colors.redAccent.shade200,
                                padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                                ),

                                child: const Text('Delete Vehicle', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Admin_Add_Vehicle()));
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

