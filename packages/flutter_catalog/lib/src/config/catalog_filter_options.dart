import "package:dart_feed_utilities/dart_feed_utilities.dart";

/// A function that takes a localization key and returns a translated string.
typedef Translator = String Function(String key);

/// A configuration class for managing filter-related repositories and options.
class FilterOptions {
  /// Constructs a [FilterOptions].
  const FilterOptions({
    this.showFiltersInOverview = true,
    this.showSearchInOverview = true,
    this.filterRepository,
    this.filterValueRepository,
    this.filterDataSourceRepository,
    this.namespace,
    this.translator,
  });

  /// Whether to show the filters in the overview screen.
  /// If disabled the filter section on the overview screen will not be
  /// displayed
  final bool showFiltersInOverview;

  /// Whether to show the search bar in the overview screen's AppBar.
  /// Defaults to true.
  final bool showSearchInOverview;

  /// The repository for managing filter data.
  final FilterRepository? filterRepository;

  /// The repository for managing filter values.
  final FilterValueRepository? filterValueRepository;

  /// The repository for managing filter data sources.
  final FilterDataSourceRepository? filterDataSourceRepository;

  /// An optional namespace to scope the filters.
  final String? namespace;

  /// A function that provides translations for dynamic filter names.
  /// If not provided, the keys themselves will be displayed as a fallback.
  final Translator? translator;

  /// Creates a copy of this object with the given fields replaced
  /// with the new values.
  FilterOptions copyWith({
    bool? showFiltersInOverview,
    bool? showSearchInOverview,
    FilterRepository? filterRepository,
    FilterValueRepository? filterValueRepository,
    FilterDataSourceRepository? filterDataSourceRepository,
    String? namespace,
    Translator? translator,
  }) =>
      FilterOptions(
        showFiltersInOverview:
            showFiltersInOverview ?? this.showFiltersInOverview,
        showSearchInOverview: showSearchInOverview ?? this.showSearchInOverview,
        filterRepository: filterRepository ?? this.filterRepository,
        filterValueRepository:
            filterValueRepository ?? this.filterValueRepository,
        filterDataSourceRepository:
            filterDataSourceRepository ?? this.filterDataSourceRepository,
        namespace: namespace ?? this.namespace,
        translator: translator ?? this.translator,
      );
}
