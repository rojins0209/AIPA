import 'dart:io';
import 'package:flutter/material.dart';
import 'package:AIPA/screens/splash_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smartphone Finder',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF9C27B0),
        primary: const Color(0xFF9C27B0),
        secondary: const Color(0xFFE91E63),
        background: Colors.white,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.black,
        onSurface: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white, // Light mode: white background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9C27B0),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF9C27B0),
        ),
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
        contentTextStyle: TextStyle(color: Colors.grey),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        modalBackgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: Colors.black,
        iconColor: Colors.black,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF9C27B0),
        primary: const Color(0xFF9C27B0),
        secondary: const Color(0xFFE91E63),
        background: const Color(0xFF121212),
        surface: const Color(0xFF303030),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFF1D1D1F),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.grey),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        color: const Color(0xFF2C2C2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2a2a2a), // Dark mode: dark grey background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9C27B0),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF9C27B0),
        ),
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Color(0xFF2C2C2E),
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        contentTextStyle: TextStyle(color: Colors.grey),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF2C2C2E),
        modalBackgroundColor: Color(0xFF2C2C2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: Colors.white,
        iconColor: Colors.white,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3A3A3C),
      ),
    );
  }
}