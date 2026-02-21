import 'package:flutter/material.dart';
import '../models/career.dart';
import '../models/job.dart';
import '../services/api_service.dart';
import '../services/jsearch_service.dart';

class CareerProvider with ChangeNotifier {
  List<Career> _recommendations = [];
  List<Job> _liveJobs = [];
  bool _isLoading = false;
  bool _isLoadingJobs = false;
  String? _quickRecommendation;

  List<Career> get recommendations => _recommendations;
  List<Job> get liveJobs => _liveJobs;
  bool get isLoading => _isLoading;
  bool get isLoadingJobs => _isLoadingJobs;
  String? get quickRecommendation => _quickRecommendation;

  Future<void> loadRecommendations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _recommendations = await ApiService.getRecommendations().timeout(Duration(seconds: 3));
    } catch (e) {
      // Mock data for testing
      _recommendations = [
        Career(
          id: 1,
          title: 'Software Engineer',
          description: 'Design, develop, and maintain software applications using various programming languages and frameworks.',
          requiredSkills: ['Python', 'JavaScript', 'React', 'Node.js', 'SQL'],
          resources: 'Practice coding on LeetCode, build projects on GitHub, contribute to open source.',
          salaryRange: '₹8-25 LPA (Entry to Senior Level)',
          jobOutlook: 'Excellent - 22% growth expected over next 10 years',
          educationPath: [
            'Bachelor\'s in Computer Science or related field',
            'Learn programming languages (Python, Java, JavaScript)',
            'Build portfolio projects',
            'Complete internships or bootcamps'
          ],
          careerSteps: [
            'Junior Developer (0-2 years)',
            'Software Engineer (2-5 years)',
            'Senior Software Engineer (5-8 years)',
            'Tech Lead/Architect (8+ years)'
          ],
          topCompanies: ['Google', 'Microsoft', 'Amazon', 'Flipkart', 'Zomato', 'Paytm'],
          matchPercentage: 92.0,
        ),
        Career(
          id: 2,
          title: 'Data Scientist',
          description: 'Analyze complex data to help organizations make informed business decisions using statistical methods and machine learning.',
          requiredSkills: ['Python', 'R', 'Machine Learning', 'Statistics', 'SQL', 'Tableau'],
          resources: 'Complete Kaggle competitions, learn from Coursera ML courses, practice with real datasets.',
          salaryRange: '₹10-30 LPA (Entry to Senior Level)',
          jobOutlook: 'Very Good - 31% growth expected over next 10 years',
          educationPath: [
            'Bachelor\'s in Mathematics, Statistics, or Computer Science',
            'Master\'s in Data Science (preferred)',
            'Learn Python/R and ML libraries',
            'Complete data science projects'
          ],
          careerSteps: [
            'Data Analyst (0-2 years)',
            'Junior Data Scientist (2-4 years)',
            'Data Scientist (4-7 years)',
            'Senior Data Scientist/ML Engineer (7+ years)'
          ],
          topCompanies: ['Netflix', 'Uber', 'Airbnb', 'Swiggy', 'Ola', 'PhonePe'],
          matchPercentage: 85.0,
        ),
        Career(
          id: 3,
          title: 'Digital Marketing Specialist',
          description: 'Create and execute digital marketing campaigns across various online platforms to promote products and services.',
          requiredSkills: ['SEO', 'Social Media Marketing', 'Google Ads', 'Content Creation', 'Analytics'],
          resources: 'Get Google Ads certification, learn SEO tools, create content portfolio, study successful campaigns.',
          salaryRange: '₹4-15 LPA (Entry to Senior Level)',
          jobOutlook: 'Good - 10% growth expected over next 10 years',
          educationPath: [
            'Bachelor\'s in Marketing, Communications, or Business',
            'Digital marketing certifications',
            'Learn marketing tools and platforms',
            'Build portfolio of campaigns'
          ],
          careerSteps: [
            'Marketing Assistant (0-2 years)',
            'Digital Marketing Executive (2-4 years)',
            'Digital Marketing Manager (4-7 years)',
            'Head of Digital Marketing (7+ years)'
          ],
          topCompanies: ['Byju\'s', 'Unacademy', 'Myntra', 'Nykaa', 'BigBasket', 'Grofers'],
          matchPercentage: 78.0,
        ),
        Career(
          id: 4,
          title: 'Business Analyst',
          description: 'Analyze business processes and requirements to help organizations improve efficiency and make data-driven decisions.',
          requiredSkills: ['Excel', 'SQL', 'Business Intelligence', 'Communication', 'Problem Solving'],
          resources: 'Learn business analysis frameworks, get certified in BA tools, practice case studies.',
          salaryRange: '₹6-20 LPA (Entry to Senior Level)',
          jobOutlook: 'Very Good - 14% growth expected over next 10 years',
          educationPath: [
            'Bachelor\'s in Business, Economics, or related field',
            'Learn business analysis tools',
            'Gain domain knowledge',
            'Complete business analysis projects'
          ],
          careerSteps: [
            'Junior Business Analyst (0-2 years)',
            'Business Analyst (2-5 years)',
            'Senior Business Analyst (5-8 years)',
            'Lead Business Analyst (8+ years)'
          ],
          topCompanies: ['Accenture', 'Deloitte', 'TCS', 'Infosys', 'Wipro', 'Capgemini'],
          matchPercentage: 75.0,
        ),
        Career(
          id: 5,
          title: 'UX/UI Designer',
          description: 'Design user interfaces and experiences for digital products, focusing on usability and visual appeal.',
          requiredSkills: ['Figma', 'Adobe Creative Suite', 'User Research', 'Prototyping', 'Design Thinking'],
          resources: 'Build design portfolio, learn design tools, study user psychology, practice design challenges.',
          salaryRange: '₹5-18 LPA (Entry to Senior Level)',
          jobOutlook: 'Excellent - 13% growth expected over next 10 years',
          educationPath: [
            'Bachelor\'s in Design, Arts, or related field',
            'Learn design tools and principles',
            'Build portfolio projects',
            'Complete design internships'
          ],
          careerSteps: [
            'Junior Designer (0-2 years)',
            'UX/UI Designer (2-5 years)',
            'Senior Designer (5-8 years)',
            'Design Lead/Manager (8+ years)'
          ],
          topCompanies: ['Google', 'Adobe', 'Figma', 'Zomato', 'Swiggy', 'Paytm'],
          matchPercentage: 70.0,
        ),
        Career(
          id: 6,
          title: 'Financial Analyst',
          description: 'Analyze financial data and market trends to help organizations make investment and business decisions.',
          requiredSkills: ['Excel', 'Financial Modeling', 'Accounting', 'Statistics', 'Communication'],
          resources: 'Learn financial modeling, get CFA certification, practice with real financial data.',
          salaryRange: '₹7-22 LPA (Entry to Senior Level)',
          jobOutlook: 'Good - 6% growth expected over next 10 years',
          educationPath: [
            'Bachelor\'s in Finance, Economics, or Business',
            'Learn financial analysis tools',
            'Gain industry knowledge',
            'Complete finance internships'
          ],
          careerSteps: [
            'Junior Financial Analyst (0-2 years)',
            'Financial Analyst (2-5 years)',
            'Senior Financial Analyst (5-8 years)',
            'Finance Manager (8+ years)'
          ],
          topCompanies: ['Goldman Sachs', 'JP Morgan', 'HDFC Bank', 'ICICI Bank', 'Kotak Mahindra', 'Axis Bank'],
          matchPercentage: 68.0,
        ),
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  void generateQuickRecommendation(String stream, String? field, List<String> skills, List<String> interests) {
    String baseRec = _getStreamBasedRecommendation(stream);
    String skillMatch = _getSkillBasedRecommendation(skills);
    String interestMatch = _getInterestBasedRecommendation(interests);
    
    _quickRecommendation = '$baseRec\n\n$skillMatch\n\n$interestMatch';
    
    // Update AI matching based on profile
    _updateAIMatching(stream, field, skills, interests);
    notifyListeners();
  }

  void _updateAIMatching(String stream, String? field, List<String> skills, List<String> interests) {
    // Calculate match scores for all careers
    List<Career> matchedCareers = [];
    
    for (var career in _recommendations) {
      double matchScore = _calculateMatchScore(career, stream, field, skills, interests);
      matchedCareers.add(Career(
        id: career.id,
        title: career.title,
        description: career.description,
        requiredSkills: career.requiredSkills,
        resources: career.resources,
        salaryRange: career.salaryRange,
        jobOutlook: career.jobOutlook,
        educationPath: career.educationPath,
        careerSteps: career.careerSteps,
        topCompanies: career.topCompanies,
        matchPercentage: matchScore,
      ));
    }
    
    // Sort by match percentage (all careers included)
    matchedCareers.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));
    _recommendations = matchedCareers;
  }

  double _calculateMatchScore(Career career, String stream, String? field, List<String> skills, List<String> interests) {
    double score = 45; // Base score to ensure minimum match
    
    // Stream matching (25 points)
    if (_isStreamMatch(career.title, stream)) {
      score += 25;
    } else if (_isRelatedStream(career.title, stream)) {
      score += 15;
    }
    
    // Skills matching (20 points)
    int skillMatches = career.requiredSkills.where((skill) => 
      skills.any((userSkill) => 
        userSkill.toLowerCase().contains(skill.toLowerCase()) ||
        skill.toLowerCase().contains(userSkill.toLowerCase())
      )
    ).length;
    if (career.requiredSkills.isNotEmpty) {
      score += (skillMatches / career.requiredSkills.length) * 20;
    }
    
    // Interest matching (10 points)
    int interestMatches = interests.where((interest) => 
      career.title.toLowerCase().contains(interest.toLowerCase()) ||
      career.description.toLowerCase().contains(interest.toLowerCase()) ||
      career.requiredSkills.any((skill) => skill.toLowerCase().contains(interest.toLowerCase()))
    ).length;
    if (interests.isNotEmpty) {
      score += (interestMatches / interests.length) * 10;
    }
    
    return score.clamp(45, 100);
  }
  
  bool _isRelatedStream(String careerTitle, String stream) {
    // Cross-stream matches for broader recommendations
    Map<String, List<String>> relatedFields = {
      'engineering': ['analyst', 'technical', 'data'],
      'business': ['technical', 'digital', 'analyst'],
      'science': ['engineer', 'technical', 'analyst'],
      'arts': ['digital', 'content', 'creative'],
      'commerce': ['digital', 'analyst', 'technical'],
      'medicine': ['technical', 'digital', 'research'],
    };
    
    List<String> related = relatedFields[stream.toLowerCase()] ?? [];
    return related.any((keyword) => careerTitle.toLowerCase().contains(keyword));
  }

  bool _isStreamMatch(String careerTitle, String stream) {
    Map<String, List<String>> streamKeywords = {
      'engineering': ['engineer', 'developer', 'software', 'technical', 'programming', 'data'],
      'business': ['business', 'analyst', 'manager', 'marketing', 'finance'],
      'commerce': ['business', 'finance', 'marketing', 'sales', 'analyst'],
      'science': ['scientist', 'research', 'data', 'analyst', 'technical'],
      'arts': ['design', 'creative', 'content', 'writer', 'artist', 'ux', 'ui'],
      'medicine': ['medical', 'health', 'clinical', 'therapy'],
    };
    
    List<String> keywords = streamKeywords[stream.toLowerCase()] ?? [];
    return keywords.any((keyword) => careerTitle.toLowerCase().contains(keyword));
  }

  String _getStreamBasedRecommendation(String stream) {
    switch (stream.toLowerCase()) {
      case 'engineering':
        return '🚀 Engineering Background: Software Engineer, Data Scientist, Product Manager, or DevOps Engineer roles are trending with high growth potential.';
      case 'medicine':
        return '🏥 Medical Background: Healthcare Technology, Medical Research, Biotech, or Digital Health roles combine medicine with innovation.';
      case 'commerce':
        return '💼 Commerce Background: Financial Analyst, Business Analyst, Digital Marketing, or FinTech roles offer excellent career prospects.';
      case 'business':
        return '📈 Business Background: Consultant, Project Manager, Business Development, or Startup roles leverage your leadership skills.';
      case 'arts':
        return '🎨 Arts Background: Content Strategy, UX Writing, Digital Marketing, or EdTech roles blend creativity with technology.';
      case 'science':
        return '🔬 Science Background: Data Scientist, Research Analyst, Technical Writer, or Science Communication roles combine analytical skills with innovation.';
      default:
        return '✨ Based on your background, explore roles that combine your academic knowledge with emerging technologies.';
    }
  }

  String _getSkillBasedRecommendation(List<String> skills) {
    if (skills.isEmpty) return '💡 Add your skills to get personalized recommendations!';
    
    List<String> techSkills = skills.where((s) => 
      ['Python', 'Java', 'JavaScript', 'React', 'Node.js', 'SQL', 'Machine Learning', 'Data Analysis'].contains(s)
    ).toList();
    
    if (techSkills.isNotEmpty) {
      return '💻 Tech Skills Detected: Your ${techSkills.join(", ")} skills are perfect for Software Development, Data Science, or AI/ML roles.';
    }
    
    return '🛠️ Skills Match: Your skills in ${skills.take(3).join(", ")} open doors to various specialized roles in your field.';
  }

  String _getInterestBasedRecommendation(List<String> interests) {
    if (interests.isEmpty) return '🎯 Add your interests to discover passion-aligned careers!';
    
    if (interests.any((i) => ['Technology', 'AI', 'Data Science'].contains(i))) {
      return '🤖 Tech Interests: Consider roles in AI/ML, Software Development, or Tech Consulting to pursue your passion for technology.';
    }
    
    if (interests.any((i) => ['Business', 'Entrepreneurship'].contains(i))) {
      return '🚀 Business Interests: Explore Startup roles, Business Development, or Consulting to channel your entrepreneurial spirit.';
    }
    
    return '🌟 Interest Alignment: Your interests in ${interests.take(2).join(" and ")} suggest careers in related industries for maximum satisfaction.';
  }

  Future<void> loadLiveJobs({String query = 'developer', String location = 'us'}) async {
    _isLoadingJobs = true;
    notifyListeners();

    try {
      final jobsData = await JSearchService.searchJobs(
        query: query,
        location: location,
      ).timeout(Duration(seconds: 5));
      _liveJobs = jobsData.map((json) => Job.fromJson(json)).toList();
    } catch (e) {
      print('Jobs loading failed (offline): $e');
      _liveJobs = [];
    }

    _isLoadingJobs = false;
    notifyListeners();
  }
}