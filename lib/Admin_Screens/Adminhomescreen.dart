import 'package:bus_ticket_booking_system/Admin_Screens/AdminVehicleRegistrationForm.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Adminhomescreen());
}

class Adminhomescreen extends StatelessWidget {
  const Adminhomescreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: Text(''),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person, color: Colors.black),
                ),
                SizedBox(width: 8),
                Text('T.M. Perera', style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Reduced padding
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: 7,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return _buildGridItem(context, Icons.app_registration, 'Vehicle Registration', AdminVehicleRegistrationForm());
              case 1:
                return _buildGridItem(context, Icons.directions_bus, 'Bus Management', BusManagementScreen());
              case 2:
                return _buildGridItem(context, Icons.payment, 'Payment Management', PaymentManagementScreen());
              case 3:
                return _buildGridItem(context, Icons.bookmark, 'Booking Management', BookingManagementScreen());
              case 4:
                return _buildGridItem(context, Icons.person, 'Manage User Account', ManageUserAccountScreen());
              case 5:
                return _buildGridItem(context, Icons.notifications, 'Notification', NotificationScreen());
              case 6:
                return _buildGridItem(context, Icons.logout, 'LogOut', LogOutScreen());
              default:
                return SizedBox.shrink(); // Default case
            }
          },
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, IconData icon, String label, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Icon
            Icon(
              icon,
              size: 60,
              color: Colors.orange,
            ),
            // Centered Text
            Positioned(
              bottom: 8, // Position the text a bit above the bottom
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Define separate screen widgets
class VehicleRegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Registration'),
      ),
      body: Center(child: Text('Vehicle Registration Screen')),
    );
  }
}

class BusManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Management'),
      ),
      body: Center(child: Text('Bus Management Screen')),
    );
  }
}

class PaymentManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Management'),
      ),
      body: Center(child: Text('Payment Management Screen')),
    );
  }
}

class BookingManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Management'),
      ),
      body: Center(child: Text('Booking Management Screen')),
    );
  }
}

class ManageUserAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage User Account'),
      ),
      body: Center(child: Text('Manage User Account Screen')),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Center(child: Text('Notification Screen')),
    );
  }
}

class LogOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LogOut'),
      ),
      body: Center(child: Text('LogOut Screen')),
    );
  }
}
