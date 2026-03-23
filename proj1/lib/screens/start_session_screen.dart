import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../database/database_helper.dart';
import 'settings_screen.dart';

class StartSessionScreen extends StatefulWidget {
  const StartSessionScreen({super.key});

  @override
  State<StartSessionScreen> createState() => _StartSessionScreenState();
}

class _StartSessionScreenState extends State<StartSessionScreen> {
  final _formKey = GlobalKey<FormState>();

  String mood = 'Calm';
  String taskType = 'Studying';
  int duration = 30;

  Map<String, dynamic>? recommendation;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    loadRecommendation();
  }

  Future<void> loadRecommendation() async {
    final data = await DatabaseHelper.instance.getRecommendation();
    setState(() {
      recommendation = data;
    });
  }

  Future<void> playMoodSound() async {
    String fileName;

    switch (mood) {
      case 'Calm':
        fileName = 'calm.mp3';
        break;
      case 'Focus':
        fileName = 'focus.mp3';
        break;
      case 'Energy':
        fileName = 'energy.mp3';
        break;
      default:
        fileName = 'calm.mp3';
    }

    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource('sounds/$fileName'));
  }

  Future<void> saveSession() async {
    if (_formKey.currentState!.validate()) {
      await DatabaseHelper.instance.insertSession({
        'mood': mood,
        'taskType': taskType,
        'duration': duration,
        'createdAt': DateTime.now().toString(),
      });

      await playMoodSound();

      await loadRecommendation();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Session Started')));
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Session'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (recommendation != null)
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Text(
                          "AI Suggestion",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Try: ${recommendation!['taskType']} with ${recommendation!['mood']} mood",
                        ),
                        Text(
                          recommendation!['reason'],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 10),
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
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  duration = int.tryParse(value) ?? 30;
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
