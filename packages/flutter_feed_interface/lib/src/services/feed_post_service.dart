// SPDX-FileCopyrightText: 2025 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter_feed_interface/flutter_feed_interface.dart";

abstract class FeedPostService {
  /// Get available categories.
  ///
  /// If limit is not given the returned list will contain all available
  /// categories. Depending on the datasource this can be expensive so make sure
  /// you set it to a reasonable number.
  Future<List<FeedCategory>> getCategories({int? limit, int offset = 0});

  /// Create a new category.
  ///
  /// The returned category will be the same as the given but with the unique
  /// identifier set.
  Future<FeedCategory> createCategory(FeedCategory category);

  /// Delete a category.
  Future<void> deleteCategory(FeedCategory category);

  /// Get available items.
  ///
  /// If limit is not given the returned list will contain all available items.
  /// Depending on the datasource this can be expensive so make sure you set it
  /// to a reasonable number.
  Future<List<FeedItem>> getItems(
      {int? limit, int offset = 0, List<FeedCategory> categories,});

  /// Create a new item.
  ///
  /// The returned item will be the same as the given but with the unique
  /// identifier set.
  Future<FeedItem> createItem(FeedItem item);

  /// Delete an item.
  Future<void> deleteItem(FeedItem item);
}
