import 'package:flutter/material.dart';
import 'package:flutter_redux_example/screens/detailed_users/detailed_users_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const DetailedUsersScreen(),
    );
  }
}
