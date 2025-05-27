// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter/material.dart";
import "package:flutter_feed/src/models/feed_configuration.dart";
import "package:flutter_feed_interface/flutter_feed_interface.dart";
import "package:flutter_feed_view/flutter_feed_view.dart";

/// A widget function that creates a feed navigator for user stories.
///
/// This function creates a navigator for displaying user stories on a feed.
/// It takes a [BuildContext] and an optional [FeedUserStoryConfiguration]
/// as parameters. If no configuration is provided, default values will be used.
late FeedUserStoryConfiguration feedUserStoryConfiguration;

Widget feedNavigatorUserStory({
  required BuildContext context,
  FeedUserStoryConfiguration? configuration,
}) {
  feedUserStoryConfiguration = configuration ??
      FeedUserStoryConfiguration(
        userId: "test_user",
        service: FeedService(
          postService: LocalFeedPostService(),
        ),
        optionsBuilder: (context) => const FeedOptions(),
      );

  return _feedScreenRoute(
    config: feedUserStoryConfiguration,
    context: context,
  );
}

/// A widget function that creates a feed screen route.
///
/// This function creates a route for displaying a feed screen. It takes
/// a [BuildContext] and an optional [FeedUserStoryConfiguration] as
/// parameters. If no configuration is provided, default values will be used.
Widget _feedScreenRoute({
  required BuildContext context,
  required FeedUserStoryConfiguration config,
  String? initalCategory,
}) {
  var feedScreen = FeedScreen(
    feedCategory: initalCategory,
    userId: config.getUserId?.call(context) ?? config.userId,
    allowAllDeletion: config.canDeleteAllPosts?.call(context) ?? false,
    onUserTap: (user) => config.onUserTap?.call(context, user),
    service: config.service,
    options: config.optionsBuilder(context),
    onPostTap: (post) async =>
        config.onPostTap?.call(context, post) ??
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => _postDetailScreenRoute(
              config: config,
              context: context,
              post: post,
            ),
          ),
        ),
    onRefresh: config.onRefresh,
    filterEnabled: config.filterEnabled,
    postWidgetBuilder: config.postWidgetBuilder,
  );
  var theme = Theme.of(context);
  var button = FloatingActionButton(
    backgroundColor: config
            .optionsBuilder(context)
            .theme
            .postCreationFloatingActionButtonColor ??
        theme.colorScheme.primary,
    onPressed: () async {
      var selectedCategory = config.service.postService.selectedCategory;
      if (selectedCategory != null && selectedCategory.key != null) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => _postCreationScreenRoute(
              config: config,
              context: context,
              category: selectedCategory,
            ),
          ),
        );
      } else {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => _postCategorySelectionScreen(
              config: config,
              context: context,
            ),
          ),
        );
      }
    },
    shape: const CircleBorder(),
    child: const Icon(
      Icons.add,
      color: Colors.white,
      size: 24,
    ),
  );

  return config.homeOpenPageBuilder?.call(context, feedScreen, button) ??
      Scaffold(
        appBar: AppBar(
          title: Text(
            config.optionsBuilder(context).translations.feedScreenTitle,
            style: theme.textTheme.headlineLarge,
          ),
        ),
        body: feedScreen,
        floatingActionButton: button,
      );
}

/// A widget function that creates a post detail screen route.
///
/// This function creates a route for displaying a post detail screen. It takes
/// a [BuildContext], a [FeedPost], and an optional
/// [FeedUserStoryConfiguration] as parameters. If no configuration is
/// provided, default values will be used.
Widget _postDetailScreenRoute({
  required BuildContext context,
  required FeedPost post,
  required FeedUserStoryConfiguration config,
}) {
  var feedPostScreen = FeedPostScreen(
    userId: config.getUserId?.call(context) ?? config.userId,
    allowAllDeletion: config.canDeleteAllPosts?.call(context) ?? false,
    options: config.optionsBuilder(context),
    service: config.service,
    post: post,
    onPostDelete: () async =>
        config.onPostDelete?.call(context, post) ??
        () async {
          await config.service.postService.deletePost(post);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }.call(),
    onUserTap: (user) => config.onUserTap?.call(context, user),
  );

  var category = config.service.postService.categories
      .firstWhere((element) => element.key == post.category);

  var backButton = IconButton(
    color: Colors.white,
    icon: const Icon(Icons.arrow_back_ios),
    onPressed: () => Navigator.of(context).pop(),
  );

  return config.postViewOpenPageBuilder
          ?.call(context, feedPostScreen, backButton, post, category) ??
      Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          title: Text(
            category.title.toLowerCase(),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: feedPostScreen,
      );
}

