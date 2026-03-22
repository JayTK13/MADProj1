import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class SessionHistoryScreen extends StatefulWidget {
  const SessionHistoryScreen({super.key});

  @override
  State<SessionHistoryScreen> createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  List<Map<String, dynamic>> sessions = [];

  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadSessions();
  }

  Future<void> loadSessions() async {
    final data = await DatabaseHelper.instance.getSessions();
    setState(() {
      sessions = data;
    });
  }

  Future<void> deleteSession(int id) async {
    await DatabaseHelper.instance.deleteSession(id);
    loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session History')),
      body: sessions.isEmpty
          ? const Center(child: Text('No sessions recorded'))
          : ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return ListTile(
                  title: Text("${session['taskType']} - ${session['mood']}"),
                  subtitle: Text("Duration: ${session['duration']} min"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteSession(session['id']),
                  ),
                );
              },
            ),
    );
  }
}
