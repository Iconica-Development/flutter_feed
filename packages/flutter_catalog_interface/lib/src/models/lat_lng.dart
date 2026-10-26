/// Represents a geographical point with latitude and longitude.
class LatLng {
  /// Creates a [LatLng] instance.
  const LatLng({
    required this.latitude,
    required this.longitude,
  });

  /// Creates a [LatLng] from a JSON map.
  factory LatLng.fromJson(Map<String, dynamic> json) => LatLng(
        latitude: (json["latitude"] as num).toDouble(),
        longitude: (json["longitude"] as num).toDouble(),
      );

  /// The latitude of the geographical point.
  final double latitude;

  /// The longitude of the geographical point.
  final double longitude;

  /// Converts this [LatLng] instance to a JSON map.
  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LatLng &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() => "LatLng(latitude: $latitude, longitude: $longitude)";
}
