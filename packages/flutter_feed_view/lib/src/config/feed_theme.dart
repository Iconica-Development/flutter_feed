// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter/material.dart";
import "package:flutter_feed_view/src/config/feed_styles.dart";

@immutable
class FeedTheme {
  const FeedTheme({
    this.iconColor,
    this.likeIcon,
    this.commentIcon,
    this.likedIcon,
    this.sendIcon,
    this.moreIcon,
    this.deleteIcon,
    this.categorySelectionButtonBorderColor,
    this.categorySelectionButtonBackgroundColor,
    this.categorySelectionButtonSelectedTextColor,
    this.categorySelectionButtonUnselectedTextColor,
    this.postCreationFloatingActionButtonColor,
    this.textStyles = const FeedTextStyles(),
  });

  final Color? iconColor;

  /// The icon to display when the post is not yet liked
  final Widget? likeIcon;

  /// The icon to display to indicate that a post has comments enabled
  final Widget? commentIcon;

  /// The icon to display when the post is liked
  final Widget? likedIcon;

  /// The icon to display to submit a comment
  final Widget? sendIcon;

  /// The icon for more actions (open delete menu)
  final Widget? moreIcon;

  /// The icon for delete action (delete post)
  final Widget? deleteIcon;

  /// The text style overrides for all the texts in the feed
  final FeedTextStyles textStyles;

  /// The color of the border around the category in the selection screen
  final Color? categorySelectionButtonBorderColor;

  /// The color of the background of the category selection button in the
  /// selection screen
  final Color? categorySelectionButtonBackgroundColor;

  /// The color of the text of the category selection button when it is selected
  final Color? categorySelectionButtonSelectedTextColor;

  /// The color of the text of the category selection button when
  /// it is not selected
  final Color? categorySelectionButtonUnselectedTextColor;

  /// The color of the floating action button on the overview screen
  final Color? postCreationFloatingActionButtonColor;
}
