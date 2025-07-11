import "package:dart_feed_utilities/dart_feed_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_catalog/src/views/catalog_detail_view.dart";
import "package:flutter_catalog/src/views/catalog_filter_view.dart";
import "package:flutter_catalog/src/views/catalog_modify_view.dart";
import "package:flutter_catalog/src/views/catalog_overview_view.dart";
import "package:flutter_catalog/src/views/catalog_sub_filter_view.dart";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// A callback type for navigating to a sub-filter selection screen.
typedef NavigateToSubFilterCallback = Future<List<String>?> Function(
  BuildContext context,
  DataSourceMultiSelectFilter filter,
  List<String> initialSelection,
);

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
        onEditItem: (itemToEdit) async => _routeToScreen(
          context,
          catalogModifyRoute(
            initialItem: itemToEdit,
            onExit: () => Navigator.of(context).pop(),
          ).builder(context),
        ),
      ),
    );

/// Returns a [MaterialPageRoute] for the create/edit screen.
MaterialPageRoute<void> catalogModifyRoute({
  required VoidCallback onExit,
  CatalogItem? initialItem,
}) =>
    MaterialPageRoute(
      builder: (context) => CatalogModifyView(
        initialItem: initialItem,
        onExit: onExit,
        onNavigateToSubFilter: (navContext, filter, initialSelection) async =>
            Navigator.of(navContext).push<List<String>?>(
          catalogSubFilterRoute(
            filter: filter,
            initialSelection: initialSelection,
          ),
        ),
      ),
    );

/// Returns a [MaterialPageRoute] for the catalog filter screen.
MaterialPageRoute catalogFilterRoute() => MaterialPageRoute(
      builder: (context) => CatalogFilterView(
        onExit: () => Navigator.of(context).pop(),
        onNavigateToSubFilter: (navContext, filter, initialSelection) async =>
            Navigator.of(navContext).push<List<String>?>(
          catalogSubFilterRoute(
            filter: filter,
            initialSelection: initialSelection,
          ),
        ),
      ),
    );

/// Returns a [MaterialPageRoute] for the sub-filter selection screen.
/// This route can return a `List<String>` of the selected keys.
MaterialPageRoute<List<String>?> catalogSubFilterRoute({
  required DataSourceMultiSelectFilter filter,
  required List<String> initialSelection,
}) =>
    MaterialPageRoute(
      builder: (context) => CatalogSubFilterView(
        filter: filter,
        initialSelection: initialSelection,
      ),
    );

/// Navigates to a new screen within the user story's [Navigator].
Future<void> _routeToScreen(BuildContext context, Widget screen) async =>
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
