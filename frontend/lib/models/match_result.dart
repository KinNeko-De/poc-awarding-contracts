import 'contract.dart';
import 'profile.dart';

class MatchResponse {
  final Profile profile;
  final List<MatchResult> matches;

  const MatchResponse({required this.profile, required this.matches});

  factory MatchResponse.fromJson(Map<String, dynamic> json) {
    return MatchResponse(
      profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
      matches: (json['matches'] as List)
          .map((e) => MatchResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MatchResult {
  final Contract contract;
  final double score;
  final List<String> matchingSkills;

  const MatchResult({
    required this.contract,
    required this.score,
    required this.matchingSkills,
  });

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      contract: Contract.fromJson(json['contract'] as Map<String, dynamic>),
      score: (json['score'] as num).toDouble(),
      matchingSkills: List<String>.from(json['matching_skills'] as List),
    );
  }
}
