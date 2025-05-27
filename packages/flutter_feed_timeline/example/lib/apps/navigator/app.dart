import "package:example/l10n/app_localizations.dart";
import "package:flutter/material.dart";
import "package:flutter_feed_timeline/flutter_feed_timeline.dart";

class NavigatorApp extends StatelessWidget {
  const NavigatorApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Flutter Feed",
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          FlutterFeedLocalizations.delegate,
        ],
        supportedLocales: const [Locale("en")],
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: FlutterFeedTimelineUserstory(
          configuration: FeedTimelineUserStoryConfiguration(
            timelineRepository: MemoryFeedItemService(),
            timelineLikesRepository: MemoryTimelineLikesRepository(),
          ),
        ),
      );
}
