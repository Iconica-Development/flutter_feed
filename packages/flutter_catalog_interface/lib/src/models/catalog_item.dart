import "package:flutter_catalog_interface/src/models/lat_lng.dart";

/// Represents the base data for an item in the catalog.
/// It contains fields that are common across different applications.
class CatalogItem {
  /// Creates a new [CatalogItem] instance.
  const CatalogItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.location,
    required this.postedAt,
    this.price,
    this.authorId,
    this.distanceKM,
    this.isFavorited,
  });

  /// Creates a [CatalogItem] from a JSON map.
  factory CatalogItem.fromJson(Map<String, dynamic> json) => CatalogItem(
        id: json["id"] as String,
        title: json["title"] as String,
        description: json["description"] as String,
        imageUrls: List<String>.from(json["imageUrls"] as List? ?? []),
        location: LatLng.fromJson(json["location"] as Map<String, dynamic>),
        postedAt: DateTime.parse(json["postedAt"] as String),
        price: (json["price"] as num?)?.toDouble(),
        authorId: json["authorId"] as String?,
        isFavorited: json["isFavorited"] as bool?,
      );

  /// The unique identifier for the catalog item.
  final String id;

  /// The title of the catalog item.
  final String title;

  /// A detailed description of the catalog item.
  final String description;

  /// A list of URLs pointing to images of the catalog item.
  final List<String> imageUrls;

  /// The geographical location of the catalog item.
  final LatLng location;

  /// The date and time when the catalog item was posted.
  final DateTime postedAt;

  /// The price of the catalog item.
  /// This field is optional and can be null.
  final double? price;

  /// The ID of the user who created or owns the catalog item.
  final String? authorId;

  /// The distance in kilometers from the user's location to the catalog item.
  final double? distanceKM;

  /// Indicates whether the catalog item is favorited by the user.
  final bool? isFavorited;

  /// Converts this [CatalogItem] to a JSON representation.
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "imageUrls": imageUrls,
        "location": location.toJson(),
        "postedAt": postedAt.toIso8601String(),
        if (price != null) "price": price,
        if (authorId != null) "authorId": authorId,
        if (isFavorited != null) "isFavorited": isFavorited,
      };

  //... copyWith, hashCode, and operator== methods would also be updated
  @override
  String toString() => "CatalogItem(id: $id, title: $title, "
      "description: $description, imageUrls: $imageUrls, location: "
      "$location,  postedAt: $postedAt, price: $price, authorId: "
      "$authorId, distanceKM: "
      "$distanceKM, isFavorited: $isFavorited)";

  /// Creates a copy of this [CatalogItem] with the given fields replaced.
  CatalogItem copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? imageUrls,
    LatLng? location,
    DateTime? postedAt,
    double? price,
    String? authorId,
    double? distanceKM,
    bool? isFavorited,
  }) =>
      CatalogItem(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        imageUrls: imageUrls ?? this.imageUrls,
        location: location ?? this.location,
        postedAt: postedAt ?? this.postedAt,
        price: price ?? this.price,
        authorId: authorId ?? this.authorId,
        distanceKM: distanceKM ?? this.distanceKM,
        isFavorited: isFavorited ?? this.isFavorited,
      );
}