/// A widget function that creates a post creation screen route.
///
/// This function creates a route for displaying a post creation screen.
/// It takes a [BuildContext] and an optional [FeedUserStoryConfiguration]
/// as parameters. If no configuration is provided, default values will be used.
Widget _postCreationScreenRoute({
  required BuildContext context,
  required FeedCategory category,
  required FeedUserStoryConfiguration config,
}) {
  var feedPostCreationScreen = FeedPostCreationScreen(
    userId: config.getUserId?.call(context) ?? config.userId,
    options: config.optionsBuilder(context),
    service: config.service,
    onPostCreated: (post) async {
      var newPost = await config.service.postService.createPost(post);

      if (!context.mounted) return;
      if (config.afterPostCreationGoHome) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => _feedScreenRoute(
              config: config,
              context: context,
              initalCategory: category.title,
            ),
          ),
        );
      } else {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _postOverviewScreenRoute(
              config: config,
              context: context,
              post: newPost,
            ),
          ),
        );
      }
    },
    onPostOverview: (post) async => Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _postOverviewScreenRoute(
          config: config,
          context: context,
          post: post,
        ),
      ),
    ),
    enablePostOverviewScreen: config.enablePostOverviewScreen,
    postCategory: category.key,
  );

  var backButton = IconButton(
    icon: const Icon(
      Icons.arrow_back_ios,
      color: Colors.white,
    ),
    onPressed: () => Navigator.of(context).pop(),
  );

  return config.postCreationOpenPageBuilder
          ?.call(context, feedPostCreationScreen, backButton) ??
      Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          leading: backButton,
          title: Text(
            config.optionsBuilder(context).translations.postCreation,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: feedPostCreationScreen,
      );
}

/// A widget function that creates a post overview screen route.
///
/// This function creates a route for displaying a post overview screen.
/// It takes a [BuildContext], a [FeedPost], and an optional
/// [FeedUserStoryConfiguration] as parameters. If no configuration is
/// provided, default values will be used.
Widget _postOverviewScreenRoute({
  required BuildContext context,
  required FeedPost post,
  required FeedUserStoryConfiguration config,
}) {
  var feedPostOverviewWidget = FeedPostOverviewScreen(
    options: config.optionsBuilder(context),
    service: config.service,
    feedPost: post,
    onPostSubmit: (post) async {
      var createdPost = await config.service.postService.createPost(post);
      config.onPostCreate?.call(createdPost);
      if (context.mounted) {
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => _feedScreenRoute(
              config: config,
              context: context,
              initalCategory: post.category,
            ),
          ),
          (route) => false,
        );
      }
    },
  );

  var backButton = IconButton(
    icon: const Icon(
      Icons.arrow_back_ios,
      color: Colors.white,
    ),
    onPressed: () async => Navigator.of(context).pop(),
  );

  return config.postOverviewOpenPageBuilder?.call(
        context,
        feedPostOverviewWidget,
      ) ??
      Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          leading: backButton,
          title: Text(
            config.optionsBuilder(context).translations.postCreation,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: feedPostOverviewWidget,
      );
}

Widget _postCategorySelectionScreen({
  required BuildContext context,
  required FeedUserStoryConfiguration config,
}) {
  var feedSelectionScreen = FeedSelectionScreen(
    postService: config.service.postService,
    options: config.optionsBuilder(context),
    categories: config.service.postService.categories,
    onCategorySelected: (category) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _postCreationScreenRoute(
            config: config,
            context: context,
            category: category,
          ),
        ),
      );
    },
  );

  var backButton = IconButton(
    color: Colors.white,
    icon: const Icon(Icons.arrow_back_ios),
    onPressed: () async {
      Navigator.of(context).pop();
    },
  );

  return config.categorySelectionOpenPageBuilder
          ?.call(context, feedSelectionScreen) ??
      Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          leading: backButton,
          title: Text(
            config.optionsBuilder(context).translations.postCreation,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: feedSelectionScreen,
      );
}

Future<void> routeToPostDetail(BuildContext context, FeedPost post) async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => _postDetailScreenRoute(
        config: feedUserStoryConfiguration,
        context: context,
        post: post,
      ),
    ),
  );
}
