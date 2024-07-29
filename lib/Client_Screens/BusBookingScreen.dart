import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_ticket_booking_system/Client_Screens/SeatReservationPage.dart';
import 'package:bus_ticket_booking_system/Client_Screens/HomeScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/SchedulePage.dart';

class BusBookingScreen extends StatelessWidget {
  final List<DocumentSnapshot> vehicleDocs;

  const BusBookingScreen({super.key, required this.vehicleDocs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: null,
        toolbarHeight: kToolbarHeight,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: vehicleDocs.length,
              itemBuilder: (context, index) {
                final vehicle = vehicleDocs[index].data() as Map<String, dynamic>;
                return BusTile(
                  from: vehicle['from'] ?? 'Unknown',
                  to: vehicle['to'] ?? 'Unknown',
                  date: vehicle['date'] ?? 'Unknown',
                  departureTime: vehicle['departureTime'] ?? 'Unknown',
                  arrivalTime: vehicle['arrivalTime'] ?? 'Unknown',
                  ticketPrice: int.tryParse(vehicle['price'].toString()) ?? 0,
                  availableSeats: int.tryParse(vehicle['availableSeats'].toString()) ?? 0,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }
}

class BusTile extends StatelessWidget {
  final String from;
  final String to;
  final String date;
  final String departureTime;
  final String arrivalTime;
  final int ticketPrice;
  final int availableSeats;

  const BusTile({
    required this.from,
    required this.to,
    required this.date,
    required this.departureTime,
    required this.arrivalTime,
    required this.ticketPrice,
    required this.availableSeats,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_bus, size: 32),
                SizedBox(height: 4),
              ],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          from,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Icon(Icons.arrow_right_alt, color: Colors.orange),
                      Expanded(
                        child: Text(
                          to,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('Date: $date'),
                  Text('Departure Time: $departureTime'),
                  Text('Arrival Time: $arrivalTime'),
                  Text('Available Seats: $availableSeats'),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                    'Rs. $ticketPrice',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SeatReservationPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Booking',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildBottomActions(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, -3),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(Icons.home, 'Home', () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }),
        _buildActionButton(Icons.search, 'Find Trip', () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SchedulePage()));
        }),
        _buildActionButton(Icons.history, 'History', () {
          // Implement History screen navigation
        }),
        _buildActionButton(Icons.support_agent, 'Support', () {
          // Implement Support screen navigation
        }),
      ],
    ),
  );
}

Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
        ),
        child: Icon(icon, color: Colors.white),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 12)),
    ],
  );
}
