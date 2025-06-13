import "package:dart_feed_utilities/dart_feed_utilities.dart";

/// An in-memory implementation of [FilterRepository] that provides a set of
/// filters based on a standard catalog use case.
class CatalogMemoryFilterRepository implements FilterRepository {
  final _filters = <String, Map<String, dynamic>>{
    "search": <String, dynamic>{
      FilterModel.keys.id: "search",
      FilterModel.keys.key: "q",
      FilterModel.keys.name: "Search",
      FilterModel.keys.imageUrl: "",
      FilterModel.keys.type: "text",
      FilterModel.keys.metadata: {},
    },
    "condition": <String, dynamic>{
      FilterModel.keys.id: "condition",
      FilterModel.keys.key: "condition",
      FilterModel.keys.name: "Conditie",
      FilterModel.keys.imageUrl: "",
      FilterModel.keys.type: DataSourceMultiSelectFilter.filterType,
      FilterModel.keys.metadata: {
        "datasource": "conditions",
        "multiSelect": true,
        "isNested": false,
      },
    },
    "price_options": <String, dynamic>{
      FilterModel.keys.id: "price_options",
      FilterModel.keys.key: "price_options",
      FilterModel.keys.name: "Prijs",
      FilterModel.keys.imageUrl: "",
      FilterModel.keys.type: DataSourceMultiSelectFilter.filterType,
      FilterModel.keys.metadata: {
        "datasource": "price_options",
        "multiSelect": true,
        "isNested": false,
      },
    },
    "price_range": <String, dynamic>{
      FilterModel.keys.id: "price_range",
      FilterModel.keys.key: "price_range",
      FilterModel.keys.name: "Prijs (bereik)",
      FilterModel.keys.imageUrl: "",
      FilterModel.keys.type: MinMaxIntFilter.filterType,
      FilterModel.keys.metadata: {
        "min": 0,
        "max": 100,
        "defaultValue": 50,
        "isRange": true,
      },
    },
    "age": <String, dynamic>{
      FilterModel.keys.id: "age",
      FilterModel.keys.key: "age",
      FilterModel.keys.name: "Leeftijd",
      FilterModel.keys.imageUrl: "",
      FilterModel.keys.type: DataSourceMultiSelectFilter.filterType,
      FilterModel.keys.metadata: {
        "datasource": "age_ranges",
        "multiSelect": true,
        "isNested": false,
      },
    },
    "category": <String, dynamic>{
      FilterModel.keys.id: "category",
      FilterModel.keys.key: "category",
      FilterModel.keys.name: "Categorie",
      FilterModel.keys.imageUrl: "",
      FilterModel.keys.type: DataSourceMultiSelectFilter.filterType,
      FilterModel.keys.metadata: {
        "datasource": "categories",
        "multiSelect": true,
        "isNested": true,
        "isSearchEnabled": true,
      },
    },
    "brand": <String, dynamic>{
      FilterModel.keys.id: "brand",
      FilterModel.keys.key: "brand",
      FilterModel.keys.name: "Merk",
      FilterModel.keys.imageUrl: "",
      FilterModel.keys.type: DataSourceMultiSelectFilter.filterType,
      FilterModel.keys.metadata: {
        "datasource": "brands",
        "multiSelect": true,
        "isNested": false,
        "isSearchEnabled": true,
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

/// An in-memory implementation of [FilterDataSourceRepository] that provides
/// data for the filters defined in [CatalogMemoryFilterRepository].
class MemoryPlayhoodFilterDataSourceRepository
    implements FilterDataSourceRepository {
  final _data = <String, List<LinkedFilterData>>{
    "conditions": [
      const LinkedFilterData(key: "new", name: "Nieuw"),
      const LinkedFilterData(key: "as_new", name: "Zo goed als nieuw"),
      const LinkedFilterData(key: "good", name: "Gebruikt - goede staat"),
      const LinkedFilterData(
        key: "damaged",
        name: "Gebruikt - met schade of incompleet",
      ),
    ],
    "price_options": [
      const LinkedFilterData(key: "free", name: "Gratis op te halen"),
      const LinkedFilterData(key: "chat", name: "Prijs in overleg (via chat)"),
      const LinkedFilterData(key: "price", name: "Prijs"),
    ],
    "age_ranges": [
      const LinkedFilterData(key: "0-2", name: "0-2 jaar"),
      const LinkedFilterData(key: "2-4", name: "2-4 jaar"),
      const LinkedFilterData(key: "4-6", name: "4-6 jaar"),
      const LinkedFilterData(key: "6-8", name: "6-8 jaar"),
      const LinkedFilterData(key: "8-12", name: "8-12 jaar"),
      const LinkedFilterData(key: "12+", name: "12+ jaar"),
    ],
    "brands": [
      const LinkedFilterData(key: "barbie", name: "Barbie"),
      const LinkedFilterData(key: "brio", name: "Brio"),
      const LinkedFilterData(key: "chicco", name: "Chicco"),
      const LinkedFilterData(key: "duplo", name: "Duplo"),
      const LinkedFilterData(key: "fisher-price", name: "Fisher-Price"),
      const LinkedFilterData(key: "hot-wheels", name: "Hot Wheels"),
      const LinkedFilterData(key: "lego", name: "Lego"),
    ],
    "categories": [
      // Main Categories
      const LinkedFilterData(key: "indoor", name: "Binnenspeelgoed"),
      const LinkedFilterData(key: "outdoor", name: "Buitenspeelgoed"),

      // Outdoor Sub-categories
      const LinkedFilterData(
        key: "outdoor_vehicles",
        name: "Voertuigen & Mobiliteit",
        parent: "outdoor",
      ),
      const LinkedFilterData(
        key: "outdoor_action",
        name: "Sport & Actie",
        parent: "outdoor",
      ),
      const LinkedFilterData(
        key: "outdoor_climbing",
        name: "Klimmen, Glijden & Springen",
        parent: "outdoor",
      ),

      // Indoor Sub-categories
      const LinkedFilterData(
        key: "indoor_baby",
        name: "Baby & Peuter",
        parent: "indoor",
      ),
      const LinkedFilterData(
        key: "indoor_construction",
        name: "Bouw & Constructie",
        parent: "indoor",
      ),
      const LinkedFilterData(
        key: "indoor_creative",
        name: "Educatief & Creatief",
        parent: "indoor",
      ),
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
    if (searchString.isEmpty) return allData;

    return allData
        .where(
          (data) =>
              data.name.toLowerCase().contains(searchString.toLowerCase()),
        )
        .toList();
  }
}
