import 'dart:io';
import 'package:flutter/material.dart';
import 'package:AIPA/screens/splash_screen.dart';
// Corrected import path

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
      theme: _buildLightTheme(), //  Use a light theme
      darkTheme: _buildDarkTheme(), // Keep the dark theme
      themeMode: ThemeMode.system, // Set default theme mode to light
      home: const SplashScreen(),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF9C27B0), //  purple
        primary: const Color(0xFF9C27B0), //  primary purple
        secondary: const Color(0xFFE91E63), //  secondary pink
        background: Colors.white, //  light background
        surface: Colors.white, //  white surface
        onPrimary: Colors.white, // White text on primary
        onSecondary: Colors.white, // White text on secondary
        onBackground: Colors.black, // Black text on background
        onSurface: Colors.black, // Black text on surface
      ),
      scaffoldBackgroundColor: Colors.white, //  light background
      appBarTheme: const AppBarTheme(
        elevation: 0, // No shadow for clean look
        centerTitle: true,
        backgroundColor: Colors.white, //  light appbar
        iconTheme: IconThemeData(color: Colors.black), // Black icons
        titleTextStyle: TextStyle(
          color: Colors.black, // Black title
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.black, // Black title
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black), // Black body
        bodyMedium: TextStyle(fontSize: 14, color: Colors.grey), // Grey medium body
      ),
      cardTheme: CardTheme(
        elevation: 1,
        color: Colors.white, // White cards
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF3E5F5), // Light purple input background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none, // No border
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9C27B0), // Purple button
          foregroundColor: Colors.white, // White text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF9C27B0), // Purple text button
        ),
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Colors.white, // White dialog
        titleTextStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18), // Black title
        contentTextStyle: TextStyle(color: Colors.grey), // Grey content
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white, // White bottom sheet
        modalBackgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: Colors.black, // Black text
        iconColor: Colors.black, // Black icons
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0), // Light grey divider
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF9C27B0), // Purple
        primary: const Color(0xFF9C27B0),
        secondary: const Color(0xFFE91E63),
        background: const Color(0xFF121212),
        surface: const Color(0xFF2C2C2E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
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
          color: Colors.white,
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
        fillColor: const Color(0xFF3A3A3C),
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
          backgroundColor: const Color(0xFF9C27B0), // Purple
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
          foregroundColor: const Color(0xFF9C27B0), // Purple
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

