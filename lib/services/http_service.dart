import 'dart:convert';
import 'package:article_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static const String baseUrl = Constants.apiUrl;

  // GET request to fetch articles with optional filters & pagination
  static Future<Map<String, dynamic>> getArticles({
    Map<String, dynamic>? filters,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final Uri url = Uri.parse('$baseUrl/articles?page=$page&size=$size');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load articles: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching articles: $e");
    }
  }

  // GET request to fetch a single article by ID
  static Future<Map<String, dynamic>> getArticleById(String articleId) async {
    try {
      final Uri url = Uri.parse('$baseUrl/articles/$articleId');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch article: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching article: $e");
    }
  }

  // POST request to create a new article
  static Future<Map<String, dynamic>> createArticle(
    Map<String, dynamic> articleData,
  ) async {
    try {
      final Uri url = Uri.parse('$baseUrl/articles');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(articleData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to create article: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error creating article: $e");
    }
  }

  // PATCH request to update an article
  static Future<Map<String, dynamic>> updateArticle(
    String articleId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final Uri url = Uri.parse('$baseUrl/articles/$articleId');

      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updates),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to update article: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error updating article: $e");
    }
  }
}
