import 'dart:async';
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

  Timer? _timer;
  int remainingSeconds = 0;
  bool isRunning = false;
  bool isPaused = false;

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

  void startTimer() {
    remainingSeconds = duration * 60;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingSeconds <= 0) {
        timer.cancel();
        await _audioPlayer.stop();

        setState(() {
          isRunning = false;
          isPaused = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session Complete')),
        );
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });

    setState(() {
      isRunning = true;
      isPaused = false;
    });
  }

  void pauseSession() async {
    _timer?.cancel();
    await _audioPlayer.pause();

    setState(() {
      isPaused = true;
      isRunning = false;
    });
  }

  void resumeSession() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingSeconds <= 0) {
        timer.cancel();
        await _audioPlayer.stop();

        setState(() {
          isRunning = false;
          isPaused = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session Complete')),
        );
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });

    _audioPlayer.resume();

    setState(() {
      isRunning = true;
      isPaused = false;
    });
  }

  void stopSession() async {
    _timer?.cancel();
    await _audioPlayer.stop();

    setState(() {
      isRunning = false;
      isPaused = false;
      remainingSeconds = 0;
    });
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
      startTimer();
      await loadRecommendation();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session Started')),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return "$minutes:${secs.toString().padLeft(2, '0')}";
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
                  color: Colors.blue,
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

              if (isRunning || isPaused)
                Text(
                  formatTime(remainingSeconds),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
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

              const SizedBox(height: 10),

              if (isRunning)
                ElevatedButton(
                  onPressed: pauseSession,
                  child: const Text('Pause'),
                ),

              if (isPaused)
                ElevatedButton(
                  onPressed: resumeSession,
                  child: const Text('Resume'),
                ),

              if (isRunning || isPaused)
                ElevatedButton(
                  onPressed: stopSession,
                  child: const Text('Stop'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}