// SPDX-FileCopyrightText: 2025 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause
import "package:dart_feed_utilities/filters.dart";
import "package:flutter/material.dart";
import "package:flutter_catalog/src/config/catalog_options.dart";
import "package:flutter_catalog/src/repositories/memory_filter_repository.dart";
import "package:flutter_catalog/src/routes.dart";
import "package:flutter_catalog/src/services/catalog_service.dart";
import "package:flutter_catalog/src/services/pop_handler.dart";
import "package:flutter_catalog/src/utils/scope.dart";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";
import "package:flutter_hooks/flutter_hooks.dart";

/// A self-contained user story for Browse a catalog of items.
///
/// Starts with the overview screen.
class FlutterCatalogUserstory extends _BaseCatalogNavigatorUserstory {
  /// Constructs a [FlutterCatalogUserstory].
  const FlutterCatalogUserstory({
    required super.userId,
    required super.options,
    super.onExit,
    super.key,
  });

  @override
  MaterialPageRoute buildInitialRoute(
    BuildContext context,
  ) =>
      catalogOverviewRoute(
        onExit: onExit,
      );
}

/// A self-contained user story that starts directly on an item's detail page.
class FlutterCatalogDetailUserstory extends _BaseCatalogNavigatorUserstory {
  /// Constructs a [FlutterCatalogDetailUserstory].
  const FlutterCatalogDetailUserstory({
    required super.userId,
    required super.options,
    required this.item,
    super.onExit,
    super.key,
  });

  /// The catalog item to display initially.
  final CatalogItem item;

  @override
  MaterialPageRoute buildInitialRoute(
    BuildContext context,
  ) =>
      catalogDetailRoute(
        item: item,
      );
}

/// Base hook widget for catalog navigator user stories.
abstract class _BaseCatalogNavigatorUserstory extends HookWidget {
  /// Constructs a [_BaseCatalogNavigatorUserstory].
  const _BaseCatalogNavigatorUserstory({
    required this.userId,
    required this.options,
    this.onExit,
    super.key,
  });

  /// The user ID of the person starting the catalog user story.
  final String userId;

  /// The catalog user story configuration.
  final CatalogOptions options;

  /// Callback for when the user wants to navigate out of the user story.
  final VoidCallback? onExit;

  /// Implemented by subclasses to provide the initial route of the user story.
  MaterialPageRoute buildInitialRoute(
    BuildContext context,
  );

  @override
  Widget build(BuildContext context) {
    var catalogService = useMemoized(
      () => CatalogService(
        repository: options.catalogRepository,
        userId: userId,
      ),
      [options.catalogRepository],
    );

    var filterService = useMemoized(
      () => FilterService(
        filterRepository: options.filterOptions?.filterRepository ??
            CatalogMemoryFilterRepository(),
        filterValueRepository: options.filterOptions?.filterValueRepository,
        filterDataSourceRepository:
            options.filterOptions?.filterDataSourceRepository,
        namespace: options.filterOptions?.namespace,
      ),
      [options.filterOptions],
    );
    var popHandler = useMemoized(PopHandler.new, []);

    return CatalogScope(
      userId: userId,
      options: options,
      catalogService: catalogService,
      filterService: filterService,
      popHandler: popHandler,
      child: NavigatorPopHandler(
        onPop: popHandler.handlePop,
        child: Navigator(
          onGenerateInitialRoutes: (_, __) => [
            buildInitialRoute(
              context,
            ),
          ],
        ),
      ),
    );
  }
}
