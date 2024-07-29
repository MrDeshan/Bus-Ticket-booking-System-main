import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminVehicleRegistrationForm extends StatefulWidget {
  @override
  _AdminVehicleRegistrationFormState createState() => _AdminVehicleRegistrationFormState();
}

class _AdminVehicleRegistrationFormState extends State<AdminVehicleRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _driverIdController = TextEditingController();
  final TextEditingController _conductorNameController = TextEditingController();
  final TextEditingController _conductorIdController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _availableSeatsController = TextEditingController();

  TimeOfDay? _departureTime;
  TimeOfDay? _arrivalTime;

  String? _selectedClass;
  String? _selectedFromCity;
  String? _selectedToCity;

  final List<String> _classOptions = [
    'Intercity',
    'Semi',
    'Super Luxury',
    'Normal',
  ];

  final List<String> _sriLankanCities = [
    'Colombo',
    'Kandy',
    'Galle',
    'Jaffna',
    'Trincomalee',
    'Batticaloa',
    'Anuradhapura',
    'Ratnapura',
    'Badulla',
    'Negombo',
    // Add more cities as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vehicle Registration',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  'Driver Name',
                  _driverNameController,
                      (value) => value!.isEmpty ? 'Please enter driver name' : null,
                ),
                _buildTextField(
                  'Driver ID Number',
                  _driverIdController,
                      (value) => value!.isEmpty ? 'Please enter driver ID number' : null,
                ),
                _buildTextField(
                  'Conductor Name',
                  _conductorNameController,
                      (value) => value!.isEmpty ? 'Please enter conductor name' : null,
                ),
                _buildTextField(
                  'Conductor ID Number',
                  _conductorIdController,
                      (value) => value!.isEmpty ? 'Please enter conductor ID number' : null,
                ),
                _buildTextField(
                  'Vehicle Number',
                  _vehicleNumberController,
                      (value) => value!.isEmpty ? 'Please enter vehicle number' : null,
                ),
                _buildDropdownField(
                  'From',
                  _sriLankanCities,
                  _selectedFromCity,
                      (String? newValue) {
                    setState(() {
                      _selectedFromCity = newValue;
                    });
                  },
                      (value) => value == null ? 'Please select a starting city' : null,
                ),
                _buildDropdownField(
                  'To',
                  _sriLankanCities,
                  _selectedToCity,
                      (String? newValue) {
                    setState(() {
                      _selectedToCity = newValue;
                    });
                  },
                      (value) => value == null ? 'Please select a destination city' : null,
                ),
                _buildDateField('Date', _dateController),
                _buildTimeField('Departure Time', _departureTime, (time) {
                  setState(() {
                    _departureTime = time;
                  });
                }),
                _buildTimeField('Arrival Time', _arrivalTime, (time) {
                  setState(() {
                    _arrivalTime = time;
                  });
                }),
                _buildTextField(
                  'Price',
                  _priceController,
                      (value) => value!.isEmpty ? 'Please enter price' : null,
                ),
                _buildTextField(
                  'Available Seats',
                  _availableSeatsController,
                      (value) => value!.isEmpty ? 'Please enter available seats' : null,
                ),
                _buildDropdownField(
                  'Class',
                  _classOptions,
                  _selectedClass,
                      (String? newValue) {
                    setState(() {
                      _selectedClass = newValue;
                    });
                  },
                      (value) => value == null ? 'Please select a class' : null,
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_departureTime == _arrivalTime) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Departure and arrival times cannot be the same')),
                          );
                        } else {
                          await _saveData();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String? Function(String?)? validator) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: label,
            ),
            validator: (value) => value!.isEmpty ? 'Please select a date' : null,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      setState(() {
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0]; // Format as YYYY-MM-DD
      });
    }
  }

  Widget _buildTimeField(String label, TimeOfDay? time, ValueChanged<TimeOfDay?> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () => _selectTime(context, onChanged),
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: label,
            ),
            controller: TextEditingController(text: _formatTime(time)),
            validator: (value) => value!.isEmpty ? 'Please select a time' : null,
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, ValueChanged<TimeOfDay?> onChanged) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        onChanged(selectedTime);
      });
    }
  }

  String? _formatTime(TimeOfDay? time) {
    if (time == null) return null;
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dateTime); // Format as '1:00 PM'
  }

  Widget _buildDropdownField(String label, List<String> items, String? value, ValueChanged<String?> onChanged, String? Function(String?)? validator) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
        ),
        validator: validator,
      ),
    );
  }

  Future<void> _saveData() async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Print data being sent to Firestore
      print('Saving data: ${{
        'driverName': _driverNameController.text,
        'driverId': _driverIdController.text,
        'conductorName': _conductorNameController.text,
        'conductorId': _conductorIdController.text,
        'vehicleNumber': _vehicleNumberController.text,
        'from': _selectedFromCity,
        'to': _selectedToCity,
        'date': _dateController.text,
        'departureTime': _departureTime != null ? _formatTime(_departureTime) : null,
        'arrivalTime': _arrivalTime != null ? _formatTime(_arrivalTime) : null,
        'price': int.tryParse(_priceController.text) ?? 0,
        'availableSeats': int.tryParse(_availableSeatsController.text) ?? 0,
        'class': _selectedClass,
      }}');

      await firestore.collection('vehicles').add({
        'driverName': _driverNameController.text,
        'driverId': _driverIdController.text,
        'conductorName': _conductorNameController.text,
        'conductorId': _conductorIdController.text,
        'vehicleNumber': _vehicleNumberController.text,
        'from': _selectedFromCity,
        'to': _selectedToCity,
        'date': _dateController.text,
        'departureTime': _departureTime != null ? _formatTime(_departureTime) : null,
        'arrivalTime': _arrivalTime != null ? _formatTime(_arrivalTime) : null,
        'price': int.tryParse(_priceController.text) ?? 0,
        'availableSeats': int.tryParse(_availableSeatsController.text) ?? 0,
        'class': _selectedClass,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data saved successfully!')),
      );
    } catch (e) {
      print('Error saving data: $e'); // Log error to console
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }
}
