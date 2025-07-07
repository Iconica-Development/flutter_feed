import "dart:async";

import "package:dart_feed_utilities/dart_feed_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_catalog/l10n/app_localizations.dart";
import "package:flutter_catalog/src/config/screen_types.dart";
import "package:flutter_catalog/src/utils/scope.dart";
import "package:flutter_catalog/src/widgets/catalog_grid_item.dart";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";
import "package:flutter_hooks/flutter_hooks.dart";

///
class CatalogOverviewView extends HookWidget {
  ///
  const CatalogOverviewView({
    required this.onPressItem,
    required this.onPressFilters,
    this.onExit,
    super.key,
  });

  ///
  final void Function(CatalogItem item) onPressItem;

  ///
  final VoidCallback onPressFilters;

  ///
  final VoidCallback? onExit;

  @override
  Widget build(BuildContext context) {
    var scope = CatalogScope.of(context);
    var options = scope.options;
    var localizations = FlutterCatalogLocalizations.of(context)!;

    var searchController = useTextEditingController();

    useEffect(
      () {
        if (onExit == null) return null;
        scope.popHandler.register(onExit!);
        return () => scope.popHandler.unregister(onExit!);
      },
      [onExit],
    );

    var appBar = (options.filterOptions?.showSearchInOverview ?? true)
        ? _AppBarWithSearch(
            localizations: localizations,
            searchController: searchController,
          )
        : AppBar(
            title: Text(
              options.translations.overviewTitle ?? localizations.overviewTitle,
            ),
          );

    var body = Column(
      children: [
        if (options.filterOptions?.showFiltersInOverview ?? false) ...[
          _FilterBar(
            localizations: localizations,
            onPressFilters: onPressFilters,
          ),
        ],
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: _Body(
              onPressItem: onPressItem,
            ),
          ),
        ),
      ],
    );

    if (options.builders.baseScreenBuilder != null) {
      return options.builders.baseScreenBuilder!(
        context,
        ScreenType.catalogOverview,
        appBar,
        options.translations.overviewTitle ?? localizations.overviewTitle,
        body,
      );
    }

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}

class _AppBarWithSearch extends HookWidget implements PreferredSizeWidget {
  const _AppBarWithSearch({
    required this.localizations,
    required this.searchController,
  });

  final FlutterCatalogLocalizations localizations;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var scope = CatalogScope.of(context);
    var filterService = scope.filterService;
    var text = useValueListenable(searchController);

    var debouncedText =
        useDebounced(text.text, const Duration(milliseconds: 500));

    var previousDebouncedText = usePrevious(debouncedText);

    useEffect(
      () {
        if (debouncedText != null && debouncedText != previousDebouncedText) {
          Future<void> updateFilter() async {
            var filters = await filterService.getFilters();
            var searchFilter =
                filters.firstWhere((element) => element.id == "search");
            await filterService.setFilterValue(searchFilter, debouncedText);
          }

          unawaited(updateFilter());
        }
        return;
      },
      [debouncedText],
    );

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: localizations.searchHint,
              suffixIcon: Icon(
                Icons.search,
                color: colorScheme.onSurfaceVariant,
              ),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: colorScheme.outline,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: colorScheme.outline.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                ),
              ),
              hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.localizations,
    required this.onPressFilters,
  });

  final FlutterCatalogLocalizations localizations;
  final VoidCallback onPressFilters;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var options = CatalogScope.of(context).options;

    var backgroundColor = options.theme.filterBarBackgroundColor ??
        theme.colorScheme.secondaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: backgroundColor,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ActionChip(
          onPressed: onPressFilters,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(localizations.filterButton),
              const SizedBox(width: 5),
              const Icon(Icons.filter_alt, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends HookWidget {
  const _Body({
    required this.onPressItem,
  });

  final void Function(CatalogItem item) onPressItem;

  @override
  Widget build(BuildContext context) {
    var localizations = FlutterCatalogLocalizations.of(context)!;

    var scope = CatalogScope.of(context);
    var filterService = scope.filterService;
    var filtersStream =
        useMemoized(() => filterService.getFiltersWithValues(), []);
    var filtersSnapshot = useStream(filtersStream);
    var options = scope.options;
    var builders = options.builders;

    // ignore: discarded_futures
    var itemsFuture = useMemoized(
      () async {
        if (!filtersSnapshot.hasData) {
          return scope.catalogService.fetchCatalogItems();
        }
        return scope.catalogService.fetchCatalogItems(
          filters: filtersSnapshot.data!.toSerializedFilterMap(),
        );
      },
      [filtersSnapshot.data],
    );
    var snapshot = useFuture(itemsFuture);

    // ignore: discarded_futures
    var usersFuture = useMemoized(
      () async {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          var authorIds = snapshot.data!
              .map((item) => item.authorId)
              .whereType<String>()
              .toSet()
              .toList();
          if (authorIds.isNotEmpty) {
            return scope.options.catalogUserRepository.getUsers(authorIds);
          }
        }
        return Future.value(<CatalogUser>[]);
      },
      [snapshot.data],
    );
    var usersSnapshot = useFuture(usersFuture);
    var usersMap = {
      for (var user in usersSnapshot.data ?? <CatalogUser>[]) user.id: user,
    };

    if (snapshot.connectionState == ConnectionState.waiting) {
      return builders.loadingIndicatorBuilder?.call(context) ??
          const Center(child: CircularProgressIndicator.adaptive());
    }

    if (snapshot.hasError) {
      return builders.errorPlaceholderBuilder?.call(context, snapshot.error) ??
          Center(child: Text(localizations.itemLoadingError));
    }

    var items = snapshot.data;
    useEffect(
      () {
        if (items == null || items.isEmpty) {
          options.onNoItems?.call();
        }
        return;
      },
      [],
    );
    if (items == null || items.isEmpty) {
      return builders.noItemsPlaceholderBuilder?.call(context) ??
          Center(child: Text(localizations.noItemsFound));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          options.translations.overviewTitle ?? localizations.overviewTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(top: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              var author = usersMap[item.authorId];

              return builders.itemCardBuilder
                      ?.call(context, item, () => onPressItem(item)) ??
                  CatalogGridItem(
                    item: item,
                    author: author,
                    onTap: () => onPressItem(item),
                  );
            },
          ),
        ),
      ],
    );
  }
}
