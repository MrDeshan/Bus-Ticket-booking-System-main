import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool _isEmailValid = false;
  bool _isLoading = false;

  void _handleInputChange() {
    setState(() {
      _isEmailValid = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> _sendResetLink() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        _showSnackBar('Password reset email sent. Please check your inbox.');
        // Clear the email field after successful submission
        setState(() {
          _email = '';
          _isEmailValid = false;
        });
        _formKey.currentState?.reset();
      } on FirebaseAuthException catch (e) {
        String message = _getErrorMessage(e);
        _showSnackBar(message);
        debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      } catch (e) {
        _showSnackBar('Error: ${e.toString()}');
        debugPrint('Exception: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'If this email is registered, a password reset link has been sent. Please check your inbox.';
      default:
        return 'An error occurred. Please try again later.';
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''), // Removed "Forgot Password" text
      ),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Form(
          key: _formKey,
          onChanged: _handleInputChange,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Forgot Password',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter your registered email below to receive password reset instructions',
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
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onChanged: (value) {
                  _email = value;
                  _handleInputChange();
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isEmailValid && !_isLoading ? _sendResetLink : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEmailValid && !_isLoading ? Colors.orange : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Send Reset Link', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
