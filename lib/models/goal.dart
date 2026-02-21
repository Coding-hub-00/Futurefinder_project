class Goal {
  final int? id;
  final String title;
  final String description;
  final DateTime deadline;
  final bool completionStatus;

  Goal({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.completionStatus,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      completionStatus: json['completion_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'completion_status': completionStatus,
    };
  }
}