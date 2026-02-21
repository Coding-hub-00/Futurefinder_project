class LinkedInJob {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final String? applyUrl;
  final String? postedDate;

  LinkedInJob({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    this.applyUrl,
    this.postedDate,
  });

  factory LinkedInJob.fromJson(Map<String, dynamic> json) {
    return LinkedInJob(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'No Title',
      company: json['company'] ?? 'Unknown Company',
      location: json['location'] ?? 'Remote',
      description: json['description'] ?? 'No description available',
      applyUrl: json['url'],
      postedDate: json['posted_date'],
    );
  }
}