import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class JsonDataService extends GetxService {
  /// Load and parse JSON data from assets
  Future<List<dynamic>> loadJsonData(String assetPath) async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData;
    } catch (e) {
      print('Error loading JSON data from $assetPath: $e');
      throw Exception('Failed to load data from $assetPath');
    }
  }

  /// Load items data
  Future<List<dynamic>> loadItems() async {
    return await loadJsonData('assets/data/items.json');
  }

  /// Load campaigns data
  Future<List<dynamic>> loadDiscountCampaigns() async {
    return await loadJsonData('assets/data/campaigns.json');
  }

  /// Load users data
  Future<List<dynamic>> loadUsers() async {
    return await loadJsonData('assets/data/users.json');
  }

  /// Load posts data
  Future<List<dynamic>> loadPosts() async {
    return await loadJsonData('assets/data/posts.json');
  }

  /// Simulate network delay for realistic experience
  Future<void> simulateNetworkDelay({int milliseconds = 1000}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  /// Get item by ID
  Future<Map<String, dynamic>?> getItemById(int id) async {
    final items = await loadItems();
    try {
      return items.firstWhere((item) => item['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Get user by ID
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final users = await loadUsers();
    try {
      return users.firstWhere((user) => user['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Get posts by user ID
  Future<List<dynamic>> getPostsByUserId(int userId) async {
    final posts = await loadPosts();
    return posts.where((post) => post['userId'] == userId).toList();
  }

  /// Get post by ID
  Future<Map<String, dynamic>?> getPostById(int id) async {
    final posts = await loadPosts();
    try {
      return posts.firstWhere((post) => post['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Search items by name or email
  Future<List<dynamic>> searchItems(String query) async {
    final items = await loadItems();
    if (query.isEmpty) return items;

    return items.where((item) {
      final name = item['name']?.toString().toLowerCase() ?? '';
      final description = item['description']?.toString().toLowerCase() ?? '';
      final category = item['category']?.toString().toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();

      return name.contains(searchQuery) ||
          description.contains(searchQuery) ||
          category.contains(searchQuery);
    }).toList();
  }

  /// Search users by name or email
  Future<List<dynamic>> searchUsers(String query) async {
    final users = await loadUsers();
    if (query.isEmpty) return users;

    return users.where((user) {
      final name = user['name']?.toString().toLowerCase() ?? '';
      final email = user['email']?.toString().toLowerCase() ?? '';
      final username = user['username']?.toString().toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();

      return name.contains(searchQuery) ||
          email.contains(searchQuery) ||
          username.contains(searchQuery);
    }).toList();
  }

  /// Search posts by title or body
  Future<List<dynamic>> searchPosts(String query) async {
    final posts = await loadPosts();
    if (query.isEmpty) return posts;

    return posts.where((post) {
      final title = post['title']?.toString().toLowerCase() ?? '';
      final body = post['body']?.toString().toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();

      return title.contains(searchQuery) || body.contains(searchQuery);
    }).toList();
  }
}
