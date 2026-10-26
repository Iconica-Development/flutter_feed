import "dart:convert";

import "package:flutter_catalog_interface/flutter_catalog_interface.dart";
import "package:flutter_catalog_riverpod/src/cache_provider.dart";
import "package:riverpod/riverpod.dart";

/// A repository that adds a caching layer on top of a source
/// [CatalogRepository]. It is completely decoupled from any specific
/// implementation (e.g., REST, GraphQL).
class CachedCatalogItemRepository<T extends CatalogItem>
    implements CatalogRepository<T> {
  /// Creates a [CachedCatalogItemRepository].
  ///
  /// Requires a [sourceRepository] to fetch data from when the cache misses,
  /// a Riverpod [ref] to interact with the cache provider, and a
  /// [cacheDuration] to determine how long items stay valid in the cache.
  const CachedCatalogItemRepository({
    required this.sourceRepository,
    required this.ref,
    required this.cacheDuration,
  });

  /// The underlying repository to fetch data from.
  final CatalogRepository<T> sourceRepository;

  /// A reference to the Riverpod provider system.
  final Ref ref;

  /// The maximum duration for which a cached item is considered valid.
  final Duration cacheDuration;

  /// Creates a stable, unique key from the query parameters.
  String _generateQueryKey({
    String? userId,
    Map<String, dynamic>? filters,
    int? limit,
    int? offset,
  }) {
    var keyParts = {
      "userId": userId,
      "filters": filters,
      "limit": limit,
      "offset": offset,
    };
    var sortedJson = jsonEncode(
      keyParts,
      toEncodable: (o) => o is Map
          ? Map.fromEntries(
              o.entries.toList()
                ..sort((a, b) => a.key.toString().compareTo(b.key.toString())),
            )
          : o,
    );
    return sortedJson;
  }

  @override
  Future<T?> fetchCatalogItemById(String itemId, String userId) async {
    var cachedEntry = ref.read(catalogCacheProvider).items[itemId];
    if (cachedEntry != null && cachedEntry.isValid(cacheDuration)) {
      return cachedEntry.data as T;
    }

    var item = await sourceRepository.fetchCatalogItemById(itemId, userId);
    if (item != null) {
      ref.read(catalogCacheProvider.notifier).addItems([item]);
    }
    return item;
  }

  @override
  Future<List<T>> fetchCatalogItems({
    required String userId,
    LatLng? userLocation,
    Map<String, dynamic>? filters,
    int? limit,
    int? offset,
  }) async {
    var queryKey = _generateQueryKey(
      userId: userId,
      filters: filters,
      limit: limit,
      offset: offset,
    );
    var cachedQueryEntry = ref.read(catalogCacheProvider).itemQueries[queryKey];

    if (cachedQueryEntry != null && cachedQueryEntry.isValid(cacheDuration)) {
      var itemCache = ref.read(catalogCacheProvider).items;
      var cachedItemIds = cachedQueryEntry.data;
      var results = <T>[];
      var allItemsAreInCache = true;

      for (var itemId in cachedItemIds) {
        var itemEntry = itemCache[itemId];
        if (itemEntry != null && itemEntry.isValid(cacheDuration)) {
          results.add(itemEntry.data as T);
        } else {
          allItemsAreInCache = false;
          break;
        }
      }

      if (allItemsAreInCache) {
        return results;
      }
    }

    var items = await sourceRepository.fetchCatalogItems(
      userId: userId,
      userLocation: userLocation,
      filters: filters,
      limit: limit,
      offset: offset,
    );

    if (items.isNotEmpty) {
      ref.read(catalogCacheProvider.notifier).addItems(items);
      ref
          .read(catalogCacheProvider.notifier)
          .addItemQuery(queryKey, items.map((i) => i.id).toList());
    }

    return items;
  }

  @override
  Future<void> createCatalogItem(Map<String, dynamic> item) {
    ref.read(catalogCacheProvider.notifier).clear();
    return sourceRepository.createCatalogItem(item);
  }

  @override
  Future<void> updateCatalogItem(String itemId, Map<String, dynamic> item) {
    ref.read(catalogCacheProvider.notifier).clear();
    return sourceRepository.updateCatalogItem(itemId, item);
  }

  @override
  Future<void> deleteCatalogItem(String itemId) {
    ref.read(catalogCacheProvider.notifier).clear();
    return sourceRepository.deleteCatalogItem(itemId);
  }

  @override
  Future<void> toggleFavorite(String itemId, String userId) =>
      sourceRepository.toggleFavorite(itemId, userId);

  @override
  Future<String> uploadImage(XFile imageFile) =>
      sourceRepository.uploadImage(imageFile);
}
