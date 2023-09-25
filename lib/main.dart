import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Teen patti master',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

        //Text Themes
        textTheme: TextTheme(
          //Body Small
          bodyMedium: GoogleFonts.lato(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      home: const Splash(),
    );
  }
}
