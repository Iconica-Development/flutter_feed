import "package:flutter/material.dart";
import "package:flutter_feed_interface/flutter_feed_interface.dart";
import "package:flutter_feed_view/src/config/feed_options.dart";
import "package:flutter_feed_view/src/screens/feed_post_screen.dart";
import "package:flutter_feed_view/src/widgets/default_filled_button.dart";

class FeedPostOverviewScreen extends StatelessWidget {
  const FeedPostOverviewScreen({
    required this.feedPost,
    required this.options,
    required this.service,
    required this.onPostSubmit,
    super.key,
  });
  final FeedPost feedPost;
  final FeedOptions options;
  final FeedService service;
  final void Function(FeedPost) onPostSubmit;

  @override
  Widget build(BuildContext context) {
    var isSubmitted = false;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: FeedPostScreen(
            userId: feedPost.creatorId,
            options: options,
            post: feedPost,
            onPostDelete: () async {},
            service: service,
            isOverviewScreen: true,
          ),
        ),
        options.postOverviewButtonBuilder?.call(
              context,
              () {
                if (isSubmitted) return;
                isSubmitted = true;
                onPostSubmit(feedPost);
              },
              options.translations.postIn,
              feedPost,
            ) ??
            options.buttonBuilder?.call(
              context,
              () {
                if (isSubmitted) return;
                isSubmitted = true;
                onPostSubmit(feedPost);
              },
              options.translations.postIn,
              enabled: true,
            ) ??
            SafeArea(
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Row(
                  children: [
                    Expanded(
                      child: DefaultFilledButton(
                        onPressed: () async {
                          if (isSubmitted) return;
                          isSubmitted = true;
                          onPostSubmit(feedPost);
                        },
                        buttonText: options.translations.postIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
