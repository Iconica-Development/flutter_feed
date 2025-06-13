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

    useEffect(
      () {
        if (onExit == null) return null;
        scope.popHandler.register(onExit!);
        return () => scope.popHandler.unregister(onExit!);
      },
      [onExit],
    );

    var appBar = _AppBar(
      localizations: localizations,
    );

    var body = Column(
      children: [
        _FilterBar(
          localizations: localizations,
          onPressFilters: onPressFilters,
        ),
        Expanded(
          child: _Body(
            onPressItem: onPressItem,
          ),
        ),
      ],
    );

    // Use the baseScreenBuilder if it's provided by the user.
    if (options.builders.baseScreenBuilder != null) {
      return options.builders.baseScreenBuilder!(
        context,
        ScreenType.catalogOverview,
        appBar,
        localizations.overviewTitle,
        body,
      );
    }

    // Otherwise, fall back to a default Scaffold.
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    required this.localizations,
  });

  final FlutterCatalogLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      title: TextField(
        decoration: InputDecoration(
          hintText: localizations.searchHint,
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
        child: FilterChip(
          label: Text(localizations.filterButton),
          avatar: const Icon(Icons.filter_list),
          onSelected: (_) => onPressFilters(),
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
    var options = scope.options;
    var builders = options.builders;

    // ignore: discarded_futures
    var itemsFuture = useMemoized(() => scope.service.getItems(), []);
    var snapshot = useFuture(itemsFuture);

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

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        var item = items[index];
        // Use the itemCardBuilder if provided, otherwise use the default.
        return builders.itemCardBuilder
                ?.call(context, item, () => onPressItem(item)) ??
            CatalogGridItem(
              item: item,
              onTap: () => onPressItem(item),
            );
      },
    );
  }
}
