import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/linkedin_job.dart';

class LinkedInService {
  static const String baseUrl = 'https://linkedin-jobs-search.p.rapidapi.com';
  static const String apiKey = '40ec84f96cmsh64512fc2d5ae7a9p186399jsncd19b1b07757';
  
  static Map<String, String> get headers => {
    'X-RapidAPI-Key': apiKey,
    'X-RapidAPI-Host': 'linkedin-jobs-search.p.rapidapi.com',
    'Content-Type': 'application/json',
  };

  static Future<List<LinkedInJob>> searchJobs({
    String keywords = 'software developer',
    String location = 'United States',
    int limit = 20,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/').replace(queryParameters: {
        'keywords': keywords,
        'location': location,
        'limit': limit.toString(),
      });

      final response = await http.get(uri, headers: headers);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> jobs = data['data'] ?? data ?? [];
        return jobs.map((job) => LinkedInJob.fromJson(job)).toList();
      } else {
        throw Exception('Failed to load jobs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}