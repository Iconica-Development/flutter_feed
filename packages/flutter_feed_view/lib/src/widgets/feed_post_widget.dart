// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter/material.dart";
import "package:flutter_feed_interface/flutter_feed_interface.dart";
import "package:flutter_feed_view/src/config/feed_options.dart";
import "package:flutter_feed_view/src/widgets/default_filled_button.dart";
import "package:flutter_feed_view/src/widgets/post_components/header.dart";
import "package:flutter_feed_view/src/widgets/post_components/image.dart";
import "package:flutter_feed_view/src/widgets/post_components/info.dart";

class FeedPostWidget extends StatefulWidget {
  const FeedPostWidget({
    required this.userId,
    required this.options,
    required this.post,
    required this.onTap,
    required this.onTapLike,
    required this.onTapUnlike,
    required this.onPostDelete,
    required this.service,
    required this.allowAllDeletion,
    this.onUserTap,
    super.key,
  });

  /// The user id of the current user
  final String userId;

  /// Allow all posts to be deleted instead of
  ///  only the posts of the current user
  final bool allowAllDeletion;

  final FeedOptions options;

  final FeedPost post;

  /// Optional max height of the post
  final VoidCallback onTap;
  final VoidCallback onTapLike;
  final VoidCallback onTapUnlike;
  final VoidCallback onPostDelete;
  final FeedService service;

  /// If this is not null, the user can tap on the user avatar or name
  final Function(String userId)? onUserTap;

  @override
  State<FeedPostWidget> createState() => _FeedPostWidgetState();
}

class _FeedPostWidgetState extends State<FeedPostWidget> {
  @override
  Widget build(BuildContext context) {
    var isLikedByUser = widget.post.likedBy?.contains(widget.userId) ?? false;

    return SizedBox(
      height: widget.post.imageUrl != null || widget.post.image != null
          ? widget.options.postWidgetHeight
          : null,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(
            service: widget.service,
            options: widget.options,
            userId: widget.userId,
            post: widget.post,
            allowDeletion: widget.allowAllDeletion ||
                widget.post.creator?.userId == widget.userId,
            onUserTap: widget.onUserTap,
            onPostDelete: widget.onPostDelete,
          ),
          if (widget.post.imageUrl != null || widget.post.image != null) ...[
            const SizedBox(height: 8.0),
            PostImage(
              service: widget.service,
              options: widget.options,
              userId: widget.userId,
              post: widget.post,
            ),
          ],
          const SizedBox(height: 8.0),
          _PostLikeAndReactionsInformation(
            service: widget.service,
            options: widget.options,
            userId: widget.userId,
            post: widget.post,
            isLikedByUser: isLikedByUser,
            onTapComment: widget.onTap,
          ),
          const SizedBox(height: 8.0),
          if (widget.options.itemInfoBuilder != null) ...[
            widget.options.itemInfoBuilder!(post: widget.post),
          ] else ...[
            _PostInfo(
              options: widget.options,
              post: widget.post,
              onTap: widget.onTap,
            ),
          ],
          if (widget.options.dividerBuilder != null) ...[
            widget.options.dividerBuilder!(),
          ],
        ],
      ),
    );
  }
}

class _PostLikeAndReactionsInformation extends StatelessWidget {
  const _PostLikeAndReactionsInformation({
    required this.service,
    required this.options,
    required this.userId,
    required this.post,
    required this.isLikedByUser,
    required this.onTapComment,
  });

  final FeedService service;
  final FeedOptions options;
  final String userId;
  final FeedPost post;
  final bool isLikedByUser;
  final VoidCallback onTapComment;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () async {
              if (!isLikedByUser) {
                await service.postService.likePost(
                  userId,
                  post,
                );
              } else {
                await service.postService.unlikePost(
                  userId,
                  post,
                );
              }
            },
            icon: options.theme.likeIcon ??
                Icon(
                  isLikedByUser
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_outlined,
                  color: options.theme.iconColor,
                  size: options.iconSize,
                ),
          ),
          const SizedBox(width: 4.0),
          if (options.iconsWithValues) ...[
            Text("${post.likes}"),
          ],
        ],
      );
}

class _PostInfo extends StatelessWidget {
  const _PostInfo({
    required this.options,
    required this.post,
    required this.onTap,
  });

  final FeedOptions options;
  final FeedPost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PostLikeCountText(
          post: post,
          options: options,
        ),
        const SizedBox(height: 4.0),
        PostTitle(
          options: options,
          post: post,
          isForList: true,
        ),
        const SizedBox(height: 4.0),
        InkWell(
          onTap: onTap,
          child: Text(
            options.translations.viewPost,
            style: options.theme.textStyles.viewPostStyle ??
                theme.textTheme.titleSmall!.copyWith(
                  color: const Color(0xFF8D8D8D),
                ),
          ),
        ),
      ],
    );
  }
}

class _PostLikeCountText extends StatelessWidget {
  const _PostLikeCountText({
    required this.post,
    required this.options,
  });

  final FeedOptions options;
  final FeedPost post;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var likeTranslation = post.likes > 1
        ? options.translations.multipleLikesTitle
        : options.translations.oneLikeTitle;

    return Text(
      "${post.likes} "
      "$likeTranslation",
      style: options.theme.textStyles.listPostLikeTitleAndAmount ??
          theme.textTheme.titleSmall!.copyWith(
            color: Colors.black,
          ),
    );
  }
}

Future<void> showPostDeletionConfirmationDialog(
  FeedOptions options,
  BuildContext context,
  Function() onPostDelete,
) async {
  var theme = Theme.of(context);
  var result = await showDialog(
    context: context,
    builder: (BuildContext context) =>
        options.deletionDialogBuilder?.call(context) ??
        AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
          titlePadding: const EdgeInsets.only(left: 44, right: 44, top: 32),
          title: Text(
            options.translations.deleteConfirmationMessage,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DefaultFilledButton(
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                      },
                      buttonText: options.translations.deleteButton,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  options.translations.deleteCancelButton,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    decoration: TextDecoration.underline,
                    color: theme.textTheme.bodyMedium?.color!.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
  );

  if (result == true) {
    onPostDelete();
  }
}
