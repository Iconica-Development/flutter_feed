import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_feed_utils/flutter_feed_utils.dart";
import "package:flutter_timeline/l10n/app_localizations.dart";
import "package:flutter_timeline/src/models/configuration.dart";
import "package:flutter_timeline/src/services/timeline_service.dart";
import "package:flutter_timeline_interface/flutter_timeline_interface.dart";

class DetailView extends StatefulWidget {
  const DetailView({
    required this.service,
    required this.configuration,
    required this.itemId,
    super.key,
  });

  final TimelineService service;
  final TimelineUserStoryConfiguration configuration;

  final String itemId;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  TimelineItem? item;

  Future<void> loadPost() async {
    var items = await widget.service.getItems();
    var itemIndex = items.indexWhere((element) => element.id == widget.itemId);
    assert(
      itemIndex != -1,
      "This view has been given an item that doesn't exist",
    );

    item = items[itemIndex];
    setState(() {});
  }

  Future<void> likeItem(TimelineItem item) async {
    await widget.service.likeItem(item);
    unawaited(loadPost());
  }

  @override
  void initState() {
    super.initState();

    unawaited(loadPost());
  }

  @override
  Widget build(BuildContext context) {
    var localizations = FlutterFeedLocalizations.of(context)!;

    if (item == null) {
      return const CircularProgressIndicator();
    }

    var loadedItem = item!;

    String? localizedDate;
    if (loadedItem.createdAt != null) {
      localizedDate = localizations.timelinePostDetailDate(
        loadedItem.createdAt!,
        loadedItem.createdAt!,
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: FeedViewItem(
            title: loadedItem.title,
            content: loadedItem.description,
            authorName: loadedItem.authorName,
            authorAvatarUrl: loadedItem.authorAvatarUrl,
            imageUrl:
                loadedItem.media.isNotEmpty ? loadedItem.media.first : null,
            localizationAuthorDate: localizedDate,
            localizationDeleteItemButtonText:
                localizations.timelinePostDeleteButtonText,
            localizationLikeCount:
                localizations.timelinePostLikeCount(loadedItem.likeCount),
            localizationViewItemButtonText:
                localizations.timelinePostViewButtonText,
            actionBuilder: () => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () async => likeItem(loadedItem),
                  icon: Icon(
                    loadedItem.likedByUser
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
