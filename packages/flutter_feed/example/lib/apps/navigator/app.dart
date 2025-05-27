import 'package:example/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feed/flutter_feed.dart';

class NavigatorApp extends StatelessWidget {
  const NavigatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Feed',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
          surface: const Color(0xFFB8E2E8),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var feedService = FeedService(postService: LocalFeedPostService());

  @override
  Widget build(BuildContext context) {
    return feedNavigatorUserStory(
      context: context,
      configuration: getConfig(feedService),
    );
  }
}
