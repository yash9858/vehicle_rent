import 'package:flutter/Material.dart';
import 'package:line_icons/line_icons.dart';

class Admin_FeedbackPage extends StatefulWidget {
  const Admin_FeedbackPage({super.key});

  @override
  State<Admin_FeedbackPage> createState() => _Admin_FeedbackPageState();
}

class _Admin_FeedbackPageState extends State<Admin_FeedbackPage> {
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
        title: const Text('Feedbacks'),
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
                      const Text('Comments'),
                      SizedBox(height: mdheight * 0.01,),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Feedback :'),
                          Icon(LineIcons.starAlt, color: Colors.amber,),
                          Icon(LineIcons.starAlt, color: Colors.amber,),
                          Icon(LineIcons.starAlt, color: Colors.amber,),
                          Icon(LineIcons.starHalf, color: Colors.amber),
                          Icon(LineIcons.star, color: Colors.amber,),
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
