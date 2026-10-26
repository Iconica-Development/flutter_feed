import "package:flutter_catalog_interface/flutter_catalog_interface.dart";
import "package:flutter_catalog_riverpod/src/cache_provider.dart";
import "package:riverpod/riverpod.dart";

/// A decorator that adds a caching layer on top of a source
/// [CatalogUserRepository]. It is completely decoupled from any specific
/// implementation (e.g., REST, GraphQL).
class CachedCatalogUserRepository<T extends CatalogUser>
    implements CatalogUserRepository<T> {
  /// Creates a [CachedCatalogUserRepository].
  ///
  /// Requires a [sourceRepository] to fetch data from when the cache misses,
  /// a Riverpod [ref] to interact with the cache provider, and a
  /// [cacheDuration] to determine how long users stay valid in the cache.
  const CachedCatalogUserRepository({
    required this.sourceRepository,
    required this.ref,
    required this.cacheDuration,
  });

  /// The underlying repository to fetch data from.
  final CatalogUserRepository<T> sourceRepository;

  /// A reference to the Riverpod provider system.
  final Ref ref;

  /// The maximum duration for which a cached user is considered valid.
  final Duration cacheDuration;

  @override
  Future<T?> getUser(String userId) async {
    var cachedEntry = ref.read(catalogCacheProvider).users[userId];
    if (cachedEntry != null && cachedEntry.isValid(cacheDuration)) {
      return cachedEntry.data as T;
    }

    var user = await sourceRepository.getUser(userId);
    if (user != null) {
      ref.read(catalogCacheProvider.notifier).addUsers([user]);
    }
    return user;
  }

  @override
  Future<List<T>> getUsers(List<String> userIds) async {
    var cache = ref.read(catalogCacheProvider).users;
    var validCachedUsers = <T>[];
    var idsToFetch = <String>[];

    for (var id in userIds) {
      var entry = cache[id];
      if (entry != null && entry.isValid(cacheDuration)) {
        validCachedUsers.add(entry.data as T);
      } else {
        idsToFetch.add(id);
      }
    }

    if (idsToFetch.isNotEmpty) {
      var newUsers = await sourceRepository.getUsers(idsToFetch);
      if (newUsers.isNotEmpty) {
        ref.read(catalogCacheProvider.notifier).addUsers(newUsers);
        validCachedUsers.addAll(newUsers);
      }
    }

    return validCachedUsers;
  }
}
