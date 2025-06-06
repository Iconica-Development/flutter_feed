import "package:dart_feed_utilities/src/filters/filters.dart";

/// A value representing the current state of a filter
class FilterValue<T> {
  /// Create a filter value
  const FilterValue({
    required this.filterId,
    required this.value,
  });

  /// The filter this is connected to
  final String filterId;

  /// The current value
  final T value;

  /// Get a transformed representation of this value
  FilterValue<R> transform<R>(R Function(T value) transformer) => FilterValue(
        filterId: filterId,
        value: transformer(value),
      );
}

/// A mapping between a [FilterModel] and a [FilterValue]
class FilterWithValue {
  /// Create a combination of a [FilterModel] and a [FilterValue]
  const FilterWithValue({
    required this.value,
    required this.filterModel,
  });

  /// The currently set value, if any
  final FilterValue? value;

  /// The model the value is related to
  final FilterModel filterModel;
}
