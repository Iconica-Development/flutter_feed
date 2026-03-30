import "dart:convert";

import "package:dart_api_service/dart_api_service.dart";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// Creates an [ApiConverter] for a list of items that extend [CatalogItem].
///
/// This function is used to dynamically generate a converter for any given
/// type `T` that is a subclass of [CatalogItem]. It requires a `fromJson`
/// factory function to be passed in, which it uses to deserialize each
/// object in the JSON list.
ApiConverter<List<T>, List<T>>
    createCatalogItemsConverter<T extends CatalogItem>({
  required T Function(Map<String, dynamic>) fromJson,
}) =>
        ModelListJsonResponseConverter(
          deserialize: fromJson,
          serialize: (item) => item.toJson(),
        );

/// Creates an [ApiConverter] for a single item that extends [CatalogItem].
///
/// Similar to [createCatalogItemsConverter], but it handles single JSON objects
/// instead of lists. It's used for endpoints that return a single entity,
/// like fetching an item by its ID.
ApiConverter<T, T> createCatalogItemConverter<T extends CatalogItem>({
  required T Function(Map<String, dynamic>) fromJson,
}) =>
    ModelJsonResponseConverter(
      deserialize: fromJson,
      serialize: (item) => item.toJson(),
    );

/// An [ApiConverter] for API calls where the response body is not parsed,
/// but a request body needs to be sent as a JSON object.
///
/// The `toRepresentation` method is a no-op, returning `void` because
/// the response is ignored. The `fromRepresentation` method takes a
/// `Map<String, dynamic>` and encodes it into a JSON string for the request
/// body.
///
/// This is useful for `POST`, `PUT`, or `DELETE` requests that might return a
/// status code like 204 (No Content) with an empty response body.
class NoOpConverter implements ApiConverter<void, Map<String, dynamic>> {
  /// Creates an instance of [NoOpConverter].
  const NoOpConverter();

  /// Ignores the response body.
  @override
  void toRepresentation(Object? input) {}

  /// Encodes the outgoing [representation] map into a JSON string.
  @override
  Object fromRepresentation(Map<String, dynamic> representation) =>
      jsonEncode(representation);
}
