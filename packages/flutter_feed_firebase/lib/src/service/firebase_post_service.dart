// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:cloud_firestore/cloud_firestore.dart";
import "package:collection/collection.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:flutter_feed_firebase/src/config/firebase_feed_options.dart";
import "package:flutter_feed_firebase/src/models/firebase_user_document.dart";
import "package:flutter_feed_interface/flutter_feed_interface.dart";
import "package:uuid/uuid.dart";

class FirebaseFeedPostService
    with FeedUserService, ChangeNotifier
    implements FeedPostService {
  FirebaseFeedPostService({
    required FeedUserService userService,
    FirebaseApp? app,
    FirebaseFeedOptions? options,
  }) {
    var appInstance = app ?? Firebase.app();
    _db = FirebaseFirestore.instanceFor(app: appInstance);
    _storage = FirebaseStorage.instanceFor(app: appInstance);
    _userService = userService;
    _options = options ?? const FirebaseFeedOptions();
  }

  late FirebaseFirestore _db;
  late FirebaseStorage _storage;
  late FeedUserService _userService;
  late FirebaseFeedOptions _options;

  final Map<String, FeedPosterUserModel> _users = {};

  @override
  List<FeedPost> posts = [];

  @override
  List<FeedCategory> categories = [];

  @override
  FeedCategory? selectedCategory;

  @override
  Future<FeedPost> createPost(FeedPost post) async {
    var postId = const Uuid().v4();
    var user = await _userService.getUser(post.creatorId);
    var updatedPost = post.copyWith(id: postId, creator: user);
    if (post.image != null) {
      var imageRef =
          _storage.ref().child("${_options.feedCollectionName}/$postId");
      var result = await imageRef.putData(post.image!);
      var imageUrl = await result.ref.getDownloadURL();
      updatedPost = updatedPost.copyWith(imageUrl: imageUrl);
    }
    var postRef =
        _db.collection(_options.feedCollectionName).doc(updatedPost.id);
    await postRef.set(updatedPost.toJson());
    posts.add(updatedPost);
    notifyListeners();
    return updatedPost;
  }

  @override
  Future<void> deletePost(FeedPost post) async {
    posts = posts.where((element) => element.id != post.id).toList();
    var postRef = _db.collection(_options.feedCollectionName).doc(post.id);
    await postRef.delete();
    notifyListeners();
  }

  @override
  Future<FeedPost> fetchPostDetails(FeedPost post) async {
    var updatedPost =
        post.copyWith(creator: await _userService.getUser(post.creatorId));
    posts = posts.map((p) => (p.id == post.id) ? updatedPost : p).toList();
    notifyListeners();
    return updatedPost;
  }

  @override
  Future<List<FeedPost>> fetchPosts(String? category) async {
    var snapshot = (category != null)
        ? await _db
            .collection(_options.feedCollectionName)
            .where("category", isEqualTo: category)
            .get()
        : await _db.collection(_options.feedCollectionName).get();

    var fetchedPosts = <FeedPost>[];
    for (var doc in snapshot.docs) {
      var data = doc.data();
      var user = await _userService.getUser(data["creator_id"]);
      var post = FeedPost.fromJson(doc.id, data).copyWith(creator: user);
      fetchedPosts.add(post);
    }

    posts = fetchedPosts;

    notifyListeners();
    return posts;
  }

  @override
  Future<List<FeedPost>> fetchPostsPaginated(
    String? category,
    int limit,
  ) async {
    // only take posts that are in our category
    var oldestPost = posts
        .where(
          (element) => category == null || element.category == category,
        )
        .fold(
          posts.first,
          (previousValue, element) =>
              (previousValue.createdAt.isBefore(element.createdAt))
                  ? previousValue
                  : element,
        );
    var snapshot = (category != null)
        ? await _db
            .collection(_options.feedCollectionName)
            .where("category", isEqualTo: category)
            .orderBy("created_at", descending: true)
            .startAfter([oldestPost])
            .limit(limit)
            .get()
        : await _db
            .collection(_options.feedCollectionName)
            .orderBy("created_at", descending: true)
            .startAfter([oldestPost.createdAt])
            .limit(limit)
            .get();
    // add the new posts to the list
    var newPosts = <FeedPost>[];
    for (var doc in snapshot.docs) {
      var data = doc.data();
      var user = await _userService.getUser(data["creator_id"]);
      var post = FeedPost.fromJson(doc.id, data).copyWith(creator: user);
      newPosts.add(post);
    }
    posts = [...posts, ...newPosts];
    notifyListeners();
    return newPosts;
  }

  @override
  Future<FeedPost> fetchPost(FeedPost post) async {
    var doc =
        await _db.collection(_options.feedCollectionName).doc(post.id).get();
    var data = doc.data();
    if (data == null) return post;
    var user = await _userService.getUser(data["creator_id"]);
    var updatedPost = FeedPost.fromJson(doc.id, data).copyWith(
      creator: user,
    );
    posts = posts.map((p) => (p.id == post.id) ? updatedPost : p).toList();
    notifyListeners();
    return updatedPost;
  }

  @override
  Future<List<FeedPost>> refreshPosts(String? category) async {
    // fetch all posts between now and the newest posts we have
    var newestPostWeHave = posts
        .where(
          (element) => category == null || element.category == category,
        )
        .fold(
          posts.first,
          (previousValue, element) =>
              (previousValue.createdAt.isAfter(element.createdAt))
                  ? previousValue
                  : element,
        );
    var snapshot = (category != null)
        ? await _db
            .collection(_options.feedCollectionName)
            .where("category", isEqualTo: category)
            .orderBy("created_at", descending: true)
            .endBefore([newestPostWeHave.createdAt]).get()
        : await _db
            .collection(_options.feedCollectionName)
            .orderBy("created_at", descending: true)
            .endBefore([newestPostWeHave.createdAt]).get();
    // add the new posts to the list
    var newPosts = <FeedPost>[];
    for (var doc in snapshot.docs) {
      var data = doc.data();
      var user = await _userService.getUser(data["creator_id"]);
      var post = FeedPost.fromJson(doc.id, data).copyWith(creator: user);
      newPosts.add(post);
    }
    posts = [...posts, ...newPosts];
    notifyListeners();
    return newPosts;
  }

  @override
  Future<FeedPost?> getPost(String postId) async {
    var post = await _db
        .collection(_options.feedCollectionName)
        .doc(postId)
        .withConverter<FeedPost>(
          fromFirestore: (snapshot, _) => FeedPost.fromJson(
            snapshot.id,
            snapshot.data()!,
          ),
          toFirestore: (user, _) => user.toJson(),
        )
        .get();
    return post.data();
  }

  @override
  List<FeedPost> getPosts(String? category) => posts
      .where((element) => category == null || element.category == category)
      .toList();

  @override
  Future<FeedPost> likePost(String userId, FeedPost post) async {
    // update the post with the new like
    var updatedPost = post.copyWith(
      likes: post.likes + 1,
      likedBy: [...post.likedBy ?? [], userId],
    );
    posts = posts
        .map(
          (p) => p.id == post.id ? updatedPost : p,
        )
        .toList();
    var postRef = _db.collection(_options.feedCollectionName).doc(post.id);
    await postRef.update({
      "likes": FieldValue.increment(1),
      "liked_by": FieldValue.arrayUnion([userId]),
    });
    notifyListeners();
    return updatedPost;
  }

  @override
  Future<FeedPost> unlikePost(String userId, FeedPost post) async {
    // update the post with the new like
    var updatedPost = post.copyWith(
      likes: post.likes - 1,
      likedBy: post.likedBy?..remove(userId),
    );
    posts = posts
        .map(
          (p) => p.id == post.id ? updatedPost : p,
        )
        .toList();
    var postRef = _db.collection(_options.feedCollectionName).doc(post.id);
    await postRef.update({
      "likes": FieldValue.increment(-1),
      "liked_by": FieldValue.arrayRemove([userId]),
    });
    notifyListeners();
    return updatedPost;
  }

  CollectionReference<FirebaseUserDocument> get _userCollection => _db
      .collection(_options.usersCollectionName)
      .withConverter<FirebaseUserDocument>(
        fromFirestore: (snapshot, _) => FirebaseUserDocument.fromJson(
          snapshot.data()!,
          snapshot.id,
        ),
        toFirestore: (user, _) => user.toJson(),
      );
  @override
  Future<FeedPosterUserModel?> getUser(String userId) async {
    if (_users.containsKey(userId)) {
      return _users[userId]!;
    }
    var data = (await _userCollection.doc(userId).get()).data();

    var user = data == null
        ? FeedPosterUserModel(userId: userId)
        : FeedPosterUserModel(
            userId: userId,
            firstName: data.firstName,
            lastName: data.lastName,
            imageUrl: data.imageUrl,
          );

    _users[userId] = user;

    return user;
  }

  @override
  Future<bool> addCategory(FeedCategory category) async {
    var exists = categories.firstWhereOrNull(
      (element) => element.title.toLowerCase() == category.title.toLowerCase(),
    );
    if (exists != null) return false;
    try {
      await _db
          .collection(_options.feedCategoryCollectionName)
          .add(category.toJson());
      categories.add(category);
      notifyListeners();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Future<List<FeedCategory>> fetchCategories() async {
    categories.clear();
    categories.add(
      const FeedCategory(
        key: null,
        title: "All",
      ),
    );
    var categoriesSnapshot = await _db
        .collection(_options.feedCategoryCollectionName)
        .withConverter(
          fromFirestore: (snapshot, _) =>
              FeedCategory.fromJson(snapshot.data()!),
          toFirestore: (model, _) => model.toJson(),
        )
        .get();
    categories.addAll(categoriesSnapshot.docs.map((e) => e.data()));

    notifyListeners();
    return categories;
  }
}
