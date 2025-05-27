// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

mixin FeedUserStoryRoutes {
  static const String feedHome = "/feed";
  static const String feedView = "/feed-view/:post";
  static String feedViewPath(String postId) => "/feed-view/$postId";
  static String feedpostCreation(String category) =>
      "/feed-post-creation/$category";

  static const String feedPostCreation = "/feed-post-creation/:category";
  static String feedPostOverview = "/feed-post-overview";
  static String feedCategorySelection = "/feed-category-selection";
}
