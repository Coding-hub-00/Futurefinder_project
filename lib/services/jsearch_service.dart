import 'dart:convert';
import 'package:http/http.dart' as http;

class JSearchService {
  static const String baseUrl = 'https://jsearch.p.rapidapi.com';
  static const String apiKey = '40ec84f96cmsh64512fc2d5ae7a9p186399jsncd19b1b07757';
  
  static Map<String, String> get headers => {
    'x-rapidapi-key': apiKey,
    'x-rapidapi-host': 'jsearch.p.rapidapi.com',
  };

  static Future<List<Map<String, dynamic>>> searchJobs({
    String query = 'developer jobs',
    String location = 'us',
    int page = 1,
    String datePosted = 'all',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/search').replace(queryParameters: {
        'query': '$query in $location',
        'page': page.toString(),
        'num_pages': '1',
        'country': 'us',
        'date_posted': datePosted,
      });

      final response = await http.get(uri, headers: headers);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
      throw Exception('Failed to load jobs');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}