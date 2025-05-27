// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter/material.dart";
import "package:flutter_feed_timeline/src/repositories/feed_services.dart";

/// Configuration class for defining user-specific settings and callbacks for a
/// feed user story.
///
/// This class holds various parameters to customize the behavior and appearance
/// of a feed user story.
class FeedTimelineUserStoryConfiguration {
  /// Constructs a [FeedTimelineUserStoryConfiguration] with the specified
  /// parameters.
  ///
  /// [timelineRepository] is the FeedPostService responsible for fetching user
  /// story data.
  ///
  /// [feedItemActionBuilder] is a function that builds actions on the item
  /// based on the given [BuildContext].
  const FeedTimelineUserStoryConfiguration({
    required this.timelineRepository,
    required this.timelineLikesRepository,
    this.feedItemActionBuilder,
  });

  final TimelineRepository timelineRepository;
  final TimelineLikesRepository timelineLikesRepository;

  final Widget Function(BuildContext context)? feedItemActionBuilder;
}
