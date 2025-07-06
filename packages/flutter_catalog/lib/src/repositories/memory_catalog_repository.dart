import "dart:math";
import "package:cross_file/cross_file.dart";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// An in-memory implementation of the [CatalogRepository].
///
/// Used for demonstration and testing purposes. It simulates data fetching
/// and basic operations for catalog items, including per-user favorites
/// and distance calculation based on a provided user location.
class MemoryCatalogRepository implements CatalogRepository {
  final List<CatalogItem> _baseItems = [
    CatalogItem(
      id: "1",
      title: "Teddybeer",
      description: "A soft and cuddly teddy bear for all ages.",
      price: 3.00,
      authorId: "author_vic",
      location: const LatLng(latitude: 51.980, longitude: 5.910),
      imageUrls: const ["https://picsum.photos/seed/teddy/200/300"],
      postedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    CatalogItem(
      id: "2",
      title: "Treintje",
      description:
          "Product description. Lorem ipsum dolor sit amet, consectetur "
          "adipiscing elit, sed do eiusmod tempor incididunt ut "
          "labore et dolore magna.",
      price: 0.00,
      authorId: "author_mar",
      location: const LatLng(latitude: 51.985, longitude: 5.914),
      imageUrls: const ["https://picsum.photos/seed/train/200/300"],
      postedAt: DateTime(2025, 6, 2),
    ),
    CatalogItem(
      id: "3",
      title: "Legoblokkenset",
      description: "Large set of colorful Lego blocks for creative building.",
      price: 0.00,
      authorId: "author_jan",
      location: const LatLng(latitude: 51.975, longitude: 5.920),
      imageUrls: const ["https://picsum.photos/seed/lego/200/300"],
      postedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  final Map<String, Set<String>> _userFavorites = {};

  @override
  Future<List<CatalogItem>> fetchCatalogItems({
    required String userId,
    LatLng? userLocation,
    Map<String, dynamic>? filters,
    int? limit,
    int? offset,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var itemsToProcess = List<CatalogItem>.from(_baseItems);

    if (filters != null && filters.containsKey("q")) {
      var query = filters["q"].toString().toLowerCase();
      if (query.isNotEmpty) {
        itemsToProcess = itemsToProcess
            .where((item) => item.title.toLowerCase().contains(query))
            .toList();
      }
    }

    itemsToProcess = itemsToProcess.map((item) {
      var isItemFavorited = _userFavorites[userId]?.contains(item.id) ?? false;
      double? calculatedDistanceKm;

      if (userLocation != null) {
        calculatedDistanceKm = _calculateDistance(userLocation, item.location);
      }

      return item.copyWith(
        isFavorited: isItemFavorited,
        distanceKM: calculatedDistanceKm,
      );
    }).toList();

    var startIndex = offset ?? 0;
    var endIndex = (limit != null)
        ? min(startIndex + limit, itemsToProcess.length)
        : itemsToProcess.length;

    if (startIndex >= itemsToProcess.length) {
      return [];
    }

    return itemsToProcess.sublist(startIndex, endIndex);
  }

  @override
  Future<CatalogItem?> fetchCatalogItemById(String id, String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _baseItems.where((item) => item.id == id).firstOrNull;
  }

  @override
  Future<void> toggleFavorite(String itemId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (!_userFavorites.containsKey(userId)) {
      _userFavorites[userId] = {};
    }

    var isCurrentlyFavorite = _userFavorites[userId]!.contains(itemId);

    if (isCurrentlyFavorite) {
      _userFavorites[userId]!.remove(itemId);
    } else {
      _userFavorites[userId]!.add(itemId);
    }
  }

  @override
  Future<String> uploadImage(XFile imageFile) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return "https://example.com/images/${imageFile.name}";
  }

  @override
  Future<void> createCatalogItem(Map<String, dynamic> item) async {
    await Future.delayed(const Duration(milliseconds: 400));

    var newItem = CatalogItem(
      id: Random().nextInt(99999).toString(),
      title: item["title"] ?? "No Title",
      description: item["description"] ?? "",
      imageUrls: List<String>.from(item["image_urls"] as List? ?? []),
      price: (item["price"] as num?)?.toDouble(),
      location: const LatLng(latitude: 51.98, longitude: 5.91),
      postedAt: DateTime.now(),
      authorId: item["authorId"],
    );

    _baseItems.insert(0, newItem);
  }

  @override
  Future<void> updateCatalogItem(
    String itemId,
    Map<String, dynamic> item,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    var index = _baseItems.indexWhere((i) => i.id == itemId);
    if (index != -1) {
      var existingItem = _baseItems[index];
      // Create a new item by applying the updates to the existing one.
      var updatedItem = existingItem.copyWith(
        title: item["title"] ?? existingItem.title,
        description: item["description"] ?? existingItem.description,
        price: item.containsKey("price")
            ? (item["price"] as num?)?.toDouble()
            : existingItem.price,
        imageUrls: item.containsKey("image_urls")
            ? List<String>.from(item["image_urls"])
            : existingItem.imageUrls,
      );
      _baseItems[index] = updatedItem;
    }
  }

  @override
  Future<void> deleteCatalogItem(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _baseItems.removeWhere((item) => item.id == itemId);
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const earthRadiusKm = 6371;
    var lat1Rad = _degreesToRadians(point1.latitude);
    var lon1Rad = _degreesToRadians(point1.longitude);
    var lat2Rad = _degreesToRadians(point2.latitude);
    var lon2Rad = _degreesToRadians(point2.longitude);

    var dLat = lat2Rad - lat1Rad;
    var dLon = lon2Rad - lon1Rad;

    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) => degrees * pi / 180;
}
