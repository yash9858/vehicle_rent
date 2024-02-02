import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<Reservation> reservations; // Assuming you have a Reservation class

  HistoryPage({required this.reservations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rental History'),
      ),
      body: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Reservation ${index + 1}'),
            subtitle: Text(
                'Vehicle: ${reservations[index].vehicleName}\nDate: ${reservations[index].reservationDate}'),
            onTap: () {
              // Handle onTap, e.g., navigate to a details page
              // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage(reservation: reservations[index])));
            },
          );
        },
      ),
    );
  }
}

class Reservation {
  final String vehicleName;
  final DateTime reservationDate;

  Reservation({required this.vehicleName, required this.reservationDate});
}
