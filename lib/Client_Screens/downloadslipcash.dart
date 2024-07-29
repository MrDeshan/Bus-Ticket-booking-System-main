import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DownloadSlipCash extends StatelessWidget {
  const DownloadSlipCash({super.key});

  // Check if the current user is an admin
  Future<bool> isAdmin() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final idTokenResult = await user.getIdTokenResult();
        // Check for the 'admin' claim
        return idTokenResult.claims?['admin'] ?? false;
      } catch (e) {
        print('Error fetching admin status: $e');
        return false; // Default to false if there's an error
      }
    }
    return false; // Default to false if user is null
  }

  // Fetch booking details from Firestore
  Future<Map<String, dynamic>> _fetchBookingDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      bool admin = await isAdmin();
      String userId = user.uid;

      // You may need to adjust the bus_id based on your app logic
      String busId = 'example_bus_id'; // Replace with actual bus_id logic

      DocumentSnapshot snapshot;

      if (admin) {
        // Admin can view any bus details
        snapshot = await FirebaseFirestore.instance
            .collection('buses')
            .doc(busId) // Use the correct bus_id
            .get();
      } else {
        // Non-admin can only view their own booked bus details
        snapshot = await FirebaseFirestore.instance
            .collection('buses')
            .where('bookedBy', isEqualTo: userId)
            .get()
            .then((querySnapshot) => querySnapshot.docs.isNotEmpty
            ? querySnapshot.docs.first
            : throw Exception('No booking found for user'));
      }

      if (snapshot.exists) {
        print('Document data: ${snapshot.data()}'); // Debugging statement
        return snapshot.data() as Map<String, dynamic>? ?? {};
      } else {
        throw Exception('Document not found');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          color: Colors.grey[300],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pay During Journey',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'You will pay directly to the conductor when you board the bus. Please keep the exact change ready.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              FutureBuilder<Map<String, dynamic>>(
                future: _fetchBookingDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No booking details available');
                  } else {
                    var bookingDetails = snapshot.data!;
                    print('Booking details: $bookingDetails'); // Debugging statement
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Booking Details:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Name: ${bookingDetails['bookedBy'] ?? 'N/A'}'),
                        Text('Date: ${bookingDetails['date'] ?? 'N/A'}'),
                        Text('Time: ${bookingDetails['time'] ?? 'N/A'}'),
                        Text('Seat Number: ${bookingDetails['seatNumber'] ?? 'N/A'}'),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Implement your download functionality here
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey[700],
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Download'),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Thank You',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
