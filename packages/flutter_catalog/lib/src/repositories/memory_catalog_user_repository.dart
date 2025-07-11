import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// An in-memory implementation of the [CatalogUserRepository].
///
/// Used for demonstration and testing purposes. It simulates fetching
/// user data from a predefined list.
class MemoryCatalogUserRepository implements CatalogUserRepository {
  final List<CatalogUser> _users = const [
    CatalogUser(
      id: "author_vic",
      name: "Victor",
      avatarUrl: "https://i.pravatar.cc/150?u=author_vic",
    ),
    CatalogUser(
      id: "author_mar",
      name: "Martijn",
      avatarUrl: "https://i.pravatar.cc/150?u=author_mar",
    ),
    CatalogUser(
      id: "author_jan",
      name: "Janneke",
      avatarUrl: "https://i.pravatar.cc/150?u=author_jan",
    ),
    CatalogUser(
      id: "author_eli",
      name: "Elisa",
      avatarUrl: "https://i.pravatar.cc/150?u=author_eli",
    ),
  ];

  @override
  Future<CatalogUser?> getUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _users.where((user) => user.id == userId).firstOrNull;
  }

  @override
  Future<List<CatalogUser>> getUsers(List<String> userIds) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _users.where((user) => userIds.contains(user.id)).toList();
  }
}
