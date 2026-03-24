import 'package:flutter/material.dart';
import '../database/database_helper.dart';

// Screen to display the history of sessions with options to delete individual entries
class SessionHistoryScreen extends StatefulWidget {
  const SessionHistoryScreen({super.key});

  // Create state for the session history screen
  @override
  State<SessionHistoryScreen> createState() => _SessionHistoryScreenState();
}

// State class for the session history screen that manages loading and displaying session data
class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  List<Map<String, dynamic>> sessions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  // Function to load sessions from the database and update the state
  Future<void> loadSessions() async {
    try {
      final data = await DatabaseHelper.instance.getSessions();
      setState(() {
        sessions = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error loading sessions')));
    }
  }

  // Function to delete a session with confirmation dialog
  Future<void> deleteSession(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        // Show a confirmation dialog before deleting a session
        return AlertDialog(
          title: const Text("Delete Session"),
          content: const Text("Are you sure you want to delete this session?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteSession(id);
      loadSessions();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Session deleted')));
    }
  }

  // Build method to display the session history with loading indicator and delete options
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session History')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sessions.isEmpty
          ? const Center(child: Text('No sessions recorded'))
          : ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text("${session['taskType']} - ${session['mood']}"),
                    subtitle: Text("Duration: ${session['duration']} min"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteSession(session['id'] as int),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
