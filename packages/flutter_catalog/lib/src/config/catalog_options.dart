import "package:dart_feed_utilities/dart_feed_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_catalog/src/config/catalog_builders.dart";
import "package:flutter_catalog/src/config/catalog_theme.dart";
import "package:flutter_catalog/src/config/catalog_translations.dart";
import "package:flutter_catalog/src/repositories/memory_catalog_repository.dart";
import "package:flutter_catalog/src/repositories/memory_catalog_user_repository.dart";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// A comprehensive configuration class for the Catalog User Story.
///
/// Use this class to customize all aspects of the feature, from data
/// repositories to UI builders and translations.
class CatalogOptions {
  /// Constructs a [CatalogOptions].
  CatalogOptions({
    CatalogRepository? catalogRepository,
    CatalogUserRepository? catalogUserRepository,
    this.builders = const CatalogBuilders(),
    this.theme = const CatalogTheme(),
    this.translations = const CatalogTranslations.empty(),
    this.onPressContactUser,
    this.filterOptions,
    this.onNoItems,
  })  : catalogRepository = catalogRepository ?? MemoryCatalogRepository(),
        catalogUserRepository =
            catalogUserRepository ?? MemoryCatalogUserRepository();

  /// The repository for fetching and managing catalog item data.
  ///
  /// Defaults to an in-memory repository for easy setup and testing.
  final CatalogRepository catalogRepository;

  /// The repository for fetching and managing user data.
  ///
  /// Defaults to an in-memory repository for easy setup and testing.
  final CatalogUserRepository catalogUserRepository;

  /// A collection of builders to customize the UI components.
  final CatalogBuilders builders;

  /// All theme and style configurations for the UI.
  final CatalogTheme theme;

  /// The translations that can be updated by the consuming app.
  /// The userstory also has a default set of translations used with
  /// flutter_localizations.
  final CatalogTranslations translations;

  /// An optional callback that is triggered when an item fetch results
  /// in an empty list.
  final VoidCallback? onNoItems;

  /// A callback to execute when the user wants to contact the author.
  final void Function(CatalogUser user)? onPressContactUser;

  /// An optional filter configuration for managing item filtering.
  final FilterOptions? filterOptions;

  /// Creates a copy of this object with the given fields replaced
  /// with the new values.
  CatalogOptions copyWith({
    CatalogRepository? catalogRepository,
    CatalogUserRepository? catalogUserRepository,
    CatalogBuilders? builders,
    CatalogTheme? theme,
    CatalogTranslations? translations,
    VoidCallback? onNoItems,
    FilterOptions? filterOptions,
    void Function(CatalogUser user)? onPressContactUser,
  }) =>
      CatalogOptions(
        catalogRepository: catalogRepository ?? this.catalogRepository,
        catalogUserRepository:
            catalogUserRepository ?? this.catalogUserRepository,
        builders: builders ?? this.builders,
        theme: theme ?? this.theme,
        translations: translations ?? this.translations,
        onNoItems: onNoItems ?? this.onNoItems,
        filterOptions: filterOptions ?? this.filterOptions,
        onPressContactUser: onPressContactUser ?? this.onPressContactUser,
      );
}

/// A configuration class for managing filter-related repositories and options.
class FilterOptions {
  /// Constructs a [FilterOptions].
  const FilterOptions({
    this.showFiltersInOverview = true,
    this.showSearchInOverview = true,
    this.filterRepository,
    this.filterValueRepository,
    this.filterDataSourceRepository,
    this.namespace,
  });

  /// Whether to show the filters in the overview screen.
  /// If disabled the filter section on the overview screen will not be
  /// displayed
  final bool showFiltersInOverview;

  /// Whether to show the search bar in the overview screen's AppBar.
  /// Defaults to true.
  final bool showSearchInOverview;

  /// The repository for managing filter data.
  final FilterRepository? filterRepository;

  /// The repository for managing filter values.
  final FilterValueRepository? filterValueRepository;

  /// The repository for managing filter data sources.
  final FilterDataSourceRepository? filterDataSourceRepository;

  /// An optional namespace to scope the filters.
  final String? namespace;
}
