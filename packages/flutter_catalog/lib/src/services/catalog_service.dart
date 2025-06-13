import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// A service class to manage catalog-related operations.
///
/// This class uses a [CatalogRepository] to fetch and manipulate catalog data.
class CatalogService {
  /// Creates a [CatalogService] with the given repository.
  CatalogService({
    required CatalogRepository repository,
    required this.userId,
  }) : _repository = repository;

  final CatalogRepository _repository;

  /// The ID of the user for whom catalog operations are performed.
  final String userId;

  /// Retrieves catalog items, optionally applying filters, user location,
  /// pagination, and filtered by user.
  ///
  /// [userId] is required for personalized results or distance calculations.
  /// [userLocation] provides the GPS location for distance calculation.
  /// [filters] allow for filtering the items (e.g., by category).
  /// [limit] specifies the maximum number of items to return.
  /// [offset] specifies the starting index for pagination.
  Future<List<CatalogItem>> fetchCatalogItems({
    LatLng? userLocation,
    Map<String, dynamic>? filters,
    int? limit,
    int? offset,
  }) async =>
      _repository.fetchCatalogItems(
        userId: userId,
        userLocation: userLocation,
        filters: filters,
        limit: limit,
        offset: offset,
      );

  /// Toggles the favorite status of an item for a specific user.
  ///
  /// [itemId] is the ID of the catalog item.
  Future<void> toggleFavorite(
    String itemId,
  ) async =>
      _repository.toggleFavorite(itemId, userId);

  /// Fetches a single catalog item by its ID.
  Future<CatalogItem?> fetchCatalogItemById(String id) async =>
      _repository.fetchCatalogItemById(id, userId);
}
