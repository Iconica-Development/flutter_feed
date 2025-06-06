import "package:dart_feed_utilities/src/filters/filters.dart";

/// The default namespace if none are provided
const defaultFilterNamespace = "defaultFilters";

/// A service handling all filter related actions
class FilterService {
  /// Create a filter service
  FilterService({
    FilterRepository? filterRepository,
    FilterValueRepository? filterValueRepository,
    FilterDataSourceRepository? filterDataSourceRepository,
    String? namespace,
  })  : _filterDataSourceRepository =
            filterDataSourceRepository ?? FilterDatasourceMemoryRepository(),
        _namespace = namespace ?? defaultFilterNamespace,
        _filterValueRepository =
            filterValueRepository ?? FilterValueMemoryRepository(),
        _filterRepository = filterRepository ?? FilterMemoryRepository();

  final FilterRepository _filterRepository;
  final FilterValueRepository _filterValueRepository;
  final FilterDataSourceRepository _filterDataSourceRepository;
  final String _namespace;

  /// Get all filters
  Future<List<FilterModel>> getFilters() async =>
      _filterRepository.getFilters(_namespace);

  /// Get a binding between all filters and their values
  Stream<List<FilterWithValue>> getFiltersWithValues() =>
      getFilterValues().asyncMap(
        (values) async {
          var filters = await getFilters();
          return filters.map(
            (filter) {
              var filterValue = values
                  .where((value) => value.filterId == filter.id)
                  .firstOrNull;

              return FilterWithValue(
                value: filterValue?.transform(filter.deserializeValue),
                filterModel: filter,
              );
            },
          ).toList();
        },
      );

  /// Returns the linked data for the current filter
  Future<List<LinkedFilterData>> getDataForDatasource(
    String datasource,
  ) async =>
      _filterDataSourceRepository.getLinkedDataFromSource(
        _namespace,
        datasource,
      );

  /// Searches through the linked data with a given
  Future<List<LinkedFilterData>> searchLinkedData(
    String datasource,
    String search,
  ) async =>
      _filterDataSourceRepository.searchLinkedDataFromSource(
        _namespace,
        datasource,
        search,
      );

  /// Sets the current filter to the correct value
  Future<void> setFilterValue<T>(FilterModel<T> filter, T value) async {
    await _filterValueRepository.setFilterValue(
      _namespace,
      id: filter.id,
      value: filter.serializeValue(value),
    );
  }

  /// Get all values for the given filters
  ///
  /// This is an unserialized list, if you want to have the use-able
  Stream<List<FilterValue>> getFilterValues() =>
      _filterValueRepository.getFilterValues(_namespace).map(
            (dynamicMap) => dynamicMap.entries
                .map(
                  (entry) => FilterValue(
                    filterId: entry.key,
                    value: entry.value,
                  ),
                )
                .toList(),
          );
}

/// An extension to support query string and filtervalue validation
extension SerializeFilterValue on Iterable<FilterWithValue> {
  /// Transforms the filters to a serializable map
  Map<String, dynamic> toSerializedFilterMap() => {
        for (var filterWithValue in this) ...{
          if (filterWithValue.value != null)
            filterWithValue.filterModel.key: filterWithValue.filterModel
                .serializeValue(filterWithValue.value?.value),
        },
      };

  /// Transforms the filters to a query parameter string
  String toQueryParameters() => Uri(
        queryParameters: toSerializedFilterMap().map(
          (key, value) => MapEntry(
            key,
            switch (value) {
              Iterable list => list.map((item) => item.toString()),
              String s => s,
              num i => i.toString(),
              bool b => b.toString(),
              _ => null,
            },
          ),
        ),
      ).query;
}
