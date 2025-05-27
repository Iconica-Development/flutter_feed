import "package:flutter_feed_timeline/src/models/timeline_item.dart";

abstract class TimelineRepository {
  Future<List<TimelineItem>> getItems({int? limit, int offset = 0});
  Future<TimelineItem> createItem(TimelineItem item);
  Future<void> deleteItem(TimelineItem item);
}

// ignore: one_member_abstracts
abstract class TimelineLikesRepository {
  Future<void> likeItem(TimelineItem item);
}
