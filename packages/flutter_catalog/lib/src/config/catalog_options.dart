import "package:flutter/material.dart";
import "package:flutter_catalog/src/config/catalog_builders.dart";
import "package:flutter_catalog/src/config/catalog_theme.dart";
import "package:flutter_catalog/src/repositories/memory_catalog_repository.dart";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// A comprehensive configuration class for the Catalog User Story.
///
/// Use this class to customize all aspects of the feature, from data
/// repositories to UI builders and translations.
class CatalogOptions {
  /// Constructs a [CatalogOptions].
  CatalogOptions({
    CatalogRepository? catalogRepository,
    this.builders = const CatalogBuilders(),
    this.theme = const CatalogTheme(),
    this.onNoItems,
  }) : catalogRepository = catalogRepository ?? MemoryCatalogRepository();

  /// The repository for fetching and managing catalog item data.
  ///
  /// Defaults to an in-memory repository for easy setup and testing.
  final CatalogRepository catalogRepository;

  /// A collection of builders to customize the UI components.
  final CatalogBuilders builders;

  /// All theme and style configurations for the UI.
  final CatalogTheme theme;

  /// An optional callback that is triggered when an item fetch results
  /// in an empty list.
  final VoidCallback? onNoItems;
}
