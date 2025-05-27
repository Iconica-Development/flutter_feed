// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter_feed_interface/flutter_feed_interface.dart";

mixin FeedFilterService on FeedPostService {
  List<FeedPost> filterPosts(
    String filterWord,
    Map<String, dynamic> options,
  ) {
    var filteredPosts = posts
        .where(
          (post) => post.title.toLowerCase().contains(
                filterWord.toLowerCase(),
              ),
        )
        .toList();

    return filteredPosts;
  }
}
