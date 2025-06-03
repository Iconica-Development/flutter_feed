// SPDX-FileCopyrightText: 2025 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter/material.dart";

/// Configuration class for defining user-specific settings and callbacks for a
/// feed user story.
///
/// This class holds various parameters to customize the behavior and appearance
/// of a feed user story.
class TimelineUserStoryConfiguration {
  /// Constructs a [TimelineUserStoryConfiguration] with the specified
  /// parameters.
  ///
  /// [theme] is the app theme used for styling various elements.
  const TimelineUserStoryConfiguration({
    this.theme,
  });

  /// The app theme, used for styling various elements.
  final ThemeData? theme;
}
