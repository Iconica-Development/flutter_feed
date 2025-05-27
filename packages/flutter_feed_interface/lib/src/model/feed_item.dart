// SPDX-FileCopyrightText: 2025 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter_feed_interface/src/model/feed_category.dart";

/// A single feed item
class FeedItem {
  const FeedItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.media = const [],
    this.categories = const [],
    this.creatorId,
    this.createdAt,
  });

  factory FeedItem.fromJson(String id, Map<String, dynamic> json) => FeedItem(
        id: id,
        title: json["title"] as String,
        subtitle: json["subtitle"] as String?,
        description: json["description"] as String?,
        creatorId: json["creator_id"] as String?,
        createdAt: json.containsKey("created_at")
            ? DateTime.parse(json["created_at"] as String)
            : null,
      );

  /// The unique identifier of the item.
  ///
  /// If this is null it means the item hasn't been saved yet and exists only in
  /// memory.
  final String? id;

  /// The title of the item.
  final String title;

  /// The subtitle of the item.
  final String? subtitle;

  /// A description of the item.
  final String? description;

  /// URLs to pictures and/or videos for this item.
  final List<Uri> media;

  /// Categories this item belongs too on which it can be filtered and ordered.
  final List<FeedCategory> categories;

  /// (Timeline specific) The unique identifier of the creator of the post.
  final String? creatorId;

  /// (Timeline specific) Item creation date.
  final DateTime? createdAt;

  FeedItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    List<Uri>? media,
    List<FeedCategory>? categories,
    String? creatorId,
    DateTime? createdAt,
  }) =>
      FeedItem(
        id: id ?? this.id,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        description: description ?? this.description,
        media: media ?? this.media,
        categories: categories ?? this.categories,
        creatorId: creatorId ?? this.creatorId,
        createdAt: createdAt ?? this.createdAt,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "description": description,
        "creator_id": creatorId,
        "created_at": createdAt?.toIso8601String(),
      };
}
