import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// A service class to manage catalog-related operations.
///
/// This class uses a [CatalogRepository] to fetch and manipulate catalog data.
class CatalogService {
  /// Creates a [CatalogService] with the given repository.
  CatalogService({required CatalogRepository repository})
      : _repository = repository;
  final CatalogRepository _repository;

  /// Retrieves catalog items, optionally applying filters.
  Future<List<CatalogItem>> getItems({
    Map<String, dynamic> filters = const {},
  }) async =>
      _repository.getItems(filters: filters);

  /// Toggles the favorite status of an item.
  Future<void> toggleFavorite(CatalogItem item) async =>
      _repository.toggleFavorite(item);
}
