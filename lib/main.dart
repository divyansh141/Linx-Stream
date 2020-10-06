import 'package:Linx/cmdPage.dart';
import 'package:Linx/history.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(FirebaseConnect());
}

var fsconnect = FirebaseFirestore.instance;

class FirebaseConnect extends StatefulWidget {
  @override
  _FirebaseConnectState createState() => _FirebaseConnectState();
}

class _FirebaseConnectState extends State<FirebaseConnect> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => CommandPage(),
        '/history': (context) => History(),
      },
    );
  }
}
