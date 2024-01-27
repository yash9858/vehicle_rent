import 'package:flutter/Material.dart';

class Admin_ComplainPage extends StatefulWidget {
  const Admin_ComplainPage({super.key});

  @override
  State<Admin_ComplainPage> createState() => _Admin_ComplainPageState();
}

class _Admin_ComplainPageState extends State<Admin_ComplainPage> {
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
        title: const Text('Complains'),
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
                        Text('TimeStamp'),
                      ],
                    ),
                    SizedBox(height: mdheight * 0.01,),
                    const Text('Vehicle Name'),
                    SizedBox(height: mdheight * 0.01,),
                    const Text('Complain Description'),
                    SizedBox(height: mdheight * 0.01,),
                    const Text('Complain Status : Pending'),
                    SizedBox(height: mdheight * 0.01,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(onPressed: (){},
                            color: Colors.deepPurple.shade800,
                            padding: EdgeInsets.symmetric(horizontal: mdhwidth * 0.05, vertical: mdhwidth * 0.01),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(mdheight * 0.015)),
                            ),
                            child: const Text('Proceed Solution', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
