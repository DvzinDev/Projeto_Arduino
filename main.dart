// main.dart
import 'package:flutter/material.dart';
import 'biolab_home.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() => runApp(const BioLabApp());

class BioLabApp extends StatelessWidget {
  const BioLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'BioLab Monitor',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0f172a),
        primaryColor: Colors.blueAccent,
      ),
      home: const BioLabHomePage(),
    );
  }
}
