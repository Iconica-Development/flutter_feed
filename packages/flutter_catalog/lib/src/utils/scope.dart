import "package:dart_feed_utilities/dart_feed_utilities.dart";
import "package:flutter/widgets.dart";
import "package:flutter_catalog/src/config/catalog_options.dart";
import "package:flutter_catalog/src/services/catalog_service.dart";
import "package:flutter_catalog/src/services/pop_handler.dart";

///
class CatalogScope extends InheritedWidget {
  ///
  const CatalogScope({
    required this.userId,
    required this.options,
    required this.catalogService,
    required this.filterService,
    required this.popHandler,
    required super.child,
    super.key,
  });

  ///
  final String userId;

  ///
  final CatalogOptions options;

  ///
  final CatalogService catalogService;

  ///
  final FilterService filterService;

  ///
  final PopHandler popHandler;

  @override
  bool updateShouldNotify(CatalogScope oldWidget) =>
      oldWidget.userId != userId || oldWidget.options != options;

  ///
  static CatalogScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CatalogScope>()!;
}
