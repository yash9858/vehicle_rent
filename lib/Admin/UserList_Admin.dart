import 'package:flutter/Material.dart';
import 'package:cool_alert/cool_alert.dart';

// ignore: camel_case_types
class Admin_UserPage extends StatefulWidget {
  const Admin_UserPage({super.key});

  @override
  State<Admin_UserPage> createState() => _Admin_UserPageState();
}

// ignore: camel_case_types
class _Admin_UserPageState extends State<Admin_UserPage> {
  var name = ['yash', 'raj', 'jigar','anuj', 'sachin'];
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
        title: const Text('User List'),
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
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Login Id : 1'),
                                  SizedBox(height: mdheight * 0.01,),
                                  const Text('User Name : Yash Mistry'),
                                  SizedBox(height: mdheight * 0.01,),
                                  const Text('Dob : 18/1/2004'),
                                  SizedBox(height: mdheight * 0.01,),
                                  const Text('Gender : Male'),
                                  SizedBox(height: mdheight * 0.01,),
                                  const Text('Address : Kailash Bhuvan Near Fire Station more details is near about find'),
                                  SizedBox(height: mdheight * 0.01,),
                                  const Text('Licence Number : Yash124'),
                                  SizedBox(height: mdheight * 0.01,),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                                children:[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset('assets/img/Logo.jpg',
                                      height : mdheight * 0.15,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ]
                            ),
                          ]
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MaterialButton(onPressed: (){
                              CoolAlert.show(context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Do you Remove User',
                                  confirmBtnColor: Colors.red,
                                  animType: CoolAlertAnimType.slideInDown,
                                  backgroundColor: Colors.red,
                                  cancelBtnTextStyle: const TextStyle(
                                    color: Colors.black,
                                  ));
                            },
                                color: Colors.red,
                                padding: EdgeInsets.symmetric(horizontal: mdwidth * 0.05, vertical: mdwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                                ),

                              child: const Text('Delete User', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              )),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
          }),
    );
  }
}
