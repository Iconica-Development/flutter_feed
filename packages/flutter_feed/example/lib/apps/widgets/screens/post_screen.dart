import 'package:flutter/material.dart';
import 'package:flutter_feed/flutter_feed.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    required this.service,
    required this.post,
    super.key,
  });

  final FeedService service;
  final FeedPost post;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FeedPostScreen(
        userId: 'test_user',
        service: widget.service,
        options: const FeedOptions(),
        post: widget.post,
        onPostDelete: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class TestUserService implements FeedUserService {
  final Map<String, FeedPosterUserModel> _users = {
    'test_user': const FeedPosterUserModel(
      userId: 'test_user',
      imageUrl:
          'https://cdn.britannica.com/68/143568-050-5246474F/Donkey.jpg?w=400&h=300&c=crop',
      firstName: 'Dirk',
      lastName: 'lukassen',
    )
  };

  @override
  Future<FeedPosterUserModel?> getUser(String userId) async {
    if (_users.containsKey(userId)) {
      return _users[userId]!;
    }

    _users[userId] = FeedPosterUserModel(userId: userId);

    return FeedPosterUserModel(userId: userId);
  }
}
