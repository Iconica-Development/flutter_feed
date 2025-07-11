import "package:dart_api_service/dart_api_service.dart" as http;
import "package:dart_api_service/dart_api_service.dart";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// An implementation of [CatalogUserRepository] that uses a RESTful API.
///
/// This repository is generic over `T` which must extend [CatalogUser],
/// allowing projects to use their own custom user models.
class RestCatalogUserRepository<T extends CatalogUser> extends HttpApiService<T>
    implements CatalogUserRepository<T> {
  /// Creates an instance of the [RestCatalogUserRepository].
  RestCatalogUserRepository({
    required super.baseUrl,
    required this.fromJsonFactory,
    super.authenticationService,
    super.client,
    super.defaultHeaders,
    this.apiPrefix = "",
    this.getUsersEndpoint = "/users",
    this.getUserEndpoint = "/users/:id",
  }) : super(
          // The converter now uses the provided factory.
          apiResponseConverter: ModelJsonResponseConverter(
            deserialize: fromJsonFactory,
            serialize: (user) => user.toJson(),
          ),
        );

  /// The factory function to create an instance of T from a JSON map.
  final T Function(Map<String, dynamic>) fromJsonFactory;

  /// The common prefix for all API endpoints in this repository.
  final String apiPrefix;

  /// The endpoint for fetching a list of users.
  final String getUsersEndpoint;

  /// The endpoint for fetching a user by their ID.
  final String getUserEndpoint;

  @override
  Future<T?> getUser(String userId) async {
    var userEndpoint = endpoint(apiPrefix)
        .child(getUserEndpoint)
        .authenticate()
        .withVariables({"id": userId});

    try {
      var response = await userEndpoint.get();
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
  Future<List<T>> getUsers(List<String> userIds) async {
    var listConverter = ModelListJsonResponseConverter<T, T>(
      deserialize: fromJsonFactory,
      serialize: (user) => user.toJson(),
    );

    var usersEndpoint = endpoint(apiPrefix)
        .child(getUsersEndpoint)
        .authenticate()
        .withConverter(listConverter);
    try {
      var response = await usersEndpoint.get(
        queryParameters: {"ids": userIds.join(",")},
      );
      return response.result ?? [];
    } on ApiException {
      rethrow;
    }
  }
}
