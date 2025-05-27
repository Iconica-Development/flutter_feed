// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_feed_interface/flutter_feed_interface.dart";
import "package:flutter_feed_view/src/config/feed_options.dart";
import "package:flutter_feed_view/src/widgets/post_components/header.dart";
import "package:flutter_feed_view/src/widgets/post_components/image.dart";
import "package:flutter_feed_view/src/widgets/post_components/info.dart";
import "package:intl/intl.dart";

class FeedPostScreen extends StatefulWidget {
  const FeedPostScreen({
    required this.userId,
    required this.service,
    required this.options,
    required this.post,
    required this.onPostDelete,
    this.allowAllDeletion = false,
    this.isOverviewScreen = false,
    this.onUserTap,
    super.key,
  });

  /// The user id of the current user
  final String userId;

  /// Allow all posts to be deleted instead of
  ///  only the posts of the current user
  final bool allowAllDeletion;

  /// The feed service to fetch the post details
  final FeedService service;

  /// Options to configure the feed screens
  final FeedOptions options;

  /// The post to show
  final FeedPost post;

  /// If this is not null, the user can tap on the user avatar or name
  final Function(String userId)? onUserTap;

  final VoidCallback onPostDelete;

  final bool? isOverviewScreen;

  @override
  State<FeedPostScreen> createState() => _FeedPostScreenState();
}

class _FeedPostScreenState extends State<FeedPostScreen> {
  FeedPost? post;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadPostDetails();
    });
  }

  Future<void> loadPostDetails() async {
    try {
      var loadedPost =
          await widget.service.postService.fetchPostDetails(widget.post);
      setState(() {
        post = loadedPost;
        isLoading = false;
      });
    } on Exception catch (_) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void updatePost(FeedPost newPost) {
    setState(() {
      post = newPost;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var dateFormat = widget.options.dateFormat ??
        DateFormat(
          "dd/MM/yyyy 'at' HH:mm",
          Localizations.localeOf(context).languageCode,
        );
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
    if (this.post == null) {
      return Center(
        child: Text(
          widget.options.translations.postLoadingError,
          style: widget.options.theme.textStyles.errorTextStyle,
        ),
      );
    }
    var post = this.post!;
    var isLikedByUser = post.likedBy?.contains(widget.userId) ?? false;

    return Stack(
      children: [
        RefreshIndicator.adaptive(
          onRefresh: () async {
            updatePost(
              await widget.service.postService.fetchPostDetails(
                await widget.service.postService.fetchPost(
                  post,
                ),
              ),
            );
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: widget.options.paddings.postPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostHeader(
                    service: widget.service,
                    options: widget.options,
                    userId: widget.userId,
                    post: widget.post,
                    allowDeletion: !(widget.isOverviewScreen ?? false) &&
                        (widget.allowAllDeletion ||
                            post.creator?.userId == widget.userId),
                    onUserTap: widget.onUserTap,
                    onPostDelete: widget.onPostDelete,
                  ),
                  if (post.imageUrl != null || post.image != null) ...[
                    const SizedBox(height: 8.0),
                    PostImage(
                      options: widget.options,
                      service: widget.service,
                      userId: widget.userId,
                      post: widget.post,
                      flexible: false,
                      onUpdatePost: loadPostDetails,
                    ),
                  ],
                  const SizedBox(height: 8.0),
                  // post information
                  _PostLikeAndReactionsInformation(
                    options: widget.options,
                    post: widget.post,
                    isLikedByUser: isLikedByUser,
                    onLikePressed: () async {
                      if (widget.isOverviewScreen ?? false) return;
                      if (isLikedByUser) {
                        updatePost(
                          await widget.service.postService.unlikePost(
                            widget.userId,
                            post,
                          ),
                        );
                        setState(() {});
                      } else {
                        updatePost(
                          await widget.service.postService.likePost(
                            widget.userId,
                            post,
                          ),
                        );
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  // ignore: avoid_bool_literals_in_conditional_expressions
                  if (widget.isOverviewScreen != null
                      ? !widget.isOverviewScreen!
                      : false) ...[
                    Text(
                      // ignore: lines_longer_than_80_chars
                      "${post.likes} ${post.likes > 1 ? widget.options.translations.multipleLikesTitle : widget.options.translations.oneLikeTitle}",
                      style: widget.options.theme.textStyles
                              .postLikeTitleAndAmount ??
                          theme.textTheme.titleSmall
                              ?.copyWith(color: Colors.black),
                    ),
                  ],
                  PostTitle(
                    options: widget.options,
                    post: post,
                    isForList: false,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    post.content,
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    "${dateFormat.format(post.createdAt)} ",
                    style: theme.textTheme.labelSmall?.copyWith(
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PostLikeAndReactionsInformation extends StatelessWidget {
  const _PostLikeAndReactionsInformation({
    required this.options,
    required this.post,
    required this.isLikedByUser,
    required this.onLikePressed,
  });

  final FeedOptions options;
  final FeedPost post;
  final bool isLikedByUser;
  final VoidCallback onLikePressed;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onLikePressed,
            icon: isLikedByUser
                ? options.theme.likedIcon ??
                    Icon(
                      Icons.favorite_rounded,
                      color: options.theme.iconColor,
                      size: options.iconSize,
                    )
                : options.theme.likeIcon ??
                    Icon(
                      Icons.favorite_outline_outlined,
                      color: options.theme.iconColor,
                      size: options.iconSize,
                    ),
          ),
          const SizedBox(width: 8.0),
        ],
      );
}
