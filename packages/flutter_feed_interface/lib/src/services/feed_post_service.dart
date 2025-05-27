// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter/material.dart";
import "package:flutter_feed_interface/flutter_feed_interface.dart";

abstract class FeedPostService with ChangeNotifier {
  List<FeedPost> posts = [];
  List<FeedCategory> categories = [];
  FeedCategory? selectedCategory;

  Future<void> deletePost(FeedPost post);
  Future<FeedPost> createPost(FeedPost post);
  Future<List<FeedPost>> fetchPosts(String? category);
  Future<FeedPost> fetchPost(FeedPost post);
  Future<List<FeedPost>> fetchPostsPaginated(String? category, int limit);
  Future<FeedPost?> getPost(String postId);
  List<FeedPost> getPosts(String? category);
  Future<List<FeedPost>> refreshPosts(String? category);
  Future<FeedPost> fetchPostDetails(FeedPost post);
  Future<FeedPost> likePost(String userId, FeedPost post);
  Future<FeedPost> unlikePost(String userId, FeedPost post);

  Future<List<FeedCategory>> fetchCategories();
  Future<bool> addCategory(FeedCategory category);
}
