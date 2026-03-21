import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class StartSessionScreen extends StatefulWidget {
  const StartSessionScreen({super.key});

  @override
  State<StartSessionScreen> createState() => _StartSessionScreenState();
}

class _StartSessionScreenState extends State<StartSessionScreen> {
  final _formKey = GlobalKey<FormState>();

  String mood = 'Calm';
  String taskType = 'Studying';
  int duration = 25;

  Future<void> saveSession() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper.instance.insertSession({
        'mood': mood,
        'taskType': taskType,
        'duration': duration,
        'createdAt': DateTime.now().toString(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Session Saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start Session')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                value: mood,
                items: ['Calm', 'Focus', 'Energy']
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    mood = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Mood'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: taskType,
                items: ['Studying', 'Coding', 'Reading']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    taskType = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Task Type'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: duration.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter duration';
                  }
                  return null;
                },
                onChanged: (value) {
                  duration = int.tryParse(value) ?? 25;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveSession,
                child: const Text('Start Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
