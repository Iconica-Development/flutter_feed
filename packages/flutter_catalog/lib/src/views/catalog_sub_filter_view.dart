import "package:dart_feed_utilities/dart_feed_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_catalog/flutter_catalog.dart";
import "package:flutter_hooks/flutter_hooks.dart";

/// A view that displays options for a specific data-driven filter, supporting
/// infinite nesting and returning the user's final selection.
class CatalogSubFilterView extends HookWidget {
  /// Creates a [CatalogSubFilterView].
  ///
  /// Requires the [filter] model and an [initialSelection] of keys.
  /// The optional [parentData] is used for recursive navigation into
  /// sub-categories.
  const CatalogSubFilterView({
    required this.filter,
    required this.initialSelection,
    this.parentData,
    super.key,
  });

  /// The filter model that defines the behavior of this view.
  final DataSourceMultiSelectFilter filter;

  /// The list of keys that are selected when the view is first opened.
  final List<String> initialSelection;

  /// The parent data node, if this is a nested view.
  final LinkedFilterData? parentData;

  @override
  Widget build(BuildContext context) {
    var scope = CatalogScope.of(context);
    var options = scope.options;
    var filterService = scope.filterService;
    var localizations = FlutterCatalogLocalizations.of(context)!;

    var selectedValues = useState<List<String>>(initialSelection);
    var searchQuery = useState("");

    // ignore: discarded_futures
    var dataSourceFuture = useMemoized(
      () async => filterService.getDataForDatasource(filter.dataSource),
      [filter.dataSource],
    );
    var snapshot = useFuture(dataSourceFuture);

    var appBar = AppBar(
      title: Text(parentData?.name ?? filter.name),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop(selectedValues.value);
        },
      ),
    );

    var body = Builder(
      builder: (context) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No options available."));
        }

        var allData = snapshot.data!;
        var tree = allData.getDataAsTree(currentNode: parentData);

        var filteredTree = tree
            .where(
              (node) => node.current.name
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()),
            )
            .toList();

        return Column(
          children: [
            if (filter.isSearchEnabled) ...[
              TextField(
                onChanged: (value) => searchQuery.value = value,
                decoration: InputDecoration(
                  hintText: localizations.searchHint,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: filteredTree.length,
                itemBuilder: (context, index) {
                  var node = tree[index];
                  var hasChildren = node.children.isNotEmpty;

                  // Use a ListTile for more control over tap targets
                  return ListTile(
                    // The leading widget is now just the Checkbox
                    leading: Checkbox(
                      value: selectedValues.value.contains(node.current.key),
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
                    ),
                    title: Text(node.current.name),
                    // The trailing widget is the navigation indicator
                    trailing:
                        hasChildren ? const Icon(Icons.chevron_right) : null,
                    // The onTap of the entire ListTile handles navigation
                    onTap: hasChildren
                        ? () async {
                            var result =
                                await Navigator.of(context).push<List<String>>(
                              MaterialPageRoute(
                                builder: (context) => CatalogSubFilterView(
                                  filter: filter,
                                  parentData: node.current,
                                  initialSelection: selectedValues.value,
                                ),
                              ),
                            );

                            if (result != null) {
                              selectedValues.value = result;
                            }
                          }
                        : () {
                            var currentSelection =
                                List<String>.from(selectedValues.value);
                            if (currentSelection.contains(node.current.key)) {
                              currentSelection.remove(node.current.key);
                            } else {
                              if (filter.isMultiSelect) {
                                currentSelection.add(node.current.key);
                              } else {
                                currentSelection
                                  ..clear()
                                  ..add(node.current.key);
                              }
                            }
                            selectedValues.value = currentSelection;
                          },
                  );
                },
              ),
            ),
          ],
        );
      },
    );

    if (options.builders.baseScreenBuilder != null) {
      return options.builders.baseScreenBuilder!(
        context,
        ScreenType.catalogSubFilter,
        appBar,
        parentData?.name ?? filter.name,
        body,
      );
    }

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
