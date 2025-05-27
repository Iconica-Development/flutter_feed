// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter/material.dart";
import "package:flutter_feed_interface/flutter_feed_interface.dart";

@immutable
class FeedPostReaction {
  const FeedPostReaction({
    required this.id,
    required this.postId,
    required this.creatorId,
    required this.createdAt,
    this.reaction,
    this.imageUrl,
    this.creator,
    this.createdAtString,
    this.likedBy,
  });

  factory FeedPostReaction.fromJson(
    String id,
    String postId,
    Map<String, dynamic> json,
  ) =>
      FeedPostReaction(
        id: id,
        postId: postId,
        creatorId: json["creator_id"] as String,
        reaction: json["reaction"] as String?,
        imageUrl: json["image_url"] as String?,
        createdAt: DateTime.parse(json["created_at"] as String),
        createdAtString: json["created_at"] as String,
        likedBy: (json["liked_by"] as List<dynamic>?)?.cast<String>() ?? [],
      );

  /// The unique identifier of the reaction.
  final String id;

  /// The unique identifier of the post on which the reaction is.
  final String postId;

  /// The unique identifier of the creator of the reaction.
  final String creatorId;

  /// The creator of the post. If null it isn't loaded yet.
  final FeedPosterUserModel? creator;

  /// The reaction text if the creator sent one
  final String? reaction;

  /// The url of the image if the creator sent one
  final String? imageUrl;

  /// Reaction creation date.
  final DateTime createdAt;

  /// Reaction creation date as String with microseconds.
  final String? createdAtString;

  final List<String>? likedBy;

  FeedPostReaction copyWith({
    String? id,
    String? postId,
    String? creatorId,
    FeedPosterUserModel? creator,
    String? reaction,
    String? imageUrl,
    DateTime? createdAt,
    List<String>? likedBy,
  }) =>
      FeedPostReaction(
        id: id ?? this.id,
        postId: postId ?? this.postId,
        creatorId: creatorId ?? this.creatorId,
        creator: creator ?? this.creator,
        reaction: reaction ?? this.reaction,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt ?? this.createdAt,
        likedBy: likedBy ?? this.likedBy,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        id: {
          "creator_id": creatorId,
          "reaction": reaction,
          "image_url": imageUrl,
          "created_at": createdAt.toIso8601String(),
          "liked_by": likedBy,
        },
      };

  Map<String, dynamic> toJsonWithMicroseconds() => <String, dynamic>{
        id: {
          "creator_id": creatorId,
          "reaction": reaction,
          "image_url": imageUrl,
          "created_at": createdAtString,
          "liked_by": likedBy,
        },
      };
}
