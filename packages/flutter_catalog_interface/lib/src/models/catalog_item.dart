/// Represents a single item within the catalog.
///
/// This class holds all the data necessary to display a catalog item in
/// both the overview grid and the detail view.
class CatalogItem {
  /// The unique identifier for the catalog item.
  final String id;

  /// The title or name of the item.
  final String title;

  /// A list of URLs for the item's images.
  final List<String> mediaUrls;

  /// The detailed description of the item.
  final String? description;

  /// The price of the item, formatted as a string (e.g., "€3,00", "Gratis").
  final String price;

  /// The name of the user who posted the item.
  final String? authorName;

  /// The URL for the author's avatar image.
  final String? authorAvatarUrl;

  /// The distance of the item from the user in kilometers.
  final double? distanceKm;

  /// Indicates whether the current user has marked this item as a favorite.
  final bool isFavorite;

  /// The date and time when the item was posted.
  final DateTime? postedAt;

  const CatalogItem({
    required this.id,
    required this.title,
    required this.mediaUrls,
    this.description,
    required this.price,
    this.authorName,
    this.authorAvatarUrl,
    this.distanceKm,
    this.isFavorite = false,
    this.postedAt,
  });

  /// Creates a copy of this [CatalogItem] but with the given fields
  /// replaced with the new values.
  CatalogItem copyWith({
    String? id,
    String? title,
    List<String>? mediaUrls,
    String? description,
    String? price,
    String? authorName,
    String? authorAvatarUrl,
    double? distanceKm,
    bool? isFavorite,
    DateTime? postedAt,
  }) {
    return CatalogItem(
      id: id ?? this.id,
      title: title ?? this.title,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      description: description ?? this.description,
      price: price ?? this.price,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      distanceKm: distanceKm ?? this.distanceKm,
      isFavorite: isFavorite ?? this.isFavorite,
      postedAt: postedAt ?? this.postedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatalogItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
