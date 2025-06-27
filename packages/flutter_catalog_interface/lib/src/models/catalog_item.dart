import "package:flutter_catalog_interface/src/models/lat_lng.dart";

/// Represents an item in the catalog.
class CatalogItem {
  /// Creates a [CatalogItem] instance.
  const CatalogItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.location,
    required this.price,
    required this.postedAt,
    this.authorId,
    this.authorName,
    this.authorProfileImageUrl,
    this.distanceKM,
    this.isFavorited,
  });

  /// Creates a [CatalogItem] from a JSON map.
  factory CatalogItem.fromJson(Map<String, dynamic> json) => CatalogItem(
        id: json["id"] as String,
        title: json["title"] as String,
        description: json["description"] as String,
        imageUrls: List<String>.from(json["imageUrls"] as List),
        location: LatLng.fromJson(json["location"] as Map<String, dynamic>),
        price: (json["price"] as num).toDouble(),
        postedAt: DateTime.parse(json["postedAt"] as String),
        authorId: json["authorId"] as String?,
        authorName: json["authorName"] as String?,
        authorProfileImageUrl: json["authorProfileImageUrl"] as String?,
        distanceKM: (json["distanceKM"] as num?)?.toDouble(),
        isFavorited: json["isFavorited"] as bool?,
      );

  /// The unique identifier of the catalog item.
  final String id;

  /// The title of the catalog item.
  final String title;

  /// The description of the catalog item.
  final String description;

  /// A list of URLs for images of the catalog item.
  final List<String> imageUrls;

  /// The geographical location of the catalog item.
  final LatLng location;

  /// The price of the catalog item.
  final double price;

  /// The time and date when the catalog item was posted.
  final DateTime postedAt;

  /// The optional ID of the author of the catalog item.
  final String? authorId;

  /// The optional name of the author of the catalog item.
  final String? authorName;

  /// The optional profile image URL of the author.
  final String? authorProfileImageUrl;

  /// The distance in kilometers from a reference point.
  final double? distanceKM;

  /// Indicates if the item is favorited by the current user.
  ///
  /// This value is determined by the backend based on the user
  /// making the request.
  final bool? isFavorited;

  /// Converts this [CatalogItem] instance to a JSON map.
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "imageUrls": imageUrls,
        "location": location.toJson(),
        "price": price,
        "postedAt": postedAt.toIso8601String(),
        if (authorId != null) "authorId": authorId,
        if (authorName != null) "authorName": authorName,
        if (authorProfileImageUrl != null)
          "authorProfileImageUrl": authorProfileImageUrl,
        if (distanceKM != null) "distanceKM": distanceKM,
        if (isFavorited != null) "isFavorited": isFavorited,
      };

  /// Creates a copy of this [CatalogItem] with the given properties replaced.
  /// If a property is not provided, the original value is retained.
  CatalogItem copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? imageUrls,
    LatLng? location,
    double? price,
    DateTime? postedAt,
    String? authorId,
    String? authorName,
    String? authorProfileImageUrl,
    double? distanceKM,
    bool? isFavorited,
  }) =>
      CatalogItem(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        imageUrls: imageUrls ?? this.imageUrls,
        location: location ?? this.location,
        price: price ?? this.price,
        postedAt: postedAt ?? this.postedAt,
        authorId: authorId ?? this.authorId,
        authorName: authorName ?? this.authorName,
        authorProfileImageUrl:
            authorProfileImageUrl ?? this.authorProfileImageUrl,
        distanceKM: distanceKM ?? this.distanceKM,
        isFavorited: isFavorited ?? this.isFavorited,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CatalogItem &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        _listEquals(other.imageUrls, imageUrls) &&
        other.location == location &&
        other.price == price &&
        other.postedAt == postedAt &&
        other.authorId == authorId &&
        other.authorName == authorName &&
        other.authorProfileImageUrl == authorProfileImageUrl &&
        other.distanceKM == distanceKM &&
        other.isFavorited == isFavorited;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      Object.hashAll(imageUrls) ^
      location.hashCode ^
      price.hashCode ^
      postedAt.hashCode ^
      authorId.hashCode ^
      authorName.hashCode ^
      authorProfileImageUrl.hashCode ^
      distanceKM.hashCode ^
      isFavorited.hashCode;

  @override
  String toString() => "CatalogItem(id: $id, title: $title, description: "
      "$description, imageUrls: $imageUrls, location: $location, "
      "price: $price, postedAt: $postedAt, authorId: $authorId, "
      "authorName: $authorName, authorProfileImageUrl: "
      "$authorProfileImageUrl, distanceKM: $distanceKM, "
      "isFavorited: $isFavorited)";

  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
