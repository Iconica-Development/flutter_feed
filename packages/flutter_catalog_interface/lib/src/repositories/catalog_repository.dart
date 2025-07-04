import "package:cross_file/cross_file.dart";
import "package:flutter_catalog_interface/src/models/catalog_item.dart";
import "package:flutter_catalog_interface/src/models/lat_lng.dart";

/// The interface for interacting with the catalog.
abstract class CatalogRepository<T extends CatalogItem> {
  /// Creates a new catalog item from a map.
  Future<void> createCatalogItem(Map<String, dynamic> item);

  /// Uploads an image from an [XFile] object and returns its public URL.
  Future<String> uploadImage(XFile imageFile);

  /// Fetches a list of catalog items.
  ///
  /// [userId] is required for personalized results or distance calculations.
  /// [userLocation] provides the GPS location for distance calculation.
  /// [filters] allow for filtering the items (e.g., by category).
  /// [limit] specifies the maximum number of items to return.
  /// [offset] specifies the starting index for pagination.
  Future<List<T>> fetchCatalogItems({
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
  Future<T?> fetchCatalogItemById(
    String itemId,
    String userId,
  );

  /// Toggles the favorite status of a catalog item for a specific user.
  ///
  /// [itemId] is the ID of the catalog item.
  /// [userId] is the ID of the user performing the action.
  Future<void> toggleFavorite(String itemId, String userId);
}
