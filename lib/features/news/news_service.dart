import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lms_core_frontend/features/auth/auth_service.dart';

class NewsItem {
  final int id;
  final String title;
  final String imageUrl;

  const NewsItem({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as int,
      title: (json['title'] ?? '') as String,
      imageUrl: (json['image_url'] ?? '') as String,
    );
  }
}

class NewsService {
  static const _baseUrl = 'https://lms-core-api-production.up.railway.app';

  final AuthService _authService = AuthService();

  Future<Map<String, String>> _authHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> parseAndSave() async {
    final uri = Uri.parse('$_baseUrl/news/parse/save');
    final response = await http.post(uri, headers: await _authHeaders());

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to parse and save news (${response.statusCode})');
    }
  }

  Future<List<NewsItem>> getNews() async {
    final uri = Uri.parse('$_baseUrl/news');
    final response = await http.get(uri, headers: await _authHeaders());

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      final list = decoded is List ? decoded : (decoded['data'] ?? decoded['items'] ?? []) as List;
      return list
          .cast<Map<String, dynamic>>()
          .map(NewsItem.fromJson)
          .toList();
    }

    throw Exception('Failed to fetch news (${response.statusCode})');
  }
}
