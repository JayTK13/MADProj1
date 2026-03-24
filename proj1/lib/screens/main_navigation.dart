import 'package:flutter/material.dart';
import 'start_session_screen.dart';
import 'session_history_screen.dart';

// Main navigation widget that manages the bottom navigation bar and screen switching
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // State variable to track the currently selected index of the bottom navigation bar
  int _selectedIndex = 0;

  // List of screens corresponding to each tab in the bottom navigation bar
  List<Widget> get _screens => [StartSessionScreen(), SessionHistoryScreen()];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Build method to display the current screen and the bottom navigation bar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the currently selected screen based on the index
      body: _screens[_selectedIndex],
      // Bottom navigation bar with two items: Start and History
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: 'Start'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
