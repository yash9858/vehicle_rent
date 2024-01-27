import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/Login_Screen.dart';
import 'Booking_Admin.dart';
import 'Complain_Admin.dart';
import 'Feedback_Admin.dart';
import 'Payment_Admin.dart';
import 'UserList_Admin.dart';
import 'Vehicle_Admin.dart';
import 'Vehicle_Category_Admin.dart';

class DrawerNavigationItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final bool selected;
  final Function() onTap;
  const DrawerNavigationItem({
    Key? key,
    required this.iconData,
    required this.title,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      leading: Icon(iconData),
      onTap: onTap,
      title: Text(title),
      selectedTileColor: Colors.white,
      selected: selected,
      selectedColor: Colors.black,
      textColor: Colors.white,
      iconColor: Colors.white,
    );
  }
}

class DrawerHeader extends StatelessWidget {
  const DrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text(
      "Hello Admin !",
      style: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    ),
    );
  }
}

class Admin_DashBoard extends StatefulWidget {
  const Admin_DashBoard({super.key});
  @override
  State<Admin_DashBoard> createState() => _Admin_DashBoardState();
}

class _Admin_DashBoardState extends State<Admin_DashBoard> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    var name2 = ['yash','raj','sachin','anuj'];
    var name = ['Total User', 'Total Vehicle','Total Booking', 'Total Payment'];
    var total = ['23000', '1500', '700', '20972'];
    var page = const [Admin_UserPage(), Admin_VehiclePage(), Admin_BookingPage(), Admin_PaymentPage()];
    var start = ['12.00','10.00','8.00', '20.00'];
    var end = ['18.00','15.00','12.00', '5.00'];
    var status = ['done', 'pending', 'done', 'done'];
    var adr = ['shahpur', 'naroda', 'nava vadaj', 'rajiv nagar'];

    var mdheight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.deepPurple.shade800,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(mdheight * 0.015),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DrawerHeader(),
                 SizedBox(
                  height: mdheight * 0.018,
                ),
                DrawerNavigationItem(
                  iconData:  Icons.home_rounded,
                  title: "Admin DashBoard",
                  selected: _currentIndex == 0,
                  onTap: () =>
                  {
                    setState(() => _currentIndex = 0),
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Admin_DashBoard())),
                  },
                ),
                DrawerNavigationItem(
                  iconData:Icons.account_circle_rounded,
                  title: "Manage User",
                  selected: _currentIndex == 1,
                  onTap: () =>
                  {
                    setState(() => _currentIndex = 1),
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Admin_UserPage())),
                    _currentIndex = 0
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.list,
                  title: "Manage Category",
                  selected: _currentIndex == 2,
                  onTap: () =>
                  {
                    setState(() => _currentIndex = 2),
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const Admin_CategoryPage())),
                    _currentIndex = 0
                  },
                ),
                DrawerNavigationItem(
                  iconData:LineIcons.car,
                  title: "Manage Vehicle",
                  selected: _currentIndex == 3,
                  onTap: () =>
                  {
                    setState(() => _currentIndex = 3),
                    Navigator.push(context , MaterialPageRoute(builder: (context) => const Admin_VehiclePage())),
                    _currentIndex = 0
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.date_range_sharp,
                  title: "Manage Bookings",
                  selected: _currentIndex == 4,
                  onTap: () =>
                  {
                    setState(() => _currentIndex = 4),
                    Navigator.push(context , MaterialPageRoute(builder: (context) => const Admin_BookingPage())),
                    _currentIndex = 0
                  },
                ),
                DrawerNavigationItem(
                  iconData:Icons.paid_rounded,
                  title: "Manage Payments",
                  selected: _currentIndex == 5,
                  onTap: () =>
                  {
                    setState(() => _currentIndex = 5),
                    Navigator.push(context , MaterialPageRoute(builder: (context) => const Admin_PaymentPage())),
                    _currentIndex = 0
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.forum,
                  title: "Manage Complains",
                  selected: _currentIndex == 6,
                  onTap: () =>
                  {
                    setState(() => _currentIndex = 6),
                    Navigator.push(context , MaterialPageRoute(builder: (context) => const Admin_ComplainPage())),
                    _currentIndex = 0
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.feedback_rounded,
                  title: "Manage Feedbacks",
                  selected: _currentIndex == 7,
                  onTap: () =>
                  {
                    setState(() => _currentIndex = 7),
                    Navigator.push(context , MaterialPageRoute(builder: (context) => const Admin_FeedbackPage())),
                    _currentIndex = 0
                  },
                ),
                DrawerNavigationItem(
                  iconData: Icons.logout_outlined,
                  title: "Log Out",
                  selected: _currentIndex == 8,
                  onTap: () =>
                  {
                    setState(() => _currentIndex = 8),
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginPage())),
                    _currentIndex = 0
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        leading: Builder(
          builder: (context){
          return IconButton(icon: const Icon(Icons.sort),
          onPressed: () => Scaffold.of(context).openDrawer());
          }),
        title: const Text('Admin Dash Board'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Padding(padding: EdgeInsets.all(mdheight * 0.015),
                child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: mdheight * 0.012,
                  mainAxisSpacing: mdheight * 0.012,
                  mainAxisExtent: mdheight * 0.09,
                ),
                itemCount: name.length,
                itemBuilder: (context , int index)
                {
                  return InkWell(
                    child: Card(
                    elevation: 9.0,
                    color: Colors.white,
                    child: Padding(
                        padding: EdgeInsets.all(mdheight * 0.015),
                        child: Column(
                          children: [
                            Text(name[index]),
                            Text(total[index]),
                          ],
                        )),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> page[index]));
                      }
                  );
                },
              )),
            Padding(padding: EdgeInsets.all(mdheight * 0.015),
            child: Container(
              height: 400,
              color: Colors.deepPurple.shade800,
            )),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
              headingRowHeight: 50,
              dividerThickness: 1,
              columns: const [
              DataColumn(label: Text("Booking Id")),
              DataColumn(label: Text("User Name")),
              DataColumn(label: Text("Start Time")),
              DataColumn(label: Text("Return Time")),
              DataColumn(label: Text("Booking Status")),
              DataColumn(label: Text("Address")),
              ],
              rows: List.generate(4, (index) {
              return DataRow(
              cells:[
                DataCell(Text('$index')),
                DataCell(Text(name2[index])),
                DataCell(Text(start[index])),
                DataCell(Text(end[index])),
                DataCell(Text(status[index])),
                DataCell(Text(adr[index])),
              ],
              );}
          ))),
            SizedBox(height : 40),
          ]),
      ),
    );
  }
}
