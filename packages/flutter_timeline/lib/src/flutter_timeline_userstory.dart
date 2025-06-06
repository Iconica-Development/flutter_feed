import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_feed_utils/flutter_feed_utils.dart";
import "package:flutter_timeline/l10n/app_localizations.dart";
import "package:flutter_timeline/src/models/configuration.dart";
import "package:flutter_timeline/src/services/timeline_service.dart";
import "package:flutter_timeline/src/views/detail_view.dart";
import "package:flutter_timeline_interface/flutter_timeline_interface.dart";

class FlutterFeedTimelineUserstory extends StatefulWidget {
  const FlutterFeedTimelineUserstory({
    required this.service,
    required this.configuration,
    super.key,
  });

  final TimelineService service;
  final TimelineUserStoryConfiguration configuration;

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

    items = await widget.service.getItems();

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
    var localizations = FlutterFeedLocalizations.of(context)!;
    var navigator = Navigator.of(context);

    Future<void> likeItem(TimelineItem item) async {
      await widget.service.likeItem(item);
      unawaited(loadPosts());
    }

    Future<void> onItemPressed(TimelineItem item) async {
      await navigator.push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => DetailView(
            service: widget.service,
            configuration: widget.configuration,
            itemId: item.id,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: OverviewLayout.list(
        children: [
          for (var item in items) ...[
            FeedViewItem(
              title: item.title,
              authorName: item.authorName,
              authorAvatarUrl: item.authorAvatarUrl,
              imageUrl: item.media.isNotEmpty ? item.media.first : null,
              localizationDeleteItemButtonText:
                  localizations.timelinePostDeleteButtonText,
              localizationLikeCount:
                  localizations.timelinePostLikeCount(item.likeCount),
              localizationViewItemButtonText:
                  localizations.timelinePostViewButtonText,
              actionBuilder: () => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () async => likeItem(item),
                    icon: Icon(
                      item.likedByUser
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                    ),
                  ),
                ],
              ),
              onTap: () async => onItemPressed(item),
            ),
          ],
          if (items.isEmpty) ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(localizations.timelineEmptyLabel),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
