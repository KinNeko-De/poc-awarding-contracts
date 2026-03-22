class Profile {
  final List<String> extractedSkills;

  const Profile({required this.extractedSkills});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      extractedSkills: List<String>.from(json['extracted_skills'] as List),
    );
  }
}
