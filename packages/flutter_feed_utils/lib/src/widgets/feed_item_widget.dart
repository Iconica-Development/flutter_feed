// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

class FeedViewItem extends StatelessWidget {
  const FeedViewItem({
    required this.title,
    required this.onTap,
    this.authorAvatarUrl,
    this.authorName,
    this.likeCount,
    this.content,
    this.imageUrl,
    this.actionBuilder,
    this.onUserTap,
    super.key,
  });

  final String? authorAvatarUrl;
  final String? authorName;
  final int? likeCount;
  final String title;
  final String? content;
  final String? imageUrl;

  final Widget Function()? actionBuilder;
  final VoidCallback onTap;

  /// If this is not null, the user can tap on the user avatar or name.
  /// It will only be used when [authorAvatarUrl] is not null.
  final Function(String userId)? onUserTap;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (authorName != null) ...[
            _PostHeader(
              authorName: authorName!,
              authorAvatarUrl: authorAvatarUrl,
              allowDeletion: false,
              onPostDelete: () {},
              onUserTap: (userId) {},
            ),
          ],
          if (imageUrl != null) ...[
            CachedNetworkImage(
              imageUrl: imageUrl!,
              width: 390.0,
              height: 250.0,
            ),
          ],
          const SizedBox(height: 8.0),
          _PostInfo(
            authorName: authorName,
            content: title,
            likeCount: likeCount,
            actionBuilder: actionBuilder,
            onTap: onTap,
          ),
        ],
      );
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    required this.authorName,
    this.authorAvatarUrl,
    this.allowDeletion = false,
    this.onPostDelete,
    this.onUserTap,
  }) : assert(
          !allowDeletion || onPostDelete != null,
          "When allowDeletion is true onPostDelete can not be null",
        );

  final String? authorAvatarUrl;
  final String authorName;
  final bool allowDeletion;
  final VoidCallback? onPostDelete;
  final void Function(String userId)? onUserTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SizedBox(
      height: 40.0,
      child: Row(
        children: [
          if (authorAvatarUrl != null) ...[
            CachedNetworkImage(imageUrl: authorAvatarUrl!),
            const SizedBox(width: 8.0),
          ],
          Text(
            authorName,
            style: theme.textTheme.titleSmall,
          ),
          const Spacer(),
          if (allowDeletion) ...[
            PopupMenuButton(
              onSelected: (value) async {},
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: "delete",
                  child: Text(
                    "Delete post",
                    // options.translations.deletePost,
                  ),
                ),
              ],
              child: const Icon(Icons.more_horiz_rounded),
            ),
          ],
        ],
      ),
    );
  }
}

class _PostInfo extends StatelessWidget {
  const _PostInfo({
    this.likeCount,
    this.authorName,
    this.content,
    this.actionBuilder,
    this.onTap,
  });

  final int? likeCount;
  final String? authorName;
  final String? content;
  final Widget Function()? actionBuilder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (actionBuilder != null) ...[
          actionBuilder!.call(),
        ],
        if (likeCount != null) ...[
          Text(
            "$likeCount likes",
            style: theme.textTheme.titleSmall,
          ),
        ],
        if (authorName != null || content != null) ...[
          const SizedBox(height: 4.0),
          Row(
            children: [
              if (authorName != null) ...[
                Text(
                  authorName!,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(width: 8.0),
              ],
              if (content != null) ...[
                Text(
                  content!,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ],
        if (onTap != null) ...[
          const SizedBox(height: 4.0),
          InkWell(
            onTap: onTap,
            child: Text(
              "View post",
              // options.translations.viewPost,
              style: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ],
    );
  }
}
