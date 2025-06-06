import "package:dart_feed_utilities/src/filters/filters.dart";
import "package:rxdart/subjects.dart";

/// An in memory repository for retrieving one or multiple filters
class FilterMemoryRepository implements FilterRepository {
  final _filters = <String, Map<String, dynamic>>{
    "bool": <String, dynamic>{
      FilterModel.keys.id: "bool",
      FilterModel.keys.key: "completed",
      FilterModel.keys.name: "Completed",
      FilterModel.keys.imageUrl: "https://picsum.photos/seed/enabled/200",
      FilterModel.keys.type: BooleanSelectFilter.filterType,
      FilterModel.keys.metadata: {},
    },
    "range": <String, dynamic>{
      FilterModel.keys.id: "range",
      FilterModel.keys.key: "age",
      FilterModel.keys.name: "Age",
      FilterModel.keys.imageUrl: "https://picsum.photos/seed/age/200",
      FilterModel.keys.type: MinMaxIntFilter.filterType,
      FilterModel.keys.metadata: {
        "min": 0,
        "max": 100,
        "defaultValue": 50,
        "isRange": false,
      },
    },
    "slider": <String, dynamic>{
      FilterModel.keys.id: "slider",
      FilterModel.keys.key: "distance",
      FilterModel.keys.name: "Distance",
      FilterModel.keys.imageUrl: "https://picsum.photos/seed/distance/200",
      FilterModel.keys.type: MinMaxIntFilter.filterType,
      FilterModel.keys.metadata: {
        "min": 0,
        "max": 20,
        "defaultValue": 10,
        "isRange": true,
      },
    },
    "singleSelect": <String, dynamic>{
      FilterModel.keys.id: "singleSelect",
      FilterModel.keys.key: "object1",
      FilterModel.keys.name: "First Object",
      FilterModel.keys.imageUrl: "https://picsum.photos/seed/object/200",
      FilterModel.keys.type: DataSourceMultiSelectFilter.filterType,
      FilterModel.keys.metadata: {
        "datasource": "firebase:some-collection/some-document/categories",
        "isNested": false,
        "isSearchEnabled": false,
        "multiSelect": false,
      },
    },
    "multiSelect": <String, dynamic>{
      FilterModel.keys.id: "multiSelect",
      FilterModel.keys.key: "object2",
      FilterModel.keys.name: "Second Object",
      FilterModel.keys.imageUrl: "https://picsum.photos/seed/object/200",
      FilterModel.keys.type: DataSourceMultiSelectFilter.filterType,
      FilterModel.keys.metadata: {
        "datasource": "flat",
        "isNested": false,
        "isSearchEnabled": false,
        "multiSelect": true,
      },
    },
    "nestedMultiSelectSearchable": <String, dynamic>{
      FilterModel.keys.id: "nestedMultiSelectSearchable",
      FilterModel.keys.key: "animal",
      FilterModel.keys.name: "Animal",
      FilterModel.keys.imageUrl: "https://picsum.photos/seed/animal/200",
      FilterModel.keys.type: DataSourceMultiSelectFilter.filterType,
      FilterModel.keys.metadata: {
        "datasource": "linked",
        "isNested": true,
        "isSearchEnabled": true,
        "multiSelect": true,
      },
    },
  };

  @override
  Future<FilterModel> getFilter(String namespace, String filterId) async {
    var filter = _filters[filterId];
    if (filter == null) {
      throw FilterNotFoundException();
    }

    return FilterModel.fromMap(filter);
  }

  @override
  Future<List<FilterModel>> getFilters(String namespace) async =>
      _filters.values.map(FilterModel.fromMap).toList();
}

/// An in memory representation for a repository to store in memory data
class FilterValueMemoryRepository implements FilterValueRepository {
  final Map<String, Map<String, dynamic>> _currentFilters = {};
  late final _streamController =
      BehaviorSubject<Map<String, Map<String, dynamic>>>()
        ..add(_currentFilters);

  Map<String, dynamic> _getFilterForNamespace(String namespace) =>
      _currentFilters[namespace] ??= {};

  @override
  Future<void> clearFilterValues(String namespace) async {
    _getFilterForNamespace(namespace).clear();
    _streamController.add(_currentFilters);
  }

  @override
  Stream<Map<String, dynamic>> getFilterValues(String namespace) =>
      _streamController.stream
          .map((data) => data[namespace] ?? _getFilterForNamespace(namespace));

  @override
  Future<void> setFilterValue<T>(
    String namespace, {
    required String id,
    required T value,
  }) async {
    _getFilterForNamespace(namespace)[id] = value;
    _streamController.add(_currentFilters);
  }
}

/// an in memory data repository for retrieving dynamic filter data
class FilterDatasourceMemoryRepository implements FilterDataSourceRepository {
  /// Create an in memory data repository
  FilterDatasourceMemoryRepository();
  final _data = <String, List<LinkedFilterData>>{
    "flat": [
      const LinkedFilterData(key: "cat_1", name: "Cars"),
      const LinkedFilterData(key: "cat_2", name: "House"),
    ],
    "linked": [
      const LinkedFilterData(key: "nested_1", name: "Animals"),
      const LinkedFilterData(key: "nested_2", name: "Duck", parent: "nested_1"),
      const LinkedFilterData(key: "nested_3", name: "Dog", parent: "nested_1"),
      const LinkedFilterData(
        key: "nested_4",
        name: "Labrador",
        parent: "nested_3",
      ),
      const LinkedFilterData(
        key: "nested_5",
        name: "Dalmatian",
        parent: "nested_3",
      ),
      const LinkedFilterData(key: "nested_6", name: "Cat", parent: "nested_1"),
      const LinkedFilterData(key: "nested_7", name: "Lion", parent: "nested_6"),
    ],
  };

  @override
  Future<List<LinkedFilterData>> getLinkedDataFromSource(
    String namespace,
    String datasource,
  ) async =>
      _data[datasource] ?? [];

  @override
  Future<List<LinkedFilterData>> searchLinkedDataFromSource(
    String namespace,
    String datasource,
    String searchString,
  ) async {
    var allData = await getLinkedDataFromSource(namespace, datasource);

    var allMatches = allData.where((data) => data.name.contains(searchString));

    List<LinkedFilterData> withParents(LinkedFilterData data) {
      var parentId = data.parent;

      if (parentId == null) return [data];

      var foundParent =
          allData.where((data) => data.key == parentId).firstOrNull;

      if (foundParent == null) return [data];

      return [
        data,
        ...withParents(foundParent),
      ];
    }

    return [for (var match in allMatches) ...withParents(match)];
  }
}
