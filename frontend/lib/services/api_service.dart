import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/match_result.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost:8080';

  Future<MatchResponse> match(String profileText) async {
    final uri = Uri.parse('$_baseUrl/api/match');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'profile_text': profileText}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return MatchResponse.fromJson(json);
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: response.body.trim(),
    );
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
