import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// A generic wrapper to hold a cached item and its timestamp.
///
/// This class is used to store any type of data [T] along with the
/// [DateTime] it was added to the cache, allowing for time-based
/// cache validation.
class CacheEntry<T> {
  /// Creates a [CacheEntry].
  const CacheEntry({
    required this.data,
    required this.cachedAt,
  });

  /// The cached data itself.
  final T data;

  /// The [DateTime] when the data was added to the cache.
  final DateTime cachedAt;

  /// Checks if the cache entry is still valid by comparing its age
  /// against a provided [maxAge] duration.
  ///
  /// Returns `true` if the entry is younger than the [maxAge],
  /// and `false` otherwise.
  bool isValid(Duration maxAge) => DateTime.now().difference(cachedAt) < maxAge;
}

/// A state object that holds all the cached data for the catalog feature.
///
/// This class acts as a centralized in-memory database for users, items,
/// and the results of specific item queries.
class CatalogCache {
  /// Creates a [CatalogCache], optionally with initial data.
  const CatalogCache({
    this.users = const {},
    this.items = const {},
    this.itemQueries = const {},
  });

  /// A map of cached users, where the key is the user's ID.
  final Map<String, CacheEntry<CatalogUser>> users;

  /// A map of cached catalog items, where the key is the item's ID.
  final Map<String, CacheEntry<CatalogItem>> items;

  /// A map of cached query results.
  ///
  /// The key is a unique string representing the query's parameters,
  /// and the value is a list of the item IDs that were returned.
  final Map<String, CacheEntry<List<String>>> itemQueries;

  /// Creates a new instance of [CatalogCache] with updated values.
  CatalogCache copyWith({
    Map<String, CacheEntry<CatalogUser>>? users,
    Map<String, CacheEntry<CatalogItem>>? items,
    Map<String, CacheEntry<List<String>>>? itemQueries,
  }) =>
      CatalogCache(
        users: users ?? this.users,
        items: items ?? this.items,
        itemQueries: itemQueries ?? this.itemQueries,
      );
}
