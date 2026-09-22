import 'package:flutter/material.dart';
import 'package:wallverse/screens/home_screen.dart';

//& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" connect 172.20.10.13:5555
//& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" connect 10.66.214.103:5555

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
