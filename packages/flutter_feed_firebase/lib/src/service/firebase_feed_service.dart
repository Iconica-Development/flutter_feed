import "package:firebase_core/firebase_core.dart";
import "package:flutter_feed_firebase/src/config/firebase_feed_options.dart";
import "package:flutter_feed_firebase/src/service/firebase_post_service.dart";
import "package:flutter_feed_firebase/src/service/firebase_user_service.dart";
import "package:flutter_feed_interface/flutter_feed_interface.dart";

class FirebaseFeedService implements FeedService {
  FirebaseFeedService({
    this.options,
    this.app,
    this.firebasePostService,
    this.firebaseUserService,
  }) {
    firebaseUserService ??= FirebaseFeedUserService(
      options: options,
      app: app,
    );

    firebasePostService ??= FirebaseFeedPostService(
      userService: userService,
      options: options,
      app: app,
    );
  }

  final FirebaseFeedOptions? options;
  final FirebaseApp? app;
  FeedPostService? firebasePostService;
  FeedUserService? firebaseUserService;

  @override
  FeedPostService get postService {
    if (firebasePostService != null) {
      return firebasePostService!;
    } else {
      return FirebaseFeedPostService(
        userService: userService,
        options: options,
        app: app,
      );
    }
  }

  @override
  FeedUserService get userService {
    if (firebaseUserService != null) {
      return firebaseUserService!;
    } else {
      return FirebaseFeedUserService(
        options: options,
        app: app,
      );
    }
  }
}
