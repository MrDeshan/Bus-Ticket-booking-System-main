/*import 'package:bus_ticket_booking_system/Client_Screens/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Startslide extends StatelessWidget {
  const Startslide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              margin: EdgeInsets.only(bottom: 150),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Center(
                child: Text(
                  'Bus Service',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/admin_welcome');
                // Add functionality for Admin button
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              ),
              child: Text(
                'Admin',
                style: TextStyle(
                  fontSize: 32,
                  color: const Color.fromARGB(255, 247, 252, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpScreen())
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              ),
              child: Text(
                'Client',
                style: TextStyle(
                  fontSize: 32,
                  color: Color.fromARGB(255, 252, 238, 238),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/