import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bus_ticket_booking_system/Client_Screens/ProfileScreen.dart' as profile_screen;
import 'package:bus_ticket_booking_system/Client_Screens/SchedulePage.dart' as schedule_page;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _notificationPageController = PageController();
  int _currentNotificationPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startNotificationTimer();
  }

  void _startNotificationTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentNotificationPage < 2) {
        _currentNotificationPage++;
      } else {
        _currentNotificationPage = 0;
      }
      _notificationPageController.animateToPage(
        _currentNotificationPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _notificationPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 24),
                  _buildWelcomeSection(),
                  const SizedBox(height: 24),
                  _buildNotificationSlider(),
                  const SizedBox(height: 24),
                  _buildPhotoSlider(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.shade200,
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.orange),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const profile_screen.ProfileScreen())),
            ),
          ),
          Text(
            '${TimeOfDay.now().format(context)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // Handle language switch
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Where would you like to go today?', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSlider() {
    return SizedBox(
      height: 100,
      child: PageView(
        controller: _notificationPageController,
        children: [
          _notificationCard('Special offer: 20% off on weekend trips!', Colors.orange),
          _notificationCard('New route added: City A to City B', Colors.blue),
          _notificationCard('Reminder: Book early for holiday season', Colors.green),
        ],
      ),
    );
  }

  Widget _notificationCard(String message, Color color) {
    return Card(
      color: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Center(child: Text(message, style: const TextStyle(fontSize: 16))),
    );
  }

  Widget _buildPhotoSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
      items: [
        'https://example.com/image1.jpg',
        'https://example.com/image2.jpg',
        'https://example.com/image3.jpg',
      ].map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
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
          _buildActionButton(Icons.home, 'Home', () {}),
          _buildActionButton(Icons.search, 'Find Trip', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const schedule_page.SchedulePage()));
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