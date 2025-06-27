import "package:flutter/material.dart";
import "package:flutter_catalog/src/views/catalog_detail_view.dart";
import "package:flutter_catalog/src/views/catalog_filter_view.dart";
import "package:flutter_catalog/src/views/catalog_overview_view.dart";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// Returns a [MaterialPageRoute] for the catalog overview screen.
MaterialPageRoute catalogOverviewRoute({
  required VoidCallback? onExit,
}) =>
    MaterialPageRoute(
      builder: (context) => CatalogOverviewView(
        onExit: onExit,
        onPressItem: (item) async => _routeToScreen(
          context,
          catalogDetailRoute(
            item: item,
          ).builder(context),
        ),
        onPressFilters: () async => _routeToScreen(
          context,
          catalogFilterRoute().builder(context),
        ),
      ),
    );

/// Returns a [MaterialPageRoute] for the catalog item detail screen.
MaterialPageRoute catalogDetailRoute({
  required CatalogItem item,
}) =>
    MaterialPageRoute(
      builder: (context) => CatalogDetailView(
        item: item,
        onExit: () => Navigator.of(context).pop(),
      ),
    );

/// Returns a [MaterialPageRoute] for the catalog filter screen.
MaterialPageRoute catalogFilterRoute() => MaterialPageRoute(
      builder: (context) => CatalogFilterView(
        onExit: () => Navigator.of(context).pop(),
      ),
    );

/// Navigates to a new screen within the user story's [Navigator].
Future<void> _routeToScreen(BuildContext context, Widget screen) async =>
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
