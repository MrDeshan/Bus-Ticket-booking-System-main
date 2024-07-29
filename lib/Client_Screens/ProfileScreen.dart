import 'package:flutter/material.dart';
import 'package:bus_ticket_booking_system/Client_Screens/HomeScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/PersonalInfoScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/SchedulePage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Nimesh Dilshan'),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.orange, Colors.deepOrange],
                    ),
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 60, color: Colors.orange),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildProfileOption(
                  icon: Icons.person,
                  title: 'Personal Information',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalInfoScreen())),
                ),
                _buildProfileOption(
                  icon: Icons.help_outline,
                  title: 'FAQ',
                  onTap: () {},
                ),
                _buildProfileOption(
                  icon: Icons.description,
                  title: 'Terms & Conditions',
                  onTap: () {},
                ),
                _buildProfileOption(
                  icon: Icons.phone,
                  title: 'Contact Us',
                  onTap: () {},
                ),
                _buildProfileOption(
                  icon: Icons.logout,
                  title: 'Log Out',
                  onTap: () {},
                  isDestructive: true,
                ),
              ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.orange),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : Colors.black87)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
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
