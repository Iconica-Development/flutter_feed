import "package:dart_feed_utilities/filters.dart";

/// Interface defining what a filter should adhere to.
abstract interface class FilterModel<T> {
  /// The identifier of this filter
  String get id;

  /// The displayname of the filter
  String get name;

  /// The key of the filter, as used in the serialized version
  String get key;

  /// An optional path to an image
  Uri? get imageUrl;

  /// The type of filter indicating the structure of the [metadata]
  String get type;

  /// Additional metadata for custom filters to use
  Map<String, dynamic> get metadata;

  /// Changing the current value to serializable object
  dynamic serializeValue(T value);

  /// Changing the serialized object to a useable value
  // ignore: avoid_annotating_with_dynamic
  T deserializeValue(dynamic serialized);

  /// If the current value is correct for this given filter
  // ignore: avoid_annotating_with_dynamic
  bool validateValue(dynamic value);

  /// The serialized keys of the default implementations for toMap and fromMap
  static const keys = (
    id: "id",
    name: "name",
    key: "key",
    imageUrl: "imageUrl",
    type: "type",
    metadata: "metadata",
  );

  /// Creates a specific type of filter from a map
  static FilterModel fromMap(Map<String, dynamic> map) {
    var innerModel = BaseFilterModel(
      id: map[keys.id],
      name: map[keys.name],
      key: map[keys.key],
      imageUrl: Uri.parse(map[keys.imageUrl]),
      type: map[keys.type],
      metadata: (map[keys.metadata] as Map).cast(),
    );

    return switch (innerModel.type) {
      MinMaxIntFilter.filterType => MinMaxIntFilter(
          filterModel: innerModel,
        ),
      DataSourceMultiSelectFilter.filterType => DataSourceMultiSelectFilter(
          filterModel: innerModel,
        ),
      BooleanSelectFilter.filterType => BooleanSelectFilter(
          filterModel: innerModel,
        ),
      TextFilter.filterType => TextFilter(
          filterModel: innerModel,
        ),
      _ => innerModel,
    };
  }
}

