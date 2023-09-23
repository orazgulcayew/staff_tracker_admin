import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:staff_tracker_admin/firebase_options.dart';
import 'package:staff_tracker_admin/pages/home_page.dart';
import 'package:staff_tracker_admin/pages/login_page.dart';

late FirebaseFirestore firestore;
late FirebaseAuth auth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  auth = FirebaseAuth.instance;
  firestore = FirebaseFirestore.instance;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Staff Tracker Admin',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: auth.currentUser != null ? const HomePage() : const LoginPage(),
    );
  }
}
