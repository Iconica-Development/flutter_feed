// SPDX-FileCopyrightText: 2025 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter/material.dart";
import "package:flutter_timeline_interface/flutter_timeline_interface.dart";

/// Configuration class for defining user-specific settings and callbacks for a
/// feed user story.
///
/// This class holds various parameters to customize the behavior and appearance
/// of a feed user story.
class TimelineUserStoryConfiguration {
  /// Constructs a [TimelineUserStoryConfiguration] with the specified
  /// parameters.
  ///
  /// [timelineRepository] is the TimelineRepository responsible for fetching
  /// user story data.
  ///
  /// [timelineLikeRepository] is the TimelineLikesRepository responsible for
  /// fetching user story data.
  ///
  /// [theme] is the app theme used for styling various elements.
  const TimelineUserStoryConfiguration({
    required this.timelineRepository,
    required this.timelineLikesRepository,
    this.theme,
  });

  /// The datasource to retrieve posts from.
  final TimelineRepository timelineRepository;

  /// The datasource to retrieve likes for the posts from.
  final TimelineLikesRepository timelineLikesRepository;

  /// The app theme, used for styling various elements.
  final ThemeData? theme;
}
