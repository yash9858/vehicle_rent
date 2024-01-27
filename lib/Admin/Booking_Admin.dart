import 'package:flutter/Material.dart';
import 'package:cool_alert/cool_alert.dart';

class Admin_BookingPage extends StatefulWidget {
  const Admin_BookingPage({super.key});

  @override
  State<Admin_BookingPage> createState() => _Admin_BookingPageState();
}

class _Admin_BookingPageState extends State<Admin_BookingPage> {
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
    title: const Text('All Bookings'),
    backgroundColor: Colors.deepPurple.shade800,
    iconTheme: const IconThemeData(
    color: Colors.white,
    ),
          centerTitle: true,
    ),
      body: ListView.builder(
          itemCount: 10,
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
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('User Name'),
                            Text('Booking TimeStamp'),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.01,),
                        const Text('Vehicle Name: '),
                        SizedBox(height: mdheight * 0.01,),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Start Time '),
                            Text('Return Time'),
                          ],
                        ),
                        SizedBox(height: mdheight * 0.01,),
                        const Text('Address'),
                        SizedBox(height: mdheight * 0.01,),
                        const Text('Booking Status: Pending'),
                        SizedBox(height: mdheight * 0.01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(onPressed: (){},
                                color: Colors.deepPurple.shade800,
                                padding: EdgeInsets.symmetric(horizontal: mdhwidth * 0.05, vertical: mdhwidth * 0.01),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                                ),
                                child: const Text('Accept Booking', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                )),
                            MaterialButton(onPressed: (){
                              CoolAlert.show(context: context,
                                  type: CoolAlertType.confirm,
                                  text: 'Do you Cancel Booking',
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
                                child: const Text('Cancel Booking', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
