// ignore_for_file: prefer_const_constructors, sort_child_properties_last, camel_case_types, use_key_in_widget_constructors, sized_box_for_whitespace, library_private_types_in_public_api, non_constant_identifier_names, avoid_print, use_super_parameters, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdminWelcomeScreen extends StatelessWidget {
  const AdminWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 70),
          Image.network(
            "https://www.wsp.com/-/media/news/us/image/lin-wsp-capmetro-bus-yard.jpg",
            fit: BoxFit.cover,
            height: 360.0,
            width: double.infinity,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'Become an admin and streamline your bus ticketing operations',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/admin_signup');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(230, 68, 30, 1),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text(
                        'SignUp',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/admin_login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(228, 231, 235, 1),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromRGBO(230, 68, 30, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}