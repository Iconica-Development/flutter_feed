import "dart:convert";

import "package:dart_api_service/dart_api_service.dart";
import "package:dart_api_service/dart_api_service.dart" as http;
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";
import "package:flutter_catalog_rest_api/src/rest_converters.dart";

export "package:dart_api_service/dart_api_service.dart" show Client;

/// A generic implementation of [CatalogRepository] that uses a RESTful API.
///
/// This repository is generic over `T` which must be a type that extends
/// [CatalogItem]. This allows projects to use their own custom item models
/// while still leveraging this reusable repository.
///
/// For simple use cases with the base [CatalogItem], the `fromJsonFactory`
/// is not required. For custom subclasses of [CatalogItem], the factory
/// must be provided to ensure correct JSON deserialization.
class RestCatalogRepository<T extends CatalogItem>
    extends HttpApiService<List<T>> implements CatalogRepository<T> {
  /// Creates an instance of the [RestCatalogRepository].
  ///
  /// Requires a [baseUrl] for the API and can be configured with an optional
  /// [fromJsonFactory] for custom `CatalogItem` types.
  RestCatalogRepository({
    required super.baseUrl,
    T Function(Map<String, dynamic>)? fromJsonFactory,
    super.authenticationService,
    super.client,
    super.defaultHeaders,
    this.apiPrefix = "",
    this.fetchCatalogItemsEndpoint = "/catalog/catalog-items",
    this.fetchCatalogItemByIdEndpoint = "/catalog/catalog-items/:id",
    this.toggleFavoriteEndpoint = "/catalog/catalog-items/:itemId/favorite",
    this.createCatalogItemEndpoint = "/catalog/catalog-items",
  })  : fromJsonFactory = _getFromJsonFactory<T>(fromJsonFactory),
        super(
          apiResponseConverter: createCatalogItemsConverter<T>(
            fromJson: _getFromJsonFactory<T>(fromJsonFactory),
          ),
        );

  /// The factory function used to create an instance of `T` from a JSON map.
  final T Function(Map<String, dynamic>) fromJsonFactory;

  /// The common prefix for all API endpoints in this repository.
  final String apiPrefix;

  /// The endpoint for fetching a list of catalog items.
  final String fetchCatalogItemsEndpoint;

  /// The endpoint for fetching a single catalog item by its ID.
  final String fetchCatalogItemByIdEndpoint;

  /// The endpoint for toggling the favorite status of an item.
  final String toggleFavoriteEndpoint;

  /// The endpoint for creating a new catalog item.
  final String createCatalogItemEndpoint;

  /// A helper that provides a default `fromJson` factory for the base
  /// [CatalogItem] or throws an error if a factory is missing for a custom
  /// type.
  static U Function(Map<String, dynamic>)
      _getFromJsonFactory<U extends CatalogItem>(
    U Function(Map<String, dynamic>)? fromJson,
  ) {
    if (fromJson != null) {
      return fromJson;
    }
    if (U == CatalogItem) {
      return CatalogItem.fromJson as U Function(Map<String, dynamic>);
    }
    throw ArgumentError(
      "A fromJsonFactory must be provided for custom types like $U.",
      "fromJsonFactory",
    );
  }

  /// Returns a base [Endpoint] instance with the configured API prefix.
  Endpoint<List<T>, List<T>> get _baseEndpoint => endpoint(apiPrefix);

  @override
  Future<void> createCatalogItem(Map<String, dynamic> item) async {
    var createEndpoint = _baseEndpoint
        .child(createCatalogItemEndpoint)
        .authenticate()
        .withConverter(const NoOpConverter());

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
  Future<List<T>> fetchCatalogItems({
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
      var response =
          await catalogEndpoint.get(queryParameters: queryParameters);
      return response.result ?? [];
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
  Future<T?> fetchCatalogItemById(String id, String userId) async {
    var itemEndpoint = _baseEndpoint
        .child(fetchCatalogItemByIdEndpoint)
        .authenticate()
        .withVariables({"id": id}).withConverter(
      createCatalogItemConverter<T>(fromJson: fromJsonFactory),
    );

    try {
      var response = await itemEndpoint.get();
      return response.result;
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return null;
      }
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
        .withVariables({"itemId": itemId}).withConverter(const NoOpConverter());

    try {
      await favoriteEndpoint.post(requestModel: {"userId": userId});
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
