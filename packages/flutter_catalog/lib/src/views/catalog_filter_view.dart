import "package:dart_feed_utilities/filters.dart";
import "package:flutter/material.dart";
import "package:flutter_catalog/l10n/app_localizations.dart";
import "package:flutter_catalog/src/config/screen_types.dart";
import "package:flutter_catalog/src/routes.dart";
import "package:flutter_catalog/src/utils/scope.dart";
import "package:flutter_catalog/src/widgets/inputs/checkbox_input_section.dart";
import "package:flutter_hooks/flutter_hooks.dart";

/// A view that allows the user to configure and apply filters.
class CatalogFilterView extends HookWidget {
  /// Creates a [CatalogFilterView].
  const CatalogFilterView({
    required this.onNavigateToSubFilter,
    this.onExit,
    super.key,
  });

  /// The callback to execute when the user leaves the screen.
  final VoidCallback? onExit;

  /// A callback to handle navigating to a sub-filter selection screen.
  final NavigateToSubFilterCallback onNavigateToSubFilter;

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

    void applyFilters() {
      localFilterValues.value.forEach((filterId, value) async {
        if (value != null) {
          var filter = snapshot.data!
              .firstWhere((f) => f.filterModel.id == filterId)
              .filterModel;
          await filterService.setFilterValue(filter, value);
        }
      });
      onExit?.call();
    }

    useEffect(
      () {
        if (snapshot.hasData) {
          localFilterValues.value = {
            for (var f in snapshot.data!) f.filterModel.id: f.value?.value,
          };
        }
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
            onApplyFilters: applyFilters,
            onNavigateToSubFilter: onNavigateToSubFilter,
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
    required this.onApplyFilters,
    required this.onNavigateToSubFilter,
  });

  final List<FilterWithValue> filters;
  final ValueNotifier<Map<String, dynamic>> localFilterValues;
  final VoidCallback onApplyFilters;
  final NavigateToSubFilterCallback onNavigateToSubFilter;

  @override
  Widget build(BuildContext context) {
    var localizations = FlutterCatalogLocalizations.of(context)!;
    var options = CatalogScope.of(context).options;
    var builders = options.builders;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: filters.length,
            itemBuilder: (context, index) {
              var filterWithValue = filters[index];
              var filter = filterWithValue.filterModel;

              var translatedName =
                  options.filterOptions?.translator?.call(filter.name) ??
                      filter.name;
              var child = _buildFilterControls(
                context,
                filter,
                translatedName,
                localFilterValues,
              );

              return builders.filterSectionBuilder?.call(
                    context,
                    translatedName,
                    child,
                  ) ??
                  child;
            },
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: builders.primaryButtonBuilder(
            context,
            onPressed: () => onApplyFilters,
            isDisabled: false,
            onDisabledPressed: () {},
            child: Text(localizations.applyFiltersButton),
          ),
        ),
      ],
    );
  }

  /// Chooses which widget to build based on the filter's type.
  Widget _buildFilterControls(
    BuildContext context,
    FilterModel filter,
    String translatedName,
    ValueNotifier<Map<String, dynamic>> localFilterValues,
  ) =>
      switch (filter) {
        BooleanSelectFilter _ => _BooleanFilterSwitch(
            filter: filter,
            translatedName: translatedName,
            localFilterValues: localFilterValues,
          ),
        MinMaxIntFilter _ => _RangeSliderFilter(
            filter: filter,
            translatedName: translatedName,
            localFilterValues: localFilterValues,
          ),
        DataSourceMultiSelectFilter f when f.isNested || f.isSearchEnabled =>
          _NavigableFilter(
            filter: filter,
            translatedName: translatedName,
            localFilterValues: localFilterValues,
            onNavigateToSubFilter: onNavigateToSubFilter,
          ),
        DataSourceMultiSelectFilter _ => _DataSourceCheckboxFilter(
            filter: filter,
            translatedName: translatedName,
            localFilterValues: localFilterValues,
          ),
        _ => const SizedBox.shrink(),
      };
}

/// A new wrapper widget that fetches data for a filter and renders the
/// generic CheckboxInputSection.
class _DataSourceCheckboxFilter extends HookWidget {
  const _DataSourceCheckboxFilter({
    required this.filter,
    required this.translatedName,
    required this.localFilterValues,
  });

  final DataSourceMultiSelectFilter filter;
  final String translatedName;
  final ValueNotifier<Map<String, dynamic>> localFilterValues;

