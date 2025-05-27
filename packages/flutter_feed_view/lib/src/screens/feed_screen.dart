// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:async";

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_feed_interface/flutter_feed_interface.dart";
import "package:flutter_feed_view/src/config/feed_options.dart";
import "package:flutter_feed_view/src/screens/feed_post_screen.dart";
import "package:flutter_feed_view/src/services/local_post_service.dart";
import "package:flutter_feed_view/src/widgets/category_selector.dart";
import "package:flutter_feed_view/src/widgets/feed_post_widget.dart";

class FeedScreen extends StatefulWidget {
  FeedScreen({
    this.userId = "test_user",
    FeedService? service,
    this.options = const FeedOptions(),
    this.onPostTap,
    this.scrollController,
    this.onUserTap,
    this.onRefresh,
    this.posts,
    this.feedCategory,
    this.postWidgetBuilder,
    this.filterEnabled = false,
    this.allowAllDeletion = false,
    super.key,
  }) : service = service ??
            FeedService(
              postService: LocalFeedPostService(),
            );

  /// The user id of the current user
  final String userId;

  /// Allow all posts to be deleted instead of
  ///  only the posts of the current user
  final bool allowAllDeletion;

  /// The service to use for fetching and manipulating posts
  final FeedService service;

  /// All the configuration options for the feedscreens and widgets
  final FeedOptions options;

  /// The controller for the scroll view
  final ScrollController? scrollController;

  /// The string to filter the feed by category
  final String? feedCategory;

  /// This is used if you want to pass in a list of posts instead
  /// of fetching them from the service
  final List<FeedPost>? posts;

  /// Called when a post is tapped
  final Function(FeedPost)? onPostTap;

  /// Called when the feed is refreshed by pulling down
  final Function(BuildContext context, String? category)? onRefresh;

  /// If this is not null, the user can tap on the user avatar or name
  final Function(String userId)? onUserTap;

  /// Override the standard postwidget
  final Widget Function(FeedPost post)? postWidgetBuilder;

  /// if true the filter textfield is enabled.
  final bool filterEnabled;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late ScrollController controller;
  late TextEditingController textFieldController = TextEditingController(
    text: widget.options.filterOptions.initialFilterWord,
  );

  bool isLoading = true;

  late String? category = widget.feedCategory;

  late String? filterWord = widget.options.filterOptions.initialFilterWord;

  bool _isOnTop = true;

  @override
  void dispose() {
    controller.removeListener(_updateIsOnTop);
    controller.dispose();
    super.dispose();
  }

  void _updateIsOnTop() {
    setState(() {
      _isOnTop = controller.position.pixels < 0.1;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = widget.scrollController ?? ScrollController();
    controller.addListener(_updateIsOnTop);

    // only load the posts after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(loadPosts());
    });
  }

  @override
  void didUpdateWidget(covariant FeedScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(loadPosts());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && widget.posts == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    // Build the list of posts
    return ListenableBuilder(
      listenable: widget.service.postService,
      builder: (context, _) {
        if (!context.mounted) return const SizedBox();
        var posts =
            widget.posts ?? widget.service.postService.getPosts(category);

        if (widget.filterEnabled && filterWord != null) {
          if (widget.service.postService is FeedFilterService) {
            posts = (widget.service.postService as FeedFilterService)
                .filterPosts(filterWord!, {});
          } else {
            debugPrint("Feed service needs to mixin"
                " with FeedFilterService");
          }
        }

        posts = posts
            .where(
              (p) => category == null || p.category == category,
            )
            .toList();

        // sort posts by date
        if (widget.options.sortPostsAscending != null) {
          posts.sort(
            (a, b) => widget.options.sortPostsAscending!
                ? a.createdAt.compareTo(b.createdAt)
                : b.createdAt.compareTo(a.createdAt),
          );
        }

        var categories = widget.service.postService.categories;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: widget.options.paddings.mainPadding.top,
            ),
            if (widget.filterEnabled) ...[
              Padding(
                padding: EdgeInsets.only(
                  left: widget.options.paddings.mainPadding.left,
                  right: widget.options.paddings.mainPadding.right,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textFieldController,
                        onChanged: (value) {
                          setState(() {
                            filterWord = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: widget.options.translations.searchHint,
                          suffixIconConstraints:
                              const BoxConstraints(maxHeight: 14),
                          contentPadding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                            bottom: -10,
                          ),
                          suffixIcon: const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          textFieldController.clear();
                          filterWord = null;
                          widget.options.filterOptions.onFilterEnabledChange
                              ?.call(filterEnabled: false);
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.close,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
            CategorySelector(
              categories: categories,
              isOnTop: _isOnTop,
              filter: category,
              options: widget.options,
              onTapCategory: (categoryKey) {
                setState(() {
                  widget.service.postService.selectedCategory =
                      categories.firstWhereOrNull(
                    (element) => element.key == categoryKey,
                  );
                  category = categoryKey;
                });
              },
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: RefreshIndicator.adaptive(
                onRefresh: () async {
                  await widget.onRefresh?.call(context, category);
                  await loadPosts();
                },
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Add a optional custom header to the list of posts
                      widget.options.listHeaderBuilder
                              ?.call(context, category) ??
                          const SizedBox.shrink(),
                      ...posts.map(
                        (post) => Padding(
                          padding: widget.options.paddings.postPadding,
                          child: widget.postWidgetBuilder?.call(post) ??
                              FeedPostWidget(
                                service: widget.service,
                                userId: widget.userId,
                                options: widget.options,
                                allowAllDeletion: widget.allowAllDeletion,
                                post: post,
                                onTap: () async {
                                  if (widget.onPostTap != null) {
                                    widget.onPostTap!.call(post);

                                    return;
                                  }

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                        body: FeedPostScreen(
                                          userId: "test_user",
                                          service: widget.service,
                                          options: widget.options,
                                          post: post,
                                          onPostDelete: () {
                                            widget.service.postService
                                                .deletePost(post);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                onTapLike: () async => widget
                                    .service.postService
                                    .likePost(widget.userId, post),
                                onTapUnlike: () async => widget
                                    .service.postService
                                    .unlikePost(widget.userId, post),
                                onPostDelete: () async =>
                                    widget.service.postService.deletePost(post),
                                onUserTap: widget.onUserTap,
                              ),
                        ),
                      ),
                      if (posts.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              category == null
                                  ? widget.options.translations.noPosts
                                  : widget
                                      .options.translations.noPostsWithFilter,
                              style:
                                  widget.options.theme.textStyles.noPostsStyle,
                            ),
                          ),
                        ),
                      SizedBox(
                        height: widget.options.paddings.mainPadding.bottom,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> loadPosts() async {
    if (widget.posts != null || !context.mounted) return;
    try {
      await widget.service.postService.fetchCategories();
      await widget.service.postService.fetchPosts(category);
      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      // Handle errors here
      debugPrint("Error loading posts: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
}
