
class Reminder {
  final int? id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final bool isCompleted;

  Reminder({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  Reminder copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    String? location,
    bool? isCompleted,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }


  static Reminder fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date:DateTime.parse(map['date']),
      location: map['location'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}