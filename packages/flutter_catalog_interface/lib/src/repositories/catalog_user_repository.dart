// ignore_for_file: one_member_abstracts

import "package:flutter_catalog_interface/src/models/catalog_user.dart";

/// The interface for fetching user data.
abstract class CatalogUserRepository<T extends CatalogUser> {
  /// Fetches a single user by their ID.
  Future<T?> getUser(String userId);

  /// Fetches a list of users by their IDs.
  Future<List<T>> getUsers(List<String> userIds);
}
