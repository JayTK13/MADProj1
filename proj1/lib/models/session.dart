class Session {
  final int? id;
  final String mood;
  final String taskType;
  final int duration;
  final String createdAt;

  Session({
    this.id,
    required this.mood,
    required this.taskType,
    required this.duration,
    required this.createdAt,
  });

  // Convert object to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'taskType': taskType,
      'duration': duration,
      'createdAt': createdAt,
    };
  }

  // Convert Map to object
  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      mood: map['mood'],
      taskType: map['taskType'],
      duration: map['duration'],
      createdAt: map['createdAt'],
    );
  }
}