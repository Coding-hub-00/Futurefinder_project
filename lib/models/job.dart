class Job {
  final String id;
  final String title;
  final String employer;
  final String location;
  final String? salary;
  final String description;
  final String? applyUrl;
  final String? postedDate;

  Job({
    required this.id,
    required this.title,
    required this.employer,
    required this.location,
    this.salary,
    required this.description,
    this.applyUrl,
    this.postedDate,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['job_id']?.toString() ?? '',
      title: json['job_title'] ?? 'No Title',
      employer: json['employer_name'] ?? 'Unknown Company',
      location: json['job_city'] ?? json['job_country'] ?? 'Remote',
      salary: json['job_salary_currency'] != null && json['job_min_salary'] != null
          ? '${json['job_salary_currency']} ${json['job_min_salary']}-${json['job_max_salary'] ?? json['job_min_salary']}'
          : null,
      description: json['job_description'] ?? 'No description available',
      applyUrl: json['job_apply_link'],
      postedDate: json['job_posted_at_datetime_utc'],
    );
  }
}