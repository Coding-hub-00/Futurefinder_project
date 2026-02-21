class Career {
  final int id;
  final String title;
  final String description;
  final List<String> requiredSkills;
  final String resources;
  final String salaryRange;
  final String jobOutlook;
  final List<String> educationPath;
  final List<String> careerSteps;
  final List<String> topCompanies;
  final double matchPercentage;

  Career({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredSkills,
    required this.resources,
    this.salaryRange = '',
    this.jobOutlook = '',
    this.educationPath = const [],
    this.careerSteps = const [],
    this.topCompanies = const [],
    this.matchPercentage = 0.0,
  });

  factory Career.fromJson(Map<String, dynamic> json) {
    return Career(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      requiredSkills: List<String>.from(json['required_skills'] ?? []),
      resources: json['resources'] ?? '',
      salaryRange: json['salary_range'] ?? '',
      jobOutlook: json['job_outlook'] ?? '',
      educationPath: List<String>.from(json['education_path'] ?? []),
      careerSteps: List<String>.from(json['career_steps'] ?? []),
      topCompanies: List<String>.from(json['top_companies'] ?? []),
      matchPercentage: (json['match_percentage'] ?? 0.0).toDouble(),
    );
  }
}