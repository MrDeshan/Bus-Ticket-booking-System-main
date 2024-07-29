import 'package:bus_ticket_booking_system/Client_Screens/LoginScreen.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String? _password;
  String? _reEnterPassword;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      if (_password == _reEnterPassword) {
        // Proceed with the reset password logic
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Reset Password',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter your new password below',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
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
                  _password = value;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Re-enter Password',
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
                    return 'Please re-enter your password';
                  }
                  _reEnterPassword = value;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}