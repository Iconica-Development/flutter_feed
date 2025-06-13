import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// An in-memory implementation of the [CatalogRepository].
///
/// Used for demonstration and testing purposes.
class MemoryCatalogRepository implements CatalogRepository {
  final List<CatalogItem> _items = [
    const CatalogItem(
      id: "1",
      title: "Teddybeer",
      price: "€3,00",
      authorName: "Victor",
      distanceKm: 4.2,
      mediaUrls: ["https://picsum.photos/200/300"],
      isFavorite: false,
    ),
    CatalogItem(
      id: "2",
      title: "Treintje",
      price: "Gratis",
      authorName: "Martijn",
      distanceKm: 0.5,
      mediaUrls: ["https://picsum.photos/200/300"],
      isFavorite: true,
      description:
          "Product description. Lorem ipsum dolor sit amet, consectetur "
          "adipiscing elit, sed do eiusmod tempor incididunt ut "
          "labore et dolore magna.",
      postedAt: DateTime(2025, 6, 2),
    ),
    const CatalogItem(
      id: "3",
      title: "Legoblokkenset",
      price: "n.t.b.",
      authorName: "Janneke",
      distanceKm: 2.0,
      mediaUrls: ["https://picsum.photos/200/300"],
      isFavorite: false,
    ),
    const CatalogItem(
      id: "4",
      title: "Playmobil paard",
      price: "Gratis",
      authorName: "Elisa",
      distanceKm: 0.7,
      mediaUrls: ["https://picsum.photos/200/300"],
      isFavorite: false,
    ),
  ];

  @override
  Future<List<CatalogItem>> getItems({
    Map<String, dynamic> filters = const {},
    int? limit,
    int offset = 0,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    // In a real implementation, you would apply the filters here.
    return _items;
  }

  @override
  Future<void> toggleFavorite(CatalogItem item) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      var oldItem = _items[index];
      _items[index] = oldItem.copyWith(isFavorite: !oldItem.isFavorite);
    }
  }
}
