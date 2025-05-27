// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class FirebaseFeedOptions {
  const FirebaseFeedOptions({
    this.usersCollectionName = "users",
    this.feedCollectionName = "feed",
    this.feedCategoryCollectionName = "feed_categories",
  });

  final String usersCollectionName;
  final String feedCollectionName;
  final String feedCategoryCollectionName;
}
