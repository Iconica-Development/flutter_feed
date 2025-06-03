import "package:flutter_timeline_interface/src/models/timeline_item.dart";

abstract interface class TimelineRepository {
  /// Fetch items from the datasource. It can accept a limit and offset for
  /// paginated retrieval.
  Future<List<TimelineItem>> getItems({int? limit, int offset = 0});

  /// Create a new item on the datasource.
  Future<TimelineItem> createItem(TimelineItem item);

  /// Delete an item from the datasource.
  Future<void> deleteItem(TimelineItem item);
}

// ignore: one_member_abstracts
abstract interface class TimelineLikesRepository {
  /// Add a like to an item on the datasource.
  Future<void> likeItem(TimelineItem item);
}