  @override
  Widget build(BuildContext context) {
    var scope = CatalogScope.of(context);
    // Fetch the options (e.g., Conditions, Age Ranges) for this filter
    // ignore: discarded_futures
    var optionsFuture = useMemoized(
      () async => scope.filterService.getDataForDatasource(filter.dataSource),
      [filter.dataSource],
    );
    var snapshot = useFuture(optionsFuture);

    if (!snapshot.hasData)
      return const Center(child: CircularProgressIndicator.adaptive());

    var options = snapshot.data!;
    var currentSelection =
        (localFilterValues.value[filter.id] as List<dynamic>?)
                ?.cast<String>() ??
            [];

    var crossAxisCount = filter.metadata["gridCrossAxisCount"] as int? ?? 1;

    return CheckboxInputSection<LinkedFilterData>(
      title: translatedName,
      options: options,
      gridCrossAxisCount: crossAxisCount,
      selectedKeys: currentSelection,
      keySelector: (option) => option.key,
      labelSelector: (option) => option.name,
      isMultiSelect: filter.isMultiSelect,
      onOptionToggled: (toggledKey) {
        var newSelection = List<String>.from(currentSelection);
        if (newSelection.contains(toggledKey)) {
          newSelection.remove(toggledKey);
        } else {
          if (filter.isMultiSelect) {
            newSelection.add(toggledKey);
          } else {
            newSelection = [toggledKey];
          }
        }
        var newMap = Map<String, dynamic>.from(localFilterValues.value);
        newMap[filter.id] = newSelection;
        localFilterValues.value = newMap;
      },
    );
  }
}

class _RangeSliderFilter extends StatelessWidget {
  const _RangeSliderFilter({
    required this.filter,
    required this.translatedName,
    required this.localFilterValues,
  });
  final MinMaxIntFilter filter;
  final String translatedName;
  final ValueNotifier<Map<String, dynamic>> localFilterValues;

  @override
  Widget build(BuildContext context) {
    var currentValue = (localFilterValues.value[filter.id] as (int, int?)?) ??
        (filter.defaultValue, filter.isRange ? filter.defaultValue : null);

    if (filter.isRange) {
      var currentRange = RangeValues(
        currentValue.$1.toDouble(),
        (currentValue.$2 ?? filter.max).toDouble(),
      );
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
      return const SizedBox.shrink();
    }
  }
}

class _NavigableFilter extends StatelessWidget {
  const _NavigableFilter({
    required this.filter,
    required this.translatedName,
    required this.localFilterValues,
    required this.onNavigateToSubFilter,
  });
  final DataSourceMultiSelectFilter filter;
  final String translatedName;
  final ValueNotifier<Map<String, dynamic>> localFilterValues;
  final NavigateToSubFilterCallback onNavigateToSubFilter;

  @override
  Widget build(BuildContext context) {
    var currentSelection =
        (localFilterValues.value[filter.id] as List<dynamic>?)
                ?.cast<String>() ??
            [];

    return ListTile(
      title: Text(filter.name),
      subtitle: currentSelection.isNotEmpty
          ? Text("${currentSelection.length} selected")
          : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        var newSelection = await onNavigateToSubFilter.call(
          context,
          filter,
          currentSelection,
        );

        // If the user confirmed a new selection, update the state.
        if (newSelection != null) {
          var newMap = Map<String, dynamic>.from(localFilterValues.value);
          newMap[filter.id] = newSelection;
          localFilterValues.value = newMap;
        }
      },
    );
  }
}

class _BooleanFilterSwitch extends StatelessWidget {
  const _BooleanFilterSwitch({
    required this.filter,
    required this.translatedName,
    required this.localFilterValues,
  });

  final BooleanSelectFilter filter;
  final String translatedName;
  final ValueNotifier<Map<String, dynamic>> localFilterValues;

  @override
  Widget build(BuildContext context) {
    // Get the current value from the local state, defaulting to false.
    var currentValue = localFilterValues.value[filter.id] as bool? ?? false;

    return SwitchListTile(
      title: Text(filter.name),
      value: currentValue,
      onChanged: (newValue) {
        // Update the local state when the switch is toggled.
        var newMap = Map<String, dynamic>.from(localFilterValues.value);
        newMap[filter.id] = newValue;
        localFilterValues.value = newMap;
      },
    );
  }
}
