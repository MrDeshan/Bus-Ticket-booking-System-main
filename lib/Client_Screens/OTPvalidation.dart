// ignore_for_file: prefer_const_constructors, sort_child_properties_last, camel_case_types, use_key_in_widget_constructors, sized_box_for_whitespace, library_private_types_in_public_api, non_constant_identifier_names, avoid_print, use_super_parameters, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OTPvalidation extends StatelessWidget {
  const OTPvalidation({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Text(
              'Password Reset',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Enter your new verification code',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement your verification functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                ),
                child: Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}