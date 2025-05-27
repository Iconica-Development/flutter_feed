// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter/material.dart";
import "package:flutter_feed_interface/flutter_feed_interface.dart";

class LocalFeedPostService with ChangeNotifier implements FeedPostService {
  @override
  List<FeedPost> posts = [];

  @override
  List<FeedCategory> categories = [];

  @override
  FeedCategory? selectedCategory;

  @override
  Future<FeedPost> createPost(FeedPost post) async {
    posts.add(
      post.copyWith(
        creator: const FeedPosterUserModel(
          userId: "test_user",
          imageUrl:
              "https://cdn.britannica.com/68/143568-050-5246474F/Donkey.jpg?w=400&h=300&c=crop",
          firstName: "Ico",
          lastName: "Nica",
        ),
      ),
    );
    notifyListeners();
    return post;
  }

  @override
  Future<void> deletePost(FeedPost post) async {
    posts = posts.where((element) => element.id != post.id).toList();

    notifyListeners();
  }

  @override
  Future<FeedPost> fetchPostDetails(FeedPost post) async {
    posts = posts.map((p) => (p.id == post.id) ? post : p).toList();
    notifyListeners();
    return post;
  }

  @override
  Future<List<FeedPost>> fetchPosts(String? category) async {
    if (posts.isEmpty) {
      posts = getMockedPosts();
    }
    notifyListeners();
    return posts;
  }

  @override
  Future<List<FeedPost>> fetchPostsPaginated(
    String? category,
    int limit,
  ) async {
    notifyListeners();
    return posts;
  }

  @override
  Future<FeedPost> fetchPost(FeedPost post) async {
    notifyListeners();
    return post;
  }

  @override
  Future<List<FeedPost>> refreshPosts(String? category) async {
    var newPosts = <FeedPost>[];

    posts = [...posts, ...newPosts];
    notifyListeners();
    return posts;
  }

  @override
  Future<FeedPost?> getPost(String postId) => Future.value(
        (posts.any((element) => element.id == postId))
            ? posts.firstWhere((element) => element.id == postId)
            : null,
      );

  @override
  List<FeedPost> getPosts(String? category) => posts
      .where((element) => category == null || element.category == category)
      .toList();

  @override
  Future<FeedPost> likePost(String userId, FeedPost post) async {
    var updatedPost = post.copyWith(
      likes: post.likes + 1,
      likedBy: (post.likedBy ?? [])..add(userId),
    );
    posts = posts
        .map(
          (p) => p.id == post.id ? updatedPost : p,
        )
        .toList();

    notifyListeners();
    return updatedPost;
  }

  @override
  Future<FeedPost> unlikePost(String userId, FeedPost post) async {
    var updatedPost = post.copyWith(
      likes: post.likes - 1,
      likedBy: post.likedBy?..remove(userId),
    );
    posts = posts
        .map(
          (p) => p.id == post.id ? updatedPost : p,
        )
        .toList();

    notifyListeners();
    return updatedPost;
  }

  List<FeedPost> getMockedPosts() => [
        FeedPost(
          id: "Post0",
          creatorId: "test_user",
          title: "De topper van de maand september",
          category: "Category",
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/appshell-demo.appspot.com/o/do_not_delete_1.png?alt=media&token=e4b2f9f3-c81f-4ac7-a938-e846691399f7",
          content: "Dit is onze topper van de maand september! Gefeliciteerd!",
          likes: 72,
          createdAt: DateTime.now(),
          creator: const FeedPosterUserModel(
            userId: "test_user",
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/appshell-demo.appspot.com/o/do_not_delete_3.png?alt=media&token=cd7c156d-0dda-43be-9199-f7d31c30132e",
            firstName: "Robin",
            lastName: "De Vries",
          ),
        ),
        FeedPost(
          id: "Post1",
          creatorId: "test_user2",
          title: "De soep van de week is: Aspergesoep",
          category: "Category with two lines",
          content:
              "Aspergesoep is echt een heerlijke delicatesse. Deze soep wordt"
              " vaak gemaakt met verse asperges, bouillon en wat kruiden voor"
              " smaak. Het is een perfecte keuze voor een lichte en smaakvolle"
              " maaltijd, vooral in het voorjaar wanneer asperges in seizoen"
              " zijn. We serveren het met een vleugje room en wat knapperige"
              " croutons voor die extra touch.",
          likes: 72,
          createdAt: DateTime.now(),
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/appshell-demo.appspot.com/o/do_not_delete_2.png?alt=media&token=ee4a8771-531f-4d1d-8613-a2366771e775",
          creator: const FeedPosterUserModel(
            userId: "test_user",
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/appshell-demo.appspot.com/o/do_not_delete_4.png?alt=media&token=775d4d10-6d2b-4aef-a51b-ba746b7b137f",
            firstName: "Elise",
            lastName: "Welling",
          ),
        ),
      ];

  @override
  Future<bool> addCategory(FeedCategory category) async {
    categories.add(category);
    notifyListeners();
    return true;
  }

  @override
  Future<List<FeedCategory>> fetchCategories() async {
    categories = [
      const FeedCategory(key: null, title: "All"),
      const FeedCategory(
        key: "Category",
        title: "Category",
      ),
      const FeedCategory(
        key: "Category with two lines",
        title: "Category with two lines",
      ),
    ];
    notifyListeners();

    return categories;
  }
}
