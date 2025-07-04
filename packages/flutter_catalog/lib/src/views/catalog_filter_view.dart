import "package:dart_feed_utilities/filters.dart";
import "package:flutter/material.dart";
import "package:flutter_catalog/l10n/app_localizations.dart";
import "package:flutter_catalog/src/config/screen_types.dart";
import "package:flutter_catalog/src/utils/scope.dart";
import "package:flutter_catalog/src/views/catalog_sub_filter_view.dart";
import "package:flutter_hooks/flutter_hooks.dart";

/// A view that allows the user to configure and apply filters.
class CatalogFilterView extends HookWidget {
  /// Creates a [CatalogFilterView].
  const CatalogFilterView({super.key, this.onExit});

  /// The callback to execute when the user leaves the screen.
  final VoidCallback? onExit;

  @override
  Widget build(BuildContext context) {
    var scope = CatalogScope.of(context);
    var options = scope.options;
    var localizations = FlutterCatalogLocalizations.of(context)!;
    var filterService = scope.filterService;

    var localFilterValues = useState<Map<String, dynamic>>({});

    var filtersStream = useMemoized(
      () => filterService.getFiltersWithValues(),
      [],
    );
    var snapshot = useStream(filtersStream);

    useEffect(
      () {
        if (!snapshot.hasData) return;
        var newValues = {
          for (var filterWithValue in snapshot.data!)
            filterWithValue.filterModel.id: filterWithValue.value?.value,
        };
        localFilterValues.value = newValues;
        return;
      },
      [snapshot.data],
    );

    useEffect(
      () {
        if (onExit == null) return null;
        scope.popHandler.register(onExit!);
        return () => scope.popHandler.unregister(onExit!);
      },
      [onExit],
    );

    var appBar = AppBar(
      title: Text(localizations.filtersTitle),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onExit,
      ),
    );

    var displayableFilters = snapshot.data
        ?.where((filter) => filter.filterModel.id != "search")
        .toList();

    var body = !snapshot.hasData
        ? const Center(child: CircularProgressIndicator.adaptive())
        : _FilterBody(
            filters: displayableFilters ?? [],
            localFilterValues: localFilterValues,
          );

    if (options.builders.baseScreenBuilder != null) {
      return options.builders.baseScreenBuilder!(
        context,
        ScreenType.catalogFilter,
        appBar,
        localizations.filtersTitle,
        body,
      );
    }

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}

class _FilterBody extends StatelessWidget {
  const _FilterBody({
    required this.filters,
    required this.localFilterValues,
  });

  final List<FilterWithValue> filters;
  final ValueNotifier<Map<String, dynamic>> localFilterValues;

  void _applyFilters(BuildContext context) {
    var scope = CatalogScope.of(context);
    var filterService = scope.filterService;

    localFilterValues.value.forEach((filterId, value) async {
      var filter =
          filters.firstWhere((f) => f.filterModel.id == filterId).filterModel;

      if (value != null) {
        await filterService.setFilterValue(filter, value);
      }
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var localizations = FlutterCatalogLocalizations.of(context)!;
    var options = CatalogScope.of(context).options;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filters.length,
              itemBuilder: (context, index) {
                var filterWithValue = filters[index];
                var filter = filterWithValue.filterModel;
                var child =
                    _buildFilterControls(context, filter, localFilterValues);

                return options.builders.filterSectionBuilder?.call(
                      context,
                      filter.name,
                      child,
                    ) ??
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            filter.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        child,
                      ],
                    );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _applyFilters(context),
              child: Text(localizations.applyFiltersButton),
            ),
          ),
        ],
      ),
    );
  }

  /// Chooses which widget to build based on the filter's type.
  Widget _buildFilterControls(
    BuildContext context,
    FilterModel filter,
    ValueNotifier<Map<String, dynamic>> localFilterValues,
  ) =>
      switch (filter) {
        BooleanSelectFilter() => _buildBooleanFilter(context, filter),
        MinMaxIntFilter() => _buildMinMaxIntFilter(context, filter),
        DataSourceMultiSelectFilter() =>
          _buildDataSourceFilter(context, filter, localFilterValues),
        _ => ListTile(
            title: const Text("More options"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          )
      };

  Widget _buildBooleanFilter(
    BuildContext context,
    BooleanSelectFilter filter,
  ) =>
      SwitchListTile(
        title: Text(filter.name),
        value: localFilterValues.value[filter.id] as bool? ?? false,
        onChanged: (newValue) {
          var newMap = Map<String, dynamic>.from(localFilterValues.value);
          newMap[filter.id] = newValue;
          localFilterValues.value = newMap;
        },
      );

  Widget _buildMinMaxIntFilter(
    BuildContext context,
    MinMaxIntFilter filter,
  ) {
    var currentValue = localFilterValues.value[filter.id] as (int, int?)? ??
        (filter.defaultValue, filter.isRange ? filter.defaultValue : null);

    if (filter.isRange) {
      var currentRange =
          RangeValues(currentValue.$1.toDouble(), currentValue.$2!.toDouble());
      return RangeSlider(
        values: currentRange,
        min: filter.min.toDouble(),
        max: filter.max.toDouble(),
        divisions: filter.max - filter.min,
        labels: RangeLabels(
          currentRange.start.round().toString(),
          currentRange.end.round().toString(),
        ),
        onChanged: (RangeValues values) {
          var newMap = Map<String, dynamic>.from(localFilterValues.value);
          newMap[filter.id] = (values.start.round(), values.end.round());
          localFilterValues.value = newMap;
        },
      );
    } else {
      return Slider(
        value: currentValue.$1.toDouble(),
        min: filter.min.toDouble(),
        max: filter.max.toDouble(),
        divisions: filter.max - filter.min,
        label: currentValue.$1.toString(),
        onChanged: (double value) {
          var newMap = Map<String, dynamic>.from(localFilterValues.value);
          newMap[filter.id] = (value.round(), null);
          localFilterValues.value = newMap;
        },
      );
    }
  }

  /// Builds a navigable list tile for data source filters.
  Widget _buildDataSourceFilter(
    BuildContext context,
    DataSourceMultiSelectFilter filter,
    ValueNotifier<Map<String, dynamic>> localFilterValues,
  ) =>
      HookBuilder(
        builder: (context) {
          var currentValues = useValueListenable(localFilterValues);
          var selected = currentValues[filter.id] as List<dynamic>? ?? [];

          return ListTile(
            title: Text(filter.name),
            subtitle: selected.isNotEmpty
                ? Text("${selected.length} selected")
                : null,
            trailing: const Icon(Icons.chevron_right),
            onTap: () async => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CatalogSubFilterView(
                  filter: filter,
                  localFilterValues: localFilterValues,
                  onExit: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          );
        },
      );
}
