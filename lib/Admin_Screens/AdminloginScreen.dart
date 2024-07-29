import 'package:bus_ticket_booking_system/Admin_Screens/Adminhomescreen.dart';
import 'package:bus_ticket_booking_system/Admin_Screens/AdminsignupScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/ForgotPasswordScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class AdminloginScreen extends StatefulWidget {
  const AdminloginScreen({super.key});

  @override
  _AdminloginScreenState createState() => _AdminloginScreenState();
}

class _AdminloginScreenState extends State<AdminloginScreen> {
  bool _keepMeSignedIn = false;
  String _email = '';
  String _password = '';
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadKeepMeSignedInPreference();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool get _isFormValid {
    return _formKey.currentState?.validate() ?? false;
  }

  Future<void> _login() async {
    if (!_isFormValid) return;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // Check if user is an admin
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user?.uid).get();

      if (userDoc.exists) {
        bool isAdmin = userDoc.get('isAdmin') ?? false;

        if (isAdmin) {
          if (_keepMeSignedIn) {
            await _saveKeepMeSignedInPreference(true);
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Adminhomescreen(),
            ),
          );
        } else {
          _auth.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You are not authorized as an admin')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User document does not exist')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  Future<void> _saveKeepMeSignedInPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('keepMeSignedIn', value);
  }

  Future<void> _loadKeepMeSignedInPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _keepMeSignedIn = prefs.getBool('keepMeSignedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(35.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Admin Login',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Welcome back to the app',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Email',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Eg:- example@gmail.com',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(value)) {
                    return 'Please enter a valid Gmail address';
                  }
                  return null;
                },
                onChanged: (value) {
                  _email = value;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Password',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Eg:- *******',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onChanged: (value) {
                  _password = value;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _keepMeSignedIn,
                    onChanged: (bool? value) {
                      setState(() {
                        _keepMeSignedIn = value ?? false; // Default to false if value is null
                      });
                      _saveKeepMeSignedInPreference(_keepMeSignedIn);
                    },
                  ),
                  const Text('Keep me signed in'),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminsignupScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Create an account',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
