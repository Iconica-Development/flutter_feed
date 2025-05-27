// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter/material.dart";
import "package:flutter_feed_interface/flutter_feed_interface.dart";
import "package:flutter_feed_view/flutter_feed_view.dart";

/// Configuration class for defining user-specific settings and callbacks for a
/// feed user story.
///
/// This class holds various parameters to customize the behavior and appearance
/// of a user story feed.
@immutable
class FeedUserStoryConfiguration {
  /// Constructs a [FeedUserStoryConfiguration] with the specified
  /// parameters.
  ///
  /// [service] is the FeedService responsible for fetching user story data.
  ///
  /// [optionsBuilder] is a function that builds FeedOptions based on the
  /// given [BuildContext].
  ///
  /// [userId] is the ID of the user associated with this user story
  /// configuration. Default is 'test_user'.
  ///
  /// [openPageBuilder] is a function that defines the behavior when a page
  /// needs to be opened. This function should accept a [BuildContext] and a
  /// child widget.
  ///
  /// [onPostTap] is a callback function invoked when a feed post is
  /// tapped. It should accept a [BuildContext] and the tapped post.
  ///
  /// [onUserTap] is a callback function invoked when the user's profile is
  /// tapped. It should accept a [BuildContext] and the user ID of the tapped
  /// user.
  ///
  /// [onPostDelete] is a callback function invoked when a post deletion is
  /// requested. It should accept a [BuildContext] and the post widget. This
  /// function can return a widget to be displayed after the post is deleted.
  ///
  /// [filterEnabled] determines whether filtering functionality is enabled for
  /// this user story feed. Default is false.
  ///
  /// [postWidgetBuilder] is a function that builds a widget for a feed
  /// post. It should accept a [FeedPost] and return a widget representing
  /// that post.
  const FeedUserStoryConfiguration({
    required this.service,
    required this.optionsBuilder,
    this.getUserId,
    this.serviceBuilder,
    this.canDeleteAllPosts,
    this.userId = "test_user",
    this.homeOpenPageBuilder,
    this.postCreationOpenPageBuilder,
    this.postViewOpenPageBuilder,
    this.postOverviewOpenPageBuilder,
    this.onPostTap,
    this.onUserTap,
    this.onRefresh,
    this.onPostDelete,
    this.filterEnabled = false,
    this.postWidgetBuilder,
    this.afterPostCreationGoHome = false,
    this.enablePostOverviewScreen = true,
    this.categorySelectionOpenPageBuilder,
    this.onPostCreate,
  });

  /// The ID of the user associated with this user story configuration.
  final String userId;

  /// A function to get the userId only when needed and with a context
  final String Function(BuildContext context)? getUserId;

  /// A function to determine if a user can delete posts that is called
  /// when needed
  final bool Function(BuildContext context)? canDeleteAllPosts;

  /// The FeedService responsible for fetching user story data.
  final FeedService service;

  /// A function to get the feed service only when needed and with a context
  final FeedPostService Function(BuildContext context)? serviceBuilder;

  /// A function that builds FeedOptions based on the given BuildContext.
  final FeedOptions Function(BuildContext context) optionsBuilder;

  /// Open page builder function for the home page. This function accepts
  /// a [BuildContext], a child widget, and a FloatingActionButton which can
  /// route to the post creation page.

  final Function(
    BuildContext context,
    Widget child,
    FloatingActionButton? button,
  )? homeOpenPageBuilder;

  /// Open page builder function for the post creation page. This function
  /// accepts a [BuildContext], a child widget, and an IconButton which can
  /// route to the home page.

  final Function(
    BuildContext context,
    Widget child,
    IconButton? button,
  )? postCreationOpenPageBuilder;

  /// Open page builder function for the post view page. This function accepts
  /// a [BuildContext], a child widget, and an IconButton which can route to the
  /// home page.

  final Function(
    BuildContext context,
    Widget child,
    IconButton? button,
    FeedPost post,
    FeedCategory? category,
  )? postViewOpenPageBuilder;

  /// Open page builder function for the post overview page. This function
  /// accepts a [BuildContext], a child widget, and an IconButton which can
  /// route to the home page.

  final Function(
    BuildContext context,
    Widget child,
  )? postOverviewOpenPageBuilder;

  /// A callback function invoked when a feed post is tapped.
  final Function(BuildContext context, FeedPost post)? onPostTap;

  /// A callback function invoked when the user's profile is tapped.
  final Function(BuildContext context, String userId)? onUserTap;

  /// A callback function invoked when the feed is refreshed by pulling down
  final Function(BuildContext context, String? category)? onRefresh;

  /// A callback function invoked when a post deletion is requested.
  final Widget Function(BuildContext context, FeedPost post)? onPostDelete;

  /// Determines whether filtering functionality is enabled for this user story
  /// feed.
  final bool filterEnabled;

  /// A function that builds a widget for a feed post.
  final Widget Function(FeedPost post)? postWidgetBuilder;

  /// Boolean to enable feed post overview screen before submitting
  final bool enablePostOverviewScreen;

  /// Boolean to enable redirect to home after post creation.
  /// If false, it will redirect to created post screen
  final bool afterPostCreationGoHome;

  /// Open page builder function for the category selection page. This function
  /// accepts a [BuildContext] and a child widget.
  final Function(
    BuildContext context,
    Widget child,
  )? categorySelectionOpenPageBuilder;

  final Function(FeedPost post)? onPostCreate;
}
