import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_navigation.dart';

// Main entry point of the app, sets up theme and navigation
void main() {
  runApp(const MyApp());
}

// Main application widget that manages theme and navigation
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // State variable to track if dark mode is enabled
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    loadTheme(); // Load the saved theme preference when the app starts
  }

  // Load the saved theme preference from shared preferences
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  // Toggle the theme and save the preference
  Future<void> toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);

    setState(() {
      isDarkMode = value;
    });
  }

  // Build method to set up the MaterialApp with theme and navigation
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive Focus App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MainNavigation(),
    );
  }
}
