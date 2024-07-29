import 'package:bus_ticket_booking_system/Client_Screens/BusBookingScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/HomeScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/ProfileScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? _selectedClass;
  String? _selectedFromCity;
  String? _selectedToCity;

  final List<String> _cities = [
    'Colombo',
    'Kandy',
    'Galle',
    'Jaffna',
    'Trincomalee',
    'Batticaloa',
    'Anuradhapura',
    'Ratnapura',
    'Badulla',
    'Negombo'
  ];

  final List<String> _busClasses = [
    'Intercity',
    'Semi',
    'Super Luxury',
    'Normal'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Customize your app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Bus Schedule',
                  style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildDropdownField('From', _selectedFromCity, (value) {
                  setState(() {
                    _selectedFromCity = value;
                  });
                }),
                const SizedBox(height: 20),
                _buildDropdownField('To', _selectedToCity, (value) {
                  setState(() {
                    _selectedToCity = value;
                  });
                }),
                const SizedBox(height: 20),
                _buildDateField(),
                const SizedBox(height: 20),
                _buildDropdownField('Class', _selectedClass, (value) {
                  setState(() {
                    _selectedClass = value;
                  });
                }, items: _busClasses),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (_selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a departure date')),
                        );
                        return;
                      }
                      if (_selectedClass == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a class')),
                        );
                        return;
                      }

                      // Query Firestore
                      final CollectionReference vehicles = FirebaseFirestore.instance.collection('vehicles');
                      QuerySnapshot querySnapshot = await vehicles
                          .where('from', isEqualTo: _selectedFromCity)
                          .where('to', isEqualTo: _selectedToCity)
                          .where('class', isEqualTo: _selectedClass)
                          .get();

                      List<DocumentSnapshot> vehicleDocs = querySnapshot.docs;

                      // Navigate to BusBookingScreen with search results
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusBookingScreen(vehicleDocs: vehicleDocs),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Set your desired button color here
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: TextEditingController(
        text: _selectedDate != null ? _selectedDate!.toLocal().toString().split(' ')[0] : '',
      ),
      decoration: const InputDecoration(
        labelText: 'Departure',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.date_range),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (date != null) {
          setState(() {
            _selectedDate = date;
          });
        }
      },
    );
  }

  Widget _buildDropdownField(String label, String? selectedValue, ValueChanged<String?> onChanged, {List<String>? items}) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: (items ?? _cities)
          .map((value) => DropdownMenuItem(
        value: value,
        child: Text(value),
      ))
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select $label';
        }
        return null;
      },
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          }),
          _buildActionButton(Icons.search, 'Find Trip', () {
            // This button is already on SchedulePage; consider removing or changing action
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
}
