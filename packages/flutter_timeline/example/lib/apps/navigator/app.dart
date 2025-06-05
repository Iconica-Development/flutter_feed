import "package:example/l10n/app_localizations.dart";
import "package:flutter/material.dart";
import "package:flutter_timeline/flutter_timeline.dart";

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
            onSurface: const Color(0xFF212121),
            onTertiary: const Color(0xFF9E9E9E),
          ),
          useMaterial3: true,
          textTheme: const TextTheme(
            labelSmall: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12.0,
            ),
            bodySmall: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
            titleSmall: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14.0,
            ),
          ),
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
  Widget build(BuildContext context) => FlutterFeedTimelineUserstory(
        service: TimelineService(
          repository: MemoryFeedItemService(),
          likesRepository: MemoryTimelineLikesRepository(),
        ),
        configuration: const TimelineUserStoryConfiguration(),
      );
}
