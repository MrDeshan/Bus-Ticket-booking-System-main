// ignore_for_file: prefer_const_constructors, sort_child_properties_last, camel_case_types, use_key_in_widget_constructors, sized_box_for_whitespace, library_private_types_in_public_api, non_constant_identifier_names, avoid_print, use_super_parameters, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class downloadslipcard extends StatelessWidget {
  const downloadslipcard ({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[300],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Payment Successful',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Icon(
                  Icons.check_circle,
                  color: Colors.orange,
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  'Download Booking Details Here',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Implement your download functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.download),
                      SizedBox(width: 8),
                      Text('Download'),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Thank You',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}