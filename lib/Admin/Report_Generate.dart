import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Report_Admin extends StatefulWidget {
  const Report_Admin({super.key});

  @override
  State<Report_Admin> createState() => _Report_AdminState();
}

class _Report_AdminState extends State<Report_Admin> {

  Future<void> generatePDF(String heading, List<Map<String, dynamic>> tableData) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.ListView(
          children: [
            pw.Text(heading, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
                cellAlignment: pw.Alignment.center,
                //headerAlignment: pw.Alignment.centerLeft,
                data: <List<String>>[
                  ["Booking Id","Date & TIme","User"],
                  ...tableData.map((row) => row.values.map((e) => e.toString()).toList()).toList(),
                ]

            ),
          ],
        ),
      ),
    );
    final output = await getExternalStorageDirectory();
    final file = File('${output?.path}/booking_report.pdf');
    await file.writeAsBytes(await pdf.save());

    await OpenFile.open(file.path);
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy & HH:mm').format(dateTime);
  }

  bool isLoading = false;
  var data;
  var ne;
  var data1;
  var ne1;
  var data2;
  var ne2;

  @override
  void initState() {
    super.initState();
    month();
    day();
    year();
  }

  Future month() async {
    setState(() {
      isLoading = true;
    });
    http.Response response = await http.get(Uri.parse(
    "https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Report_Admin_Month.php",
    ));
    if (response.statusCode == 200) {
      data = response.body;
    }
    setState(() {
      ne = jsonDecode(data!)["users"];
      isLoading = false;
    });
  }

  Future day() async {
    setState(() {
      isLoading = true;
    });
    http.Response response = await http.get(Uri.parse(
       "https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Report_Admin_Date.php",
    ));
    if (response.statusCode == 200) {
      data1 = response.body;
    }
    setState(() {
      ne1 = jsonDecode(data1!)["users"];
      isLoading = false;
    });
  }

  Future year() async {
    setState(() {
      isLoading = true;
    });
    http.Response response = await http.get(Uri.parse(
    "https://road-runner24.000webhostapp.com/API/Page_Fetch_API/Report_Admin_Year.php",
    ));
    if (response.statusCode == 200) {
      data2 = response.body;
    }
    setState(() {
      ne2 = jsonDecode(data2!)["users"];
      isLoading = false;
    });
  }

  var selectedvalue;

  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: mdheight * 0.025,
        ),
        title: const Text('Generate Report'),
        backgroundColor: Colors.deepPurple.shade800,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: isLoading ? Center(
          child: CircularProgressIndicator(color: Colors.deepPurple))
          : Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  hint: Text(
                    'Select',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(child: Text("This Day"), value: "day"),
                    DropdownMenuItem(child: Text("This Month"), value: "month"),
                    DropdownMenuItem(child: Text("This Year"), value: "year"),
                  ],
                  value: selectedvalue,
                  onChanged: (value) {
                    setState(() {
                      selectedvalue = value.toString();
                    });
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    width: 140,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: selectedvalue == 'month'
                  ? DataTable(
                columns: [
                  DataColumn(label: Text("Booking Id")),
                  DataColumn(label: Text("Date & Time")),
                  DataColumn(label: Text("User")),
                ],
                rows: List.generate(
                  ne.length,
                      (index) {
                    return DataRow(cells: [
                      DataCell(Text(ne[index]["Booking_Id"])),
                      DataCell(Text(formatDate(ne[index]["Booking_Timestamp"]))),
                      DataCell(Text(ne[index]["Name"])),
                    ]);
                  },
                ),
              )
                  : selectedvalue == 'day'
                  ? DataTable(
                columns: [
                  DataColumn(label: Text("Booking Id")),
                  DataColumn(label: Text("Date & Time")),
                  DataColumn(label: Text("User")),
                ],
                rows: List.generate(
                  ne1.length,
                      (index) {
                    return DataRow(cells: [
                      DataCell(Text(ne1[index]["Booking_Id"])),
                      DataCell(Text(formatDate(ne1[index]["Booking_Timestamp"]))),
                      DataCell(Text(ne1[index]["Name"])),
                    ]);
                  },
                ),
              )
                  : selectedvalue == 'year'
                  ? DataTable(
                columns: [
                  DataColumn(label: Text("Booking Id")),
                  DataColumn(label: Text("Date & Time")),
                  DataColumn(label: Text("User")),
                ],
                rows: List.generate(
                  ne2.length,
                      (index) {
                    return DataRow(cells: [
                      DataCell(Text(ne2[index]["Booking_Id"])),
                      DataCell(Text(formatDate(ne2[index]["Booking_Timestamp"]))),
                      DataCell(Text(ne2[index]["Name"])),
                    ]);
                  },
                ),
              )
                  : Text("Please select the filter"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedvalue != null) {
                  String heading = 'Booking Report';
                  if (selectedvalue == 'month') {
                    heading = 'Monthly Booking Report';
                  } else if (selectedvalue == 'day') {
                    heading = 'Daily Booking Report';
                  } else if (selectedvalue == 'year') {
                    heading = 'Yearly Booking Report';
                  }
                  List<Map<String, dynamic>> tableData = [];
                  if (selectedvalue == 'month') {
                    tableData = ne.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
                  } else if (selectedvalue == 'day') {
                    tableData = ne1.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
                  } else if (selectedvalue == 'year') {
                    tableData = ne2.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
                  }
                  generatePDF(heading, tableData);
                }
              },
              child: Text("Generate PDF"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade800),
            ),
          ],
        ),
      ),
    );
  }
}
