import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bus_ticket_booking_system/Client_Screens/HomeScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/PaymentMethodScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/SchedulePage.dart';

import 'LoginScreen.dart';

class SeatReservationPage extends StatefulWidget {
  const SeatReservationPage({super.key});

  @override
  _SeatReservationPageState createState() => _SeatReservationPageState();
}

class _SeatReservationPageState extends State<SeatReservationPage> {
  List<int> selectedSeats = [];
  List<int> reservedSeats = [];
  late Future<List<int>> _seatLayoutFuture;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user == null) {
      // Redirect to login page if the user is not authenticated
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()), // Replace with your login screen
      );
    } else {
      _seatLayoutFuture = _fetchSeatData(); // Initialize the Future
    }
  }

  Future<List<int>> _fetchSeatData() async {
    try {
      final seatData = await FirebaseFirestore.instance
          .collection('vehicles')
          .doc('bus_id') // Replace with the actual document ID or parameter
          .get();

      if (seatData.exists) {
        final data = seatData.data() as Map<String, dynamic>;
        final reserved = List<int>.from(data['reservedSeats'] ?? []);

        setState(() {
          reservedSeats = reserved;
        });

        return List<int>.generate(66, (index) => index + 1);
      } else {
        return List<int>.generate(66, (index) => index + 1);
      }
    } catch (e) {
      print('Error fetching seat data: $e');
      return List<int>.generate(66, (index) => index + 1); // Default fallback
    }
  }

  void _showSeatSelectionPopup(int seatNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seat Selection'),
          content: Text('Choose an option for seat number $seatNumber'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (selectedSeats.contains(seatNumber)) {
                    selectedSeats.remove(seatNumber);
                  } else {
                    selectedSeats.add(seatNumber);
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Select Seat'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  reservedSeats.remove(seatNumber);
                  selectedSeats.remove(seatNumber);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Clear Reservation'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _bookSeats() async {
    if (selectedSeats.isNotEmpty) {
      try {
        final busId = 'bus_id'; // Replace with the actual bus ID
        final userId = _user?.uid; // Get the authenticated user's ID
        if (userId == null) {
          throw Exception('User not authenticated');
        }

        final docRef = FirebaseFirestore.instance.collection('vehicles').doc(busId);
        final bookingRef = FirebaseFirestore.instance.collection('bookings').doc(); // Create a new document for the booking

        // Update reserved seats in the vehicle document
        await docRef.update({
          'reservedSeats': FieldValue.arrayUnion(selectedSeats),
        });

        // Add booking details to a new document in the 'bookings' collection
        await bookingRef.set({
          'busId': busId,
          'seats': selectedSeats,
          'userId': userId,
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'confirmed',
        });

        setState(() {
          reservedSeats.addAll(selectedSeats);
          selectedSeats.clear();
        });

        // Navigate to PaymentScreen or show confirmation
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PaymentMethodScreen(),
          ),
        );
      } catch (e) {
        print('Error booking seats: $e');
        // Handle error (e.g., show a dialog to the user)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Seats Reservation',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<int>>(
        future: _seatLayoutFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No seat data available.'));
          }

          final seatLayout = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.grey[300],
                  child: Row(
                    children: [
                      const Icon(Icons.directions_bus, size: 50),
                      const Spacer(),
                      const Text('Selected', style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 8),
                      Container(width: 16, height: 16, color: Colors.black),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: seatLayout.length,
                    itemBuilder: (context, index) {
                      final int seatNumber = seatLayout[index];
                      final bool isSelected = selectedSeats.contains(seatNumber);
                      final bool isReserved = reservedSeats.contains(seatNumber);

                      return GestureDetector(
                        onTap: isReserved
                            ? null
                            : () {
                          _showSeatSelectionPopup(seatNumber);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.black
                                : isReserved
                                ? Colors.red
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            seatNumber.toString().padLeft(2, '0'),
                            style: TextStyle(
                              color: isSelected || isReserved
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: selectedSeats.isEmpty
                      ? null
                      : () {
                    _bookSeats();
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildBottomActions() {
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
          _buildActionButton(Icons.history, 'History', () {}),
          _buildActionButton(Icons.support_agent, 'Support', () {}),
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
}
