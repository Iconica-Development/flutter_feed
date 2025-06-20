import "package:dart_feed_utilities/dart_feed_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_catalog/src/utils/scope.dart";
import "package:flutter_hooks/flutter_hooks.dart";

/// A view that displays options for a specific data-driven filter.
///
/// It supports searching, nesting, and single/multi-selection based on the
/// properties of the provided [DataSourceMultiSelectFilter].
class CatalogSubFilterView extends HookWidget {
  ///
  const CatalogSubFilterView({
    required this.filter,
    required this.localFilterValues,
    this.parentData,
    this.onExit,
    super.key,
  });

  /// The filter model that defines the behavior of this view.
  final DataSourceMultiSelectFilter filter;

  /// The parent data node, if this is a nested view.
  final LinkedFilterData? parentData;

  /// A callback to execute when leaving the view.
  final VoidCallback? onExit;

  /// The notifier holding the staged filter values from the main filter page.
  final ValueNotifier<Map<String, dynamic>> localFilterValues;

  @override
  Widget build(BuildContext context) {
    var scope = CatalogScope.of(context);
    var filterService = scope.filterService;

    // ignore: discarded_futures
    var dataSourceFuture = useMemoized(
      () async => filterService.getDataForDatasource(filter.dataSource),
      [filter.dataSource],
    );
    var snapshot = useFuture(dataSourceFuture);

    var selectedValues = useState<List<String>>(
      (localFilterValues.value[filter.id] as List<dynamic>?)?.cast<String>() ??
          [],
    );

    useEffect(
      () => () {
        var newMap = Map<String, dynamic>.from(localFilterValues.value);
        newMap[filter.id] = selectedValues.value;
        localFilterValues.value = newMap;
      },
      const [],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(parentData?.name ?? filter.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onExit,
        ),
      ),
      body: Builder(
        builder: (context) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text("No options available."));
          }

          var allData = snapshot.data!;
          var tree = allData.getDataAsTree(currentNode: parentData);

          return ListView.builder(
            itemCount: tree.length,
            itemBuilder: (context, index) {
              var node = tree[index];
              var hasChildren = node.children.isNotEmpty;

              return InkWell(
                onTap: hasChildren
                    ? () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CatalogSubFilterView(
                              filter: filter,
                              parentData: node.current,
                              localFilterValues: localFilterValues,
                              onExit: () => Navigator.of(context).pop(),
                            ),
                          ),
                        );
                      }
                    : null,
                child: CheckboxListTile(
                  title: Text(node.current.name),
                  value: selectedValues.value.contains(node.current.key),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? selected) {
                    var currentSelection =
                        List<String>.from(selectedValues.value);
                    if (selected ?? false) {
                      if (filter.isMultiSelect) {
                        currentSelection.add(node.current.key);
                      } else {
                        currentSelection
                          ..clear()
                          ..add(node.current.key);
                      }
                    } else {
                      currentSelection.remove(node.current.key);
                    }
                    selectedValues.value = currentSelection;
                  },
                  secondary:
                      hasChildren ? const Icon(Icons.chevron_right) : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
