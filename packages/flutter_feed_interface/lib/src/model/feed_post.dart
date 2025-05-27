// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_feed_interface/flutter_feed_interface.dart";

/// A post of the feed.
@immutable
class FeedPost {
  const FeedPost({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.content,
    required this.likes,
    required this.createdAt,
    this.category,
    this.creator,
    this.likedBy,
    this.imageUrl,
    this.image,
    this.data = const {},
  });

  factory FeedPost.fromJson(String id, Map<String, dynamic> json) => FeedPost(
        id: id,
        creatorId: json["creator_id"] as String,
        title: json["title"] as String,
        category: json["category"] as String?,
        imageUrl: json["image_url"] as String?,
        content: json["content"] as String,
        likes: json["likes"] as int,
        likedBy: (json["liked_by"] as List<dynamic>?)?.cast<String>() ?? [],
        createdAt: DateTime.parse(json["created_at"] as String),
        data: json["data"] ?? {},
      );

  /// The unique identifier of the post.
  final String id;

  /// The unique identifier of the creator of the post.
  final String creatorId;

  /// The creator of the post. If null it isn't loaded yet.
  final FeedPosterUserModel? creator;

  /// The title of the post.
  final String title;

  /// The category of the post on which can be filtered.
  final String? category;

  /// The url of the image of the post.
  final String? imageUrl;

  /// The image of the post used for uploading.
  final Uint8List? image;

  /// The content of the post.
  final String content;

  /// The number of likes of the post.
  final int likes;

  /// The list of users who liked the post. If null it isn't loaded yet.
  final List<String>? likedBy;

  /// Post creation date.
  final DateTime createdAt;

  /// Option to add extra data to a feed post that won't be shown anywhere
  final Map<String, dynamic> data;

  FeedPost copyWith({
    String? id,
    String? creatorId,
    FeedPosterUserModel? creator,
    String? title,
    String? category,
    String? imageUrl,
    Uint8List? image,
    String? content,
    int? likes,
    List<String>? likedBy,
    DateTime? createdAt,
    Map<String, dynamic>? data,
  }) =>
      FeedPost(
        id: id ?? this.id,
        creatorId: creatorId ?? this.creatorId,
        creator: creator ?? this.creator,
        title: title ?? this.title,
        category: category ?? this.category,
        imageUrl: imageUrl ?? this.imageUrl,
        image: image ?? this.image,
        content: content ?? this.content,
        likes: likes ?? this.likes,
        likedBy: likedBy ?? this.likedBy,
        createdAt: createdAt ?? this.createdAt,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() => {
        "creator_id": creatorId,
        "title": title,
        "category": category,
        "image_url": imageUrl,
        "content": content,
        "likes": likes,
        "liked_by": likedBy,
        "created_at": createdAt.toIso8601String(),
        "data": data,
      };
}
