import 'package:flutter/material.dart';

import 'screens/profile_screen.dart';

void main() {
  runApp(const ContractMatcherApp());
}

class ContractMatcherApp extends StatelessWidget {
  const ContractMatcherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contract Matcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF005F9E)),
        useMaterial3: true,
      ),
      home: const ProfileScreen(),
    );
  }
}
