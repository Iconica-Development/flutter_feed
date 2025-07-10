import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// A service class to manage catalog-related operations.
///
/// This class is generic and uses a [CatalogRepository] to fetch and
/// manipulate catalog data of type T.
class CatalogService<T extends CatalogItem> {
  /// Creates a [CatalogService] with the given repository.
  CatalogService({
    required CatalogRepository<T> repository,
    required this.userId,
    required this.userLocation,
  }) : _repository = repository;

  final CatalogRepository<T> _repository;

  /// The ID of the user for whom catalog operations are performed.
  final String userId;

  /// The user's current location, if available.
  final LatLng? userLocation;

  /// Retrieves catalog items, optionally applying filters and user location.
  Future<List<T>> fetchCatalogItems({
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

  /// Toggles the favorite status of an item for the current user.
  Future<void> toggleFavorite(String itemId) async =>
      _repository.toggleFavorite(itemId, userId);

  /// Fetches a single catalog item by its ID.
  Future<T?> fetchCatalogItemById(String id) async =>
      _repository.fetchCatalogItemById(id, userId);

  /// Creates a new catalog item.
  Future<void> createCatalogItem(Map<String, dynamic> item) async {
    var dataWithLocation = Map<String, dynamic>.from(item);
    if (userLocation != null) {
      dataWithLocation["location"] = userLocation!.toJson();
    }
    return _repository.createCatalogItem(dataWithLocation);
  }

  /// Updates an existing catalog item by its ID.
  Future<void> updateCatalogItem(
    String itemId,
    Map<String, dynamic> item,
  ) async =>
      _repository.updateCatalogItem(itemId, item);

  /// Deletes a catalog item by its ID.
  Future<void> deleteCatalogItem(String itemId) async =>
      _repository.deleteCatalogItem(itemId);

  /// Uploads an image file.
  Future<String> uploadImage(XFile imageFile) async =>
      _repository.uploadImage(imageFile);
}
