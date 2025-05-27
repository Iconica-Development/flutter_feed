import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_feed_timeline/src/models/feed_configuration.dart";
import "package:flutter_feed_timeline/src/models/timeline_item.dart";
import "package:flutter_feed_utils/flutter_feed_utils.dart";

class FlutterFeedTimelineUserstory extends StatefulWidget {
  const FlutterFeedTimelineUserstory({
    required this.configuration,
    super.key,
  });

  final FeedTimelineUserStoryConfiguration configuration;

  @override
  State<FlutterFeedTimelineUserstory> createState() =>
      _FlutterFeedTimelineUserstoryState();
}

class _FlutterFeedTimelineUserstoryState
    extends State<FlutterFeedTimelineUserstory> {
  List<TimelineItem> items = const [];
  bool isLoading = false;

  Future<void> loadPosts() async {
    isLoading = true;
    setState(() {});

    items = await widget.configuration.timelineRepository.getItems();

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    unawaited(loadPosts());
  }

  @override
  Widget build(BuildContext context) {
    var likesRepository = widget.configuration.timelineLikesRepository;

    Future<void> likeItem(TimelineItem item) async {
      await likesRepository.likeItem(item);
      unawaited(loadPosts());
    }

    return Theme(
      data: ThemeData(
        textTheme: const TextTheme(
          bodySmall: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 14,
          ),
          titleSmall: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var item in items) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: FeedViewItem(
                  title: item.title,
                  authorName: item.authorName,
                  content: item.title,
                  imageUrl: item.media.isNotEmpty ? item.media.first : null,
                  likeCount: item.likeCount,
                  actionBuilder: () => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () async => likeItem(item),
                        icon: const Icon(Icons.heart_broken_outlined),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
              ),
            ],
            if (items.isEmpty) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("No posts"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
