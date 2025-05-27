import 'package:flutter/material.dart';
import 'package:flutter_feed/flutter_feed.dart';

FeedUserStoryConfiguration getConfig(FeedService service) {
  return FeedUserStoryConfiguration(
    service: service,
    userId: 'test_user',
    optionsBuilder: (context) => options,
    enablePostOverviewScreen: false,
    canDeleteAllPosts: (_) => true,
  );
}

var options = FeedOptions(
  textInputBuilder: null,
  paddings: FeedPaddingOptions(
    mainPadding: const EdgeInsets.all(20).copyWith(top: 28),
  ),
);

void navigateToOverview(
  BuildContext context,
  FeedService service,
  FeedOptions options,
  FeedPost post,
) {
  if (context.mounted) {
    Navigator.of(context).pop();
  }
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FeedPostOverviewScreen(
        feedPost: post,
        options: options,
        service: service,
        onPostSubmit: (post) {
          service.postService.createPost(post);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    ),
  );
}

void createPost(
  BuildContext context,
  FeedService service,
  FeedOptions options,
  FeedUserStoryConfiguration configuration,
) async {
  await Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => Scaffold(
        body: FeedPostCreationScreen(
          postCategory: 'category1',
          userId: 'test_user',
          service: service,
          options: options,
          onPostCreated: (post) {
            Navigator.of(context).pop();
          },
          onPostOverview: (post) {
            navigateToOverview(context, service, options, post);
          },
          enablePostOverviewScreen: configuration.enablePostOverviewScreen,
        ),
      ),
    ),
  );
}

void generatePost(FeedService service) {
  var amountOfPosts = service.postService.getPosts(null).length;

  service.postService.createPost(
    FeedPost(
      id: 'Post$amountOfPosts',
      creatorId: 'test_user',
      title: 'Post $amountOfPosts',
      category: amountOfPosts % 2 == 0 ? 'category1' : 'category2',
      content: "Post $amountOfPosts content",
      likes: 0,
      creator: const FeedPosterUserModel(
        userId: 'test_user',
        imageUrl:
            'https://cdn.britannica.com/68/143568-050-5246474F/Donkey.jpg?w=400&h=300&c=crop',
        firstName: 'Dirk',
        lastName: 'lukassen',
      ),
      createdAt: DateTime.now(),
      imageUrl: amountOfPosts % 3 != 0
          ? 'https://s3-eu-west-1.amazonaws.com/sortlist-core-api/6qpvvqjtmniirpkvp8eg83bicnc2'
          : null,
    ),
  );
}
