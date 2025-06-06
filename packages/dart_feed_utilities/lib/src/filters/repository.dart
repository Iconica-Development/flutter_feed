import "package:dart_feed_utilities/src/filters/filters.dart";

/// A repository describing how to perform crud operations on filter types
abstract interface class FilterRepository {
  /// Retrieve all possible filters for the given [namespace]
  Future<List<FilterModel>> getFilters(String namespace);

  /// Get a specific filter
  Future<FilterModel> getFilter(String namespace, String filterId);
}

/// A repository describing how to perform crud operations on filter values
abstract interface class FilterValueRepository {
  /// Retrieve all filter values given the current namespace
  Stream<Map<String, dynamic>> getFilterValues(String namespace);

  /// Write a specific filter value for a given namespace
  Future<void> setFilterValue<T>(
    String namespace, {
    required String id,
    required T value,
  });

  /// Remove all currently set filter values in a given namespace
  Future<void> clearFilterValues(String namespace);
}

/// A repository indicating how to retrieve data for datasource based filters
// ignore: one_member_abstracts
abstract interface class FilterDataSourceRepository {
  /// Retrieves a linked dataset based on the given datasource
  Future<List<LinkedFilterData>> getLinkedDataFromSource(
    String namespace,
    String datasource,
  );

  /// Searches the dataset for a relevant result based on a searchquery
  Future<List<LinkedFilterData>> searchLinkedDataFromSource(
    String namespace,
    String datasource,
    String searchString,
  );
}
