import "package:flutter_feed_interface/flutter_feed_interface.dart";

class FeedService {
  FeedService({
    required this.postService,
    this.userService,
  });

  final FeedPostService postService;
  final FeedUserService? userService;
}
