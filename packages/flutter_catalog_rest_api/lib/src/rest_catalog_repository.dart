import "dart:convert";

import "package:dart_api_service/dart_api_service.dart";
import "package:dart_api_service/dart_api_service.dart" as http;
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";
import "package:flutter_catalog_rest_api/src/rest_converters.dart";

export "package:dart_api_service/dart_api_service.dart" show Client;

/// An implementation of [CatalogRepository] that uses a RESTful API.
class RestCatalogRepository extends HttpApiService<List<CatalogItem>>
    implements CatalogRepository {
  /// Creates a [RestCatalogRepository].
  ///
  /// [baseUrl] is the base URL for the catalog API.
  RestCatalogRepository({
    required super.baseUrl,
    super.apiResponseConverter,
    super.authenticationService,
    super.client,
    super.defaultHeaders,
    this.apiPrefix = "",
    this.createCatalogItemEndpoint = "/catalog/catalog-items",
    this.fetchCatalogItemsEndpoint = "/catalog/catalog-items",
    this.fetchCatalogItemByIdEndpoint = "/catalog/catalog-items/:id",
    this.toggleFavoriteEndpoint = "/catalog/catalog-items/:itemId/favorite",
  });

  /// The prefix for the API endpoints.
  final String apiPrefix;

  /// Endpoint for creating a catalog item.
  final String createCatalogItemEndpoint;

  /// Endpoint for fetching catalog items.
  final String fetchCatalogItemsEndpoint;

  /// Endpoint for fetching a catalog item by its ID.
  final String fetchCatalogItemByIdEndpoint;

  /// Endpoint for toggling a catalog item's favorite status.
  final String toggleFavoriteEndpoint;

  Endpoint get _baseEndpoint => endpoint(apiPrefix);

  @override
  Future<void> createCatalogItem(Map<String, dynamic> item) async {
    var createEndpoint =
        _baseEndpoint.child(createCatalogItemEndpoint).authenticate();

    try {
      await createEndpoint.post(requestModel: item);
    } on ApiException {
      rethrow;
    } on Exception catch (e, s) {
      throw ApiException(
        inner: http.Response("Unexpected error: $e", 500),
        error: e,
        stackTrace: s,
      );
    }
  }

  @override
  Future<List<CatalogItem>> fetchCatalogItems({
    required String userId,
    LatLng? userLocation,
    Map<String, dynamic>? filters,
    int? limit,
    int? offset,
  }) async {
    var catalogEndpoint =
        _baseEndpoint.child(fetchCatalogItemsEndpoint).authenticate();

    var queryParameters = <String, dynamic>{"userId": userId};
    if (userLocation != null) {
      queryParameters["latitude"] = userLocation.latitude.toString();
      queryParameters["longitude"] = userLocation.longitude.toString();
    }
    if (filters != null) {
      queryParameters["filters"] = jsonEncode(filters);
    }
    if (limit != null) {
      queryParameters["limit"] = limit.toString();
    }
    if (offset != null) {
      queryParameters["offset"] = offset.toString();
    }

    try {
      var response = await catalogEndpoint.get(
        queryParameters: queryParameters,
      );

      if (response.result != null) {
        return response.result!;
      } else {
        throw ApiException(
          inner: response.inner,
          error: "No catalog items found, but request succeeded.",
        );
      }
    } on ApiException {
      rethrow;
    } on Exception catch (e, s) {
      throw ApiException(
        inner: http.Response("Unexpected error: $e", 500),
        error: e,
        stackTrace: s,
      );
    }
  }

  @override
  Future<CatalogItem?> fetchCatalogItemById(String id, String userId) async {
    var itemEndpoint = _baseEndpoint
        .child(fetchCatalogItemByIdEndpoint)
        .authenticate()
        .withVariables({"id": id}).withConverter(catalogItemConverter);

    try {
      var response = await itemEndpoint.get();

      if (response.statusCode == 200 && response.result != null) {
        return response.result!;
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw ApiException(inner: response.inner);
      }
    } on ApiException {
      rethrow;
    } on Exception catch (e, s) {
      throw ApiException(
        inner: http.Response("Unexpected error: $e", 500),
        error: e,
        stackTrace: s,
      );
    }
  }

  @override
  Future<void> toggleFavorite(String itemId, String userId) async {
    var favoriteEndpoint = _baseEndpoint
        .child(toggleFavoriteEndpoint)
        .authenticate()
        .withVariables({"itemId": itemId}).withConverter(
      const NoOpConverter(),
    );

    try {
      await favoriteEndpoint.post(
        requestModel: {"userId": userId},
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e, s) {
      throw ApiException(
        inner: http.Response("Unexpected error: $e", 500),
        error: e,
        stackTrace: s,
      );
    }
  }
}