/// The minimal implementation of a filter
class BaseFilterModel implements FilterModel<dynamic> {
  /// Creates a minimal filter model
  ///
  /// If you need a custom functionality, instantiate one of the
  const BaseFilterModel({
    required this.id,
    required this.name,
    required this.key,
    required this.imageUrl,
    required this.type,
    required this.metadata,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final Uri imageUrl;
  @override
  final String type;
  @override
  final String key;
  @override
  final Map<String, dynamic> metadata;

  /// Creates the serialized representation of this filter
  Map<String, dynamic> toMap() => {
        FilterModel.keys.id: id,
        FilterModel.keys.name: name,
        FilterModel.keys.key: key,
        FilterModel.keys.imageUrl: imageUrl.toString(),
        FilterModel.keys.type: type,
        FilterModel.keys.metadata: metadata,
      };

  @override
  // ignore: avoid_annotating_with_dynamic
  dynamic deserializeValue(dynamic serialized) => serialized;

  @override
  // ignore: avoid_annotating_with_dynamic
  dynamic serializeValue(dynamic value) => value;

  @override
  // ignore: avoid_annotating_with_dynamic
  bool validateValue(dynamic value) => true;
}

/// A range filter
class MinMaxIntFilter implements FilterModel<(int, int?)> {
  /// Creates a range filter based on the internal filter model.
  ///
  /// For construction see [BaseFilterModel.fromMap]
  ///
  /// This constructor requires the inner [filterModel] to have metaData
  /// containing min, max, defaultValue and isRange;
  const MinMaxIntFilter({
    required this.filterModel,
  });

  /// The type of filter this is
  static const String filterType = "min-max-int";

  /// The inner filter model
  final BaseFilterModel filterModel;

  /// The minimum value retrieved from the metadata, defaults to
  int get min => filterModel.metadata["min"] as int? ?? 1;

  /// The maximum value retrieved from the metadata, defaults to 100.
  int get max => filterModel.metadata["max"] as int? ?? 100;

  /// The default value retrieved from the metadata, defaults to [min].
  int get defaultValue => filterModel.metadata["defaultValue"] as int? ?? min;

  /// Whether this is a range slider, defaults to false.
  bool get isRange => filterModel.metadata["isRange"] as bool? ?? false;

  @override
  String get id => filterModel.id;

  @override
  Uri get imageUrl => filterModel.imageUrl;

  @override
  Map<String, dynamic> get metadata => filterModel.metadata;

  @override
  String get name => filterModel.name;

  @override
  String get type => filterModel.type;

  @override
  // ignore: avoid_annotating_with_dynamic
  (int, int?) deserializeValue(dynamic serialized) {
    var deserialized = filterModel.deserializeValue(serialized);
    if (deserialized is! List<int>) {
      return (defaultValue, isRange ? defaultValue : null);
    }

    return (
      deserialized.firstOrNull ?? defaultValue,
      isRange ? deserialized.lastOrNull : null
    );
  }

  @override
  dynamic serializeValue((int, int?) value) {
    var (first, last) = value;
    return filterModel.serializeValue([
      first,
      if (last != null) last,
    ]);
  }

  @override
  // ignore: avoid_annotating_with_dynamic
  bool validateValue(dynamic value) {
    if (value is! (int, int?)) return false;

    var (first, last) = value;
    if (!isRange) {
      return first.clamp(min, max) == first;
    }
    if (last == null) return false;

    return first.clamp(min, last) == first && last.clamp(first, max) == last;
  }

  @override
  String get key => filterModel.key;
}

/// A multi-select filter based on a dynamic dataset
class DataSourceMultiSelectFilter implements FilterModel<List<String>> {
  /// Creates a range filter based on the internal filter model.
  ///
  /// For construction see [BaseFilterModel.fromMap]
  ///
  /// This constructor requires the inner [filterModel] to have metaData
  /// containing datasource and whether this is a multiSelect model
  const DataSourceMultiSelectFilter({
    required this.filterModel,
  });

  /// The type of filter
  static const String filterType = "datasource-multiselect";

  /// The inner filterModel
  final BaseFilterModel filterModel;

  /// A reference to a datasource, a connection string.
  ///
  /// The result of this datasource should contain an identifier and a name
  String get dataSource => filterModel.metadata["datasource"] as String;

  /// Whether this filter allows for multiple items
  bool get isMultiSelect =>
      filterModel.metadata["multiSelect"] as bool? ?? true;

  /// Whether this value deals with nested data
  bool get isNested => filterModel.metadata["isNested"] as bool? ?? false;

  /// Marks this filter to have a searchable dataset
  bool get isSearchEnabled =>
      filterModel.metadata["isSearchEnabled"] as bool? ?? false;

  @override
  String get id => filterModel.id;

  @override
  Uri get imageUrl => filterModel.imageUrl;

  @override
  Map<String, dynamic> get metadata => filterModel.metadata;

  @override
  String get name => filterModel.name;

  @override
  String get type => filterModel.type;

  @override
  String get key => filterModel.key;

  @override
  // ignore: avoid_annotating_with_dynamic
  List<String> deserializeValue(dynamic serialized) {
    var deserialized = filterModel.deserializeValue(serialized);
    if (deserialized is! List<String>) {
      return [];
    }

    return deserialized;
  }

  @override
  dynamic serializeValue(List<String> value) =>
      filterModel.serializeValue(value);

  @override
  // ignore: avoid_annotating_with_dynamic
  bool validateValue(dynamic value) =>
      value is List<String> &&
      value.isNotEmpty &&
      (value.length < 2 || isMultiSelect);

  /// Helper function to validate given responses to a dynamic dataset
  bool validateAnswers(List<String> answers, List<LinkedFilterData> data) {
    var allKeys = data.map((d) => d.key);
    return answers.every(allKeys.contains);
  }
}

/// A filter for toggling a filter on/off
class BooleanSelectFilter implements FilterModel<bool> {
  /// Creates a range filter based on the internal filter model.
  ///
  /// For construction see [BaseFilterModel.fromMap]
  ///
  /// This constructor requires no metadata to be available
  const BooleanSelectFilter({
    required this.filterModel,
  });

  /// The type of filter
  static const String filterType = "boolean";

  /// The inner filter model
  final BaseFilterModel filterModel;

  @override
  String get id => filterModel.id;

  @override
  Uri get imageUrl => filterModel.imageUrl;

  @override
  Map<String, dynamic> get metadata => filterModel.metadata;

  @override
  String get name => filterModel.name;

  @override
  String get type => filterModel.type;

  @override
  String get key => filterModel.key;

  @override
  // ignore: avoid_annotating_with_dynamic
  bool deserializeValue(dynamic serialized) {
    var deserialized = filterModel.deserializeValue(serialized);
    if (deserialized is! bool) {
      return false;
    }

    return deserialized;
  }

  @override
  dynamic serializeValue(bool value) => filterModel.serializeValue(value);

  @override
  // ignore: avoid_annotating_with_dynamic
  bool validateValue(dynamic value) => value is bool;
}

/// A filter for text input
class TextFilter implements FilterModel<String> {
  /// Creates a text filter based on the internal filter model.
  const TextFilter({
    required this.filterModel,
  });

  /// The type of filter this is
  static const String filterType = "text";

  /// The inner filter model
  final BaseFilterModel filterModel;

  @override
  String get id => filterModel.id;

  @override
  Uri get imageUrl => filterModel.imageUrl;

  @override
  Map<String, dynamic> get metadata => filterModel.metadata;

  @override
  String get name => filterModel.name;

  @override
  String get type => filterModel.type;

  @override
  String get key => filterModel.key;

  @override
  // ignore: avoid_annotating_with_dynamic
  String deserializeValue(dynamic serialized) {
    var deserialized = filterModel.deserializeValue(serialized);
    if (deserialized is! String) {
      return "";
    }

    return deserialized;
  }

  @override
  dynamic serializeValue(String value) => filterModel.serializeValue(value);

  @override
  // ignore: avoid_annotating_with_dynamic
  bool validateValue(dynamic value) => value is String;
}
