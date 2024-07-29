// ignore_for_file: unused_import

import 'package:flutter/material.dart';

//import 'package:bus_ticket_booking_system/Client_Screens/Startslide.dart';
import 'package:bus_ticket_booking_system/Client_Screens/SignUpScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/WelcomeScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/SeatReservationPage.dart';
import 'package:bus_ticket_booking_system/Client_Screens/SchedulePage.dart';
import 'package:bus_ticket_booking_system/Client_Screens/ResetPasswordScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/ProfileScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/PersonalInfoScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/PaymentMethodScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/OTPvalidation.dart';
import 'package:bus_ticket_booking_system/Client_Screens/LoginScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/HomeScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/ForgotPasswordScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/downloadslipcash.dart';
import 'package:bus_ticket_booking_system/Client_Screens/downloadslipcard.dart';
import 'package:bus_ticket_booking_system/Client_Screens/CardPaymentScreen.dart';
import 'package:bus_ticket_booking_system/Client_Screens/BusBookingScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange
      ),
      home: const WelcomeScreen(),
    );
  }
}