import "package:flutter_catalog_interface/src/models/catalog_item.dart";
import "package:flutter_catalog_interface/src/models/lat_lng.dart";

/// The interface for interacting with the catalog.
abstract class CatalogRepository {

  /// Creates a new catalog item.
  ///
  /// [item] is a map representing the item to be created.
  Future<void> createCatalogItem(Map<String, dynamic> item);

  /// Fetches a list of catalog items.
  ///
  /// [userId] is required for personalized results or distance calculations.
  /// [userLocation] provides the GPS location for distance calculation.
  /// [filters] allow for filtering the items (e.g., by category).
  /// [limit] specifies the maximum number of items to return.
  /// [offset] specifies the starting index for pagination.
  Future<List<CatalogItem>> fetchCatalogItems({
    required String userId,
    LatLng? userLocation,
    Map<String, dynamic>? filters,
    int? limit,
    int? offset,
  });

  /// Fetches a single catalog item by its ID.
  ///
  /// [itemId] is the unique identifier of the catalog item.
  /// [userId] is the ID of the user requesting the item, used for personalized
  Future<CatalogItem?> fetchCatalogItemById(
    String itemId,
    String userId,
  );

  /// Toggles the favorite status of a catalog item for a specific user.
  ///
  /// [itemId] is the ID of the catalog item.
  /// [userId] is the ID of the user performing the action.
  Future<void> toggleFavorite(String itemId, String userId);
}
