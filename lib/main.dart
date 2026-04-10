import 'package:flutter/material.dart';
import 'package:receipt_ticket/page/reprintList.dart';
import 'fonts/appFonts.dart';
import 'page/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receipt Ticket',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: AppFonts.pgVim,
      ),
      routes: {
        '/reprint': (context) => const Reprintlist(),
      },
      home: const Home(),
    );
  }
}