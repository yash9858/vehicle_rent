// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
//
// class ReportAdmin extends StatefulWidget {
//   const ReportAdmin({super.key});
//
//   @override
//   State<ReportAdmin> createState() => _ReportAdminState();
// }
//
// class _ReportAdminState extends State<ReportAdmin> {
//
//   Future<void> generatePDF(String heading, List<Map<String, dynamic>> tableData) async {
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         build: (context) => pw.ListView(
//           children: [
//             pw.Text(heading, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 20),
//             pw.TableHelper.fromTextArray(
//                 cellAlignment: pw.Alignment.center,
//                 data: <List<String>>[
//                   ["Booking Id","Date & TIme","User"],
//                   ...tableData.map((row) => row.values.map((e) => e.toString()).toList()).toList(),
//                 ]
//             ),
//           ],
//         ),
//       ),
//     );
//
//     final output = await getExternalStorageDirectory();
//     final file = File('${output?.path}/booking_report.pdf');
//     await file.writeAsBytes(await pdf.save());
//     await OpenFile.open(file.path);
//   }
//
//   String formatDate(String date) {
//     DateTime dateTime = DateTime.parse(date);
//     return DateFormat('dd/MM/yyyy & HH:mm').format(dateTime);
//   }
//
//   bool isLoading = false;
//   dynamic data;
//   dynamic ne;
//   dynamic data1;
//   dynamic ne1;
//   dynamic data2;
//   dynamic ne2;
//
//   @override
//   void initState() {
//     super.initState();
//     month();
//     day();
//     year();
//   }
//
//   Future month() async {
//     setState(() {
//       isLoading = true;
//     });
//     http.Response response = await http.get(Uri.parse(
//     "https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Report_Admin_Month.php",
//     ));
//     if (response.statusCode == 200) {
//       data = response.body;
//     }
//     setState(() {
//       ne = jsonDecode(data!)["users"];
//       isLoading = false;
//     });
//   }
//
//   Future day() async {
//     setState(() {
//       isLoading = true;
//     });
//     http.Response response = await http.get(Uri.parse(
//        "https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Report_Admin_Date.php",
//     ));
//     if (response.statusCode == 200) {
//       data1 = response.body;
//     }
//     setState(() {
//       ne1 = jsonDecode(data1!)["users"];
//       isLoading = false;
//     });
//   }
//
//   Future year() async {
//     setState(() {
//       isLoading = true;
//     });
//     http.Response response = await http.get(Uri.parse(
//     "https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Report_Admin_Year.php",
//     ));
//     if (response.statusCode == 200) {
//       data2 = response.body;
//     }
//     setState(() {
//       ne2 = jsonDecode(data2!)["users"];
//       isLoading = false;
//     });
//   }
//
//   dynamic selectedValue;
//
//   @override
//   Widget build(BuildContext context) {
//     var mdheight = MediaQuery.sizeOf(context).height;
//     return Scaffold(
//       appBar: AppBar(
//         titleTextStyle: TextStyle(
//           color: Colors.white,
//           fontSize: mdheight * 0.025,
//         ),
//         title: const Text('Generate Report'),
//         backgroundColor: Colors.deepPurple.shade800,
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//         centerTitle: true,
//       ),
//       body: isLoading ? const Center(
//           child: CircularProgressIndicator(color: Colors.deepPurple))
//           : Padding(
//         padding: const EdgeInsets.all(20),
//         child: ListView(
//           children: [
//             const SizedBox(height: 20),
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton2(
//                   hint: const Text(
//                     'Select',
//                     style: TextStyle(
//                       fontSize: 14,
//                     ),
//                   ),
//                   items: const [
//                     DropdownMenuItem(value: "day", child: Text("This Day")),
//                     DropdownMenuItem(value: "month", child: Text("This Month")),
//                     DropdownMenuItem(value: "year", child: Text("This Year")),
//                   ],
//                   value: selectedValue,
//                   onChanged: (value) {
//                     setState(() {
//                       selectedValue = value.toString();
//                     });
//                   },
//                   buttonStyleData: const ButtonStyleData(
//                     padding: EdgeInsets.symmetric(horizontal: 16),
//                     height: 40,
//                     width: 140,
//                   ),
//                   menuItemStyleData: const MenuItemStyleData(
//                     height: 40,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: selectedValue == 'month'
//                   ? DataTable(
//                 columns: const [
//                   DataColumn(label: Text("Booking Id")),
//                   DataColumn(label: Text("Date & Time")),
//                   DataColumn(label: Text("User")),
//                 ],
//                 rows: List.generate(
//                   ne.length,
//                       (index) {
//                     return DataRow(cells: [
//                       DataCell(Text(ne[index]["Booking_Id"])),
//                       DataCell(Text(formatDate(ne[index]["Booking_Timestamp"]))),
//                       DataCell(Text(ne[index]["Name"])),
//                     ]);
//                   },
//                 ),
//               )
//                   : selectedValue == 'day'
//                   ? DataTable(
//                 columns: const [
//                   DataColumn(label: Text("Booking Id")),
//                   DataColumn(label: Text("Date & Time")),
//                   DataColumn(label: Text("User")),
//                 ],
//                 rows: List.generate(
//                   ne1.length,
//                       (index) {
//                     return DataRow(cells: [
//                       DataCell(Text(ne1[index]["Booking_Id"])),
//                       DataCell(Text(formatDate(ne1[index]["Booking_Timestamp"]))),
//                       DataCell(Text(ne1[index]["Name"])),
//                     ]);
//                   },
//                 ),
//               ) : selectedValue == 'year'
//                   ? DataTable(
//                 columns: const [
//                   DataColumn(label: Text("Booking Id")),
//                   DataColumn(label: Text("Date & Time")),
//                   DataColumn(label: Text("User")),
//                 ],
//                 rows: List.generate(
//                   ne2.length,
//                       (index) {
//                     return DataRow(cells: [
//                       DataCell(Text(ne2[index]["Booking_Id"])),
//                       DataCell(Text(formatDate(ne2[index]["Booking_Timestamp"]))),
//                       DataCell(Text(ne2[index]["Name"])),
//                     ]);
//                   },
//                 ),
//               )
//                   : const Text("Please select the filter"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 if (selectedValue != null) {
//                   String heading = 'Booking Report';
//                   if (selectedValue == 'month') {
//                     heading = 'Monthly Booking Report';
//                   } else if (selectedValue == 'day') {
//                     heading = 'Daily Booking Report';
//                   } else if (selectedValue == 'year') {
//                     heading = 'Yearly Booking Report';
//                   }
//                   List<Map<String, dynamic>> tableData = [];
//                   if (selectedValue == 'month') {
//                     tableData = ne.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
//                   } else if (selectedValue == 'day') {
//                     tableData = ne1.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
//                   } else if (selectedValue == 'year') {
//                     tableData = ne2.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
//                   }
//                   generatePDF(heading, tableData);
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple.shade800),
//               child: const Text("Generate PDF"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
