class User {
  final int id;
  final String username;
  final String email;
  final List<String> interests;
  final List<String> skills;
  final String? profilePicture;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.interests,
    required this.skills,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      interests: List<String>.from(json['interests'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'interests': interests,
      'skills': skills,
      'profile_picture': profilePicture,
    };
  }
}