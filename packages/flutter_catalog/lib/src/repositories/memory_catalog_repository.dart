import "dart:math";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// An in-memory implementation of the [CatalogInterface].
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
      authorName: "Victor",
      authorProfileImageUrl: "https://picsum.photos/id/1005/50/50",
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
      authorName: "Martijn",
      authorProfileImageUrl: "https://picsum.photos/id/1011/50/50",
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
      authorName: "Janneke",
      authorProfileImageUrl: "https://picsum.photos/id/1012/50/50",
      location: const LatLng(latitude: 51.975, longitude: 5.920),
      imageUrls: const ["https://picsum.photos/seed/lego/200/300"],
      postedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    CatalogItem(
      id: "4",
      title: "Playmobil paard",
      description:
          "Playmobil horse with accessories, perfect for imaginative play.",
      price: 0.00,
      authorId: "author_eli",
      authorName: "Elisa",
      authorProfileImageUrl: "https://picsum.photos/id/1015/50/50",
      location: const LatLng(latitude: 51.990, longitude: 5.905),
      imageUrls: const ["https://picsum.photos/seed/playmobil/200/300"],
      postedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    CatalogItem(
      id: "5",
      title: "Fiets",
      description: "Adult's bicycle, well-maintained and ready to ride.",
      price: 50.00,
      authorId: "author_kla",
      authorName: "Klaas",
      authorProfileImageUrl: "https://picsum.photos/id/1016/50/50",
      location: const LatLng(latitude: 51.970, longitude: 5.915),
      imageUrls: const ["https://picsum.photos/seed/bike/200/300"],
      postedAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    CatalogItem(
      id: "6",
      title: "Boek",
      description: "A novel for young adults, great condition.",
      price: 10.00,
      authorId: "author_san",
      authorName: "Sanne",
      authorProfileImageUrl: "https://picsum.photos/id/1018/50/50",
      location: const LatLng(latitude: 51.988, longitude: 5.900),
      imageUrls: const ["https://picsum.photos/seed/book/200/300"],
      postedAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    CatalogItem(
      id: "7",
      title: "Bordspel",
      description: "Popular family board game, complete with all pieces.",
      price: 15.00,
      authorId: "author_pie",
      authorName: "Piet",
      authorProfileImageUrl: "https://picsum.photos/id/1020/50/50",
      location: const LatLng(latitude: 51.995, longitude: 5.925),
      imageUrls: const ["https://picsum.photos/seed/game/200/300"],
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    CatalogItem(
      id: "8",
      title: "Kleding",
      description: "Assortment of pre-loved clothes, various sizes.",
      price: 0.00,
      authorId: "author_ann",
      authorName: "Anna",
      authorProfileImageUrl: "https://picsum.photos/id/1024/50/50",
      location: const LatLng(latitude: 51.970, longitude: 5.908),
      imageUrls: const ["https://picsum.photos/seed/clothes/200/300"],
      postedAt: DateTime.now().subtract(const Duration(hours: 3)),
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

    // Apply query filter (if 'q' is present in filters)
    if (filters != null && filters.containsKey("q")) {
      var query = filters["q"].toString().toLowerCase();
      if (query.isNotEmpty) {
        itemsToProcess = itemsToProcess
            .where((item) => item.title.toLowerCase().contains(query))
            .toList();
      }
    }

    // Apply dynamic properties like isFavorited and distanceKM
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

    // Apply pagination (offset and limit)
    var startIndex = offset ?? 0;
    var endIndex = (limit != null)
        ? min(startIndex + limit, itemsToProcess.length)
        : itemsToProcess.length;

    if (startIndex >= itemsToProcess.length) {
      return [];
    }

    var paginatedItems = itemsToProcess.sublist(startIndex, endIndex);

    return paginatedItems;
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

  /// Calculates the distance between two LatLng points in kilometers
  /// (Haversine formula).
  double _calculateDistance(LatLng point1, LatLng point2) {
    const earthRadiusKm = 6371; // Earth's radius in kilometers

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
