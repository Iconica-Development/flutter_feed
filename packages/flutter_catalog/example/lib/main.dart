import "package:flutter/material.dart";
import "package:flutter_catalog/flutter_catalog.dart";
import "package:flutter_catalog_example/l10n/app_localizations.dart";

void main() {
  runApp(const CatalogExampleApp());
}

class CatalogExampleApp extends StatelessWidget {
  const CatalogExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Flutter Catalog",
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          ...FlutterCatalogLocalizations.localizationsDelegates,
        ],
        supportedLocales: const [Locale("en")],
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFBDE260),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFBDE260),
            foregroundColor: Colors.black,
          ),
        ),
        home: const CatalogView(),
      );
}

class CatalogView extends StatelessWidget {
  const CatalogView({
    super.key,
  });

  @override
  Widget build(BuildContext context) => FlutterCatalogUserstory(
        userId: "example_user",
        options: CatalogOptions(
          builders: CatalogBuilders(
            baseScreenBuilder: (context, screenType, appBar, title, body) =>
                Scaffold(
              appBar: appBar,
              body: body,
            ),
          ),
        ),
      );
}
