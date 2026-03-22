class Contract {
  final String id;
  final String title;
  final String description;
  final String authority;
  final String location;
  final bool remotePossible;
  final List<String> requiredSkills;
  final String deadline;
  final String estimatedValue;
  final String duration;

  const Contract({
    required this.id,
    required this.title,
    required this.description,
    required this.authority,
    required this.location,
    required this.remotePossible,
    required this.requiredSkills,
    required this.deadline,
    required this.estimatedValue,
    required this.duration,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      authority: json['authority'] as String,
      location: json['location'] as String,
      remotePossible: json['remote_possible'] as bool,
      requiredSkills: List<String>.from(json['required_skills'] as List),
      deadline: json['deadline'] as String,
      estimatedValue: json['estimated_value'] as String,
      duration: json['duration'] as String,
    );
  }
}
