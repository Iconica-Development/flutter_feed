// ignore_for_file: public_member_api_docs

/// Represents a user in the catalog system.
class CatalogUser {
  const CatalogUser({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  /// Creates a [CatalogUser] from a JSON map.
  factory CatalogUser.fromJson(Map<String, dynamic> json) => CatalogUser(
        id: json["id"] as String,
        name: json["username"] as String,
        avatarUrl: json["avatar_url"] as String?,
      );

  final String id;
  final String name;
  final String? avatarUrl;

  /// Converts this object to a JSON map.
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": name,
        "avatar_url": avatarUrl,
      };

  /// Creates a copy of this user with the given fields replaced.
  CatalogUser copyWith({
    String? id,
    String? name,
    String? avatarUrl,
  }) =>
      CatalogUser(
        id: id ?? this.id,
        name: name ?? this.name,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );
}
