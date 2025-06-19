// packages/flutter_catalog_rest_api/lib/src/rest_converters.dart
import "dart:convert"; // Still needed for jsonEncode in _NoOpConverter

import "package:dart_api_service/dart_api_service.dart";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// A pre-configured [ApiConverter] for decoding/encoding a list of [CatalogItem]s.
///
/// It leverages [ModelListJsonResponseConverter] from `dart_api_service`
/// to handle the JSON serialization and deserialization using
/// [CatalogItem.fromJson] and [CatalogItem.toJson].
ApiConverter<List<CatalogItem>, List<CatalogItem>> catalogItemsConverter =
    ModelListJsonResponseConverter(
  deserialize: CatalogItem.fromJson,
  serialize: (item) => item.toJson(),
);

/// A pre-configured [ApiConverter] for decoding/encoding a single [CatalogItem].
///
/// It leverages [ModelJsonResponseConverter] from `dart_api_service`
/// to handle the JSON serialization and deserialization using
/// [CatalogItem.fromJson] and [CatalogItem.toJson].
ApiConverter<CatalogItem, CatalogItem> catalogItemConverter =
    ModelJsonResponseConverter(
  deserialize: CatalogItem.fromJson,
  serialize: (item) => item.toJson(),
);

/// A simple [ApiConverter] for requests that do not expect a specific
/// response body, but can still encode a map for request bodies.
class NoOpConverter implements ApiConverter<void, Map<String, dynamic>> {
  /// Creates a [NoOpConverter].
  const NoOpConverter();

  @override
  void toRepresentation(Object? input) {}

  @override
  Object fromRepresentation(Map<String, dynamic> representation) =>
      jsonEncode(representation);
}
