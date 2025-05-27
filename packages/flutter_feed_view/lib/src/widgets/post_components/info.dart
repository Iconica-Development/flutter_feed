import "package:flutter/material.dart";
import "package:flutter_feed_interface/flutter_feed_interface.dart";
import "package:flutter_feed_view/src/config/feed_options.dart";

class PostTitle extends StatelessWidget {
  const PostTitle({
    required this.options,
    required this.post,
    this.isForList = false,
    super.key,
  });

  final FeedOptions options;
  final FeedPost post;

  final bool isForList;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var creatorNameStyle = (isForList
            ? options.theme.textStyles.listCreatorNameStyle
            : options.theme.textStyles.postCreatorNameStyle) ??
        theme.textTheme.titleSmall?.copyWith(color: Colors.black);

    return Row(
      children: [
        Text(
          options.nameBuilder?.call(post.creator) ??
              post.creator?.fullName ??
              options.translations.anonymousUser,
          style: creatorNameStyle,
        ),
        const SizedBox(width: 4.0),
        Text(
          post.title,
          style: options.theme.textStyles.listPostTitleStyle ??
              theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
