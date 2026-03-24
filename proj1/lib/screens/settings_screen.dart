import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

// Settings screen to toggle dark mode
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variable to track dark mode setting
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    loadSettings(); // Load settings when the screen initializes
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

// Function to toggle dark mode and save the setting
  Future<void> toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);

    setState(() {
      darkMode = value;
    });

    MyApp.of(context)?.toggleTheme(value);
  }
// Build method to display the settings UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SwitchListTile(
        title: const Text('Dark Mode'),
        value: darkMode,
        onChanged: toggleDarkMode,
      ),
    );
  }
}
