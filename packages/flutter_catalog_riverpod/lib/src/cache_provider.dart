import "package:flutter_catalog_interface/flutter_catalog_interface.dart";
import "package:flutter_catalog_riverpod/src/cache.dart";
import "package:riverpod/riverpod.dart";

/// A Riverpod notifier to manage the in-memory cache for the catalog.
///
/// This class holds the state for cached users and items and provides
/// methods to add new data to the cache or clear it entirely.
class CatalogCacheNotifier extends StateNotifier<CatalogCache> {
  /// Creates a [CatalogCacheNotifier] with an initial empty cache.
  CatalogCacheNotifier() : super(const CatalogCache());

  /// Adds a list of [CatalogUser] objects to the cache.
  ///
  /// If a user with the same ID already exists in the cache, it will be
  /// overwritten with the new data.
  void addUsers(List<CatalogUser> users) {
    state = state.copyWith(
      users: {
        ...state.users,
        for (var user in users)
          user.id: CacheEntry(data: user, cachedAt: DateTime.now()),
      },
    );
  }

  /// Adds a list of [CatalogItem] objects to the cache.
  ///
  /// If an item with the same ID already exists, it will be overwritten.
  void addItems(List<CatalogItem> items) {
    state = state.copyWith(
      items: {
        ...state.items,
        for (var item in items)
          item.id: CacheEntry(data: item, cachedAt: DateTime.now()),
      },
    );
  }

  /// Caches the result of an item query.
  ///
  /// The [queryKey] should be a unique identifier representing the specific
  /// query parameters, and [itemIds] is the list of item IDs that were
  /// returned for that query.
  void addItemQuery(String queryKey, List<String> itemIds) {
    state = state.copyWith(
      itemQueries: {
        ...state.itemQueries,
        queryKey: CacheEntry(data: itemIds, cachedAt: DateTime.now()),
      },
    );
  }

  /// Instantly clears all cached data, resetting the state to be empty.
  ///
  /// This is useful for events like user logout.
  void clear() {
    state = const CatalogCache();
  }
}

/// A global provider that exposes the [CatalogCacheNotifier] to the app.
///
/// Widgets can use this provider to read from the cache or to call methods
/// on the notifier to update the cache.
final catalogCacheProvider =
    StateNotifierProvider<CatalogCacheNotifier, CatalogCache>(
  (ref) => CatalogCacheNotifier(),
);
