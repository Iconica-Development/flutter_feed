import 'package:flutter_catalog_interface/src/models/catalog_item.dart';

/// An abstract repository for managing catalog items.
///
/// This interface defines the contract for data sources that provide
/// catalog items.
abstract interface class CatalogRepository {
  /// Fetches a list of catalog items.
  ///
  /// Can be filtered by providing a [filters] map.
  /// Supports pagination through [limit] and [offset].
  Future<List<CatalogItem>> getItems({
    Map<String, dynamic> filters,
    int? limit,
    int offset = 0,
  });

  /// Toggles the favorite status of a given [item].
  Future<void> toggleFavorite(CatalogItem item);
}
