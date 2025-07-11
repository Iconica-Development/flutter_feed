import "package:dart_feed_utilities/dart_feed_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_catalog/flutter_catalog.dart";
import "package:flutter_catalog/src/models/item_view_model.dart";
import "package:flutter_catalog/src/routes.dart";
import "package:flutter_catalog/src/widgets/inputs/checkbox_input_section.dart";
import "package:flutter_catalog/src/widgets/inputs/image_selection_widget.dart";
import "package:flutter_catalog/src/widgets/inputs/input_section.dart";
import "package:flutter_catalog/src/widgets/inputs/range_slider_input_section.dart";
import "package:flutter_catalog/src/widgets/inputs/text_input_section.dart";
import "package:flutter_hooks/flutter_hooks.dart";

/// Padding to apply on the sides of the item creation screen.
const double itemModificationScreenSidePadding = 20.0;

/// A screen for creating a new catalog item or editing an existing one.
class CatalogModifyView extends HookWidget {
  ///
  const CatalogModifyView({
    required this.onNavigateToSubFilter,
    this.initialItem,
    this.onExit,
    super.key,
  });

  /// The item to be edited. If null, the screen is in "create" mode.
  final CatalogItem? initialItem;

  /// A callback to execute when the screen is closed.
  final VoidCallback? onExit;

  /// A callback to navigate to a sub-filter selection screen.
  final NavigateToSubFilterCallback onNavigateToSubFilter;

  ///
  bool get isEditing => initialItem != null;

  @override
  Widget build(BuildContext context) {
    var itemData = useState(
      isEditing
          ? ItemModificationData.fromItem(initialItem!)
          : const ItemModificationData(),
    );
    var isLoading = useState(false);
    var scope = CatalogScope.of(context);
    var options = scope.options;
    var localizations = FlutterCatalogLocalizations.of(context)!;
    var navigator = Navigator.of(context);

    // ignore: discarded_futures
    var filtersFuture = useMemoized(() => scope.filterService.getFilters(), []);
    var filtersSnapshot = useFuture(filtersFuture);

    var validationError = itemData.value.validate(localizations);
    var isFormValid = validationError == null;
    var isButtonDisabled = isLoading.value || !isFormValid;

    void onDisabledPressed() {
      if (!isFormValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validationError)),
        );
      }
    }

    var buttonChild = Text(
      isLoading.value
          ? localizations.itemCreatePageSavingChangesButton
          : localizations.itemCreatePageSaveChangesButton,
    );

    Future<void> handleSubmit() async {
      isLoading.value = true;
      try {
        var uploadedImageUrls = await Future.wait(
          itemData.value.newImages
              .map((file) => scope.catalogService.uploadImage(file)),
        );

        var dataMap = itemData.value.toJson(
          allImageUrls: [
            ...itemData.value.existingImageUrls,
            ...uploadedImageUrls,
          ],
        );

        if (isEditing) {
          await scope.catalogService
              .updateCatalogItem(initialItem!.id, dataMap);
        } else {
          await scope.catalogService.createCatalogItem(dataMap);
        }
        onExit?.call();
      } on Exception catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizations.itemCreatePageGenericError)),
        );
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> handleDelete() async {
      var confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(localizations.itemCreatePageDeleteConfirmationTitle),
          content: Text(localizations.itemCreatePageDeleteConfirmationMessage),
          actions: [
            TextButton(
              onPressed: () => navigator.pop(false),
              child: Text(localizations.itemCreatePageDeleteConfirmationCancel),
            ),
            TextButton(
              onPressed: () => navigator.pop(true),
              child: Text(
                localizations.itemCreatePageDeleteConfirmationConfirm,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      );

      if (confirmed ?? false) {
        isLoading.value = true;
        try {
          await scope.catalogService.deleteCatalogItem(initialItem!.id);
          onExit?.call();
        } on Exception catch (_) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.itemCreatePageItemDeleteError),
            ),
          );
        } finally {
          isLoading.value = false;
        }
      }
    }

    var saveButton = options.builders.primaryButtonBuilder(
      context,
      onPressed: handleSubmit,
      onDisabledPressed: onDisabledPressed,
      isDisabled: isButtonDisabled,
      child: buttonChild,
    );

    var appBar = AppBar(
      title: Text(
        isEditing
            ? localizations.itemEditPageTitle
            : localizations.itemCreatePageTitle,
      ),
    );

    var body = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: itemModificationScreenSidePadding,
              vertical: 16,
            ),
            child: ImageSelection(
              existingImageUrls: itemData.value.existingImageUrls,
              newImages: itemData.value.newImages,
              onNewImagesChanged: (list) =>
                  itemData.value = itemData.value.copyWith(newImages: list),
              onExistingImagesChanged: (list) => itemData.value =
                  itemData.value.copyWith(existingImageUrls: list),
            ),
          ),
          const SizedBox(height: 24),
          TextInputSection(
            title: localizations.itemCreatePageTitleHint,
            label: localizations.itemCreatePageTitleHint,
            value: itemData.value.title,
            mandatory: true,
            onChanged: (value) =>
                itemData.value = itemData.value.copyWith(title: value),
          ),
          TextInputSection(
            title: localizations.itemCreatePageDescriptionHint,
            label: localizations.itemCreatePageDescriptionHint,
            value: itemData.value.description,
            onChanged: (value) =>
                itemData.value = itemData.value.copyWith(description: value),
          ),
          const SizedBox(height: 24),
          if (filtersSnapshot.hasData) ...[
            ...filtersSnapshot.data!.where((f) => f.id != "search").map(
                  (filter) => _buildFilterInput(context, filter, itemData),
                ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: itemModificationScreenSidePadding,
              vertical: 16,
            ),
            child: saveButton,
          ),
          if (isEditing) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: isLoading.value ? null : handleDelete,
              child: Text(
                localizations.itemCreatePageDeleteItemButton,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ],
      ),
    );
    if (options.builders.baseScreenBuilder != null) {
      return options.builders.baseScreenBuilder!(
        context,
        ScreenType.catalogModify,
        appBar,
        isEditing
            ? localizations.itemEditPageTitle
            : localizations.itemCreatePageTitle,
        body,
      );
    }
    return Scaffold(appBar: appBar, body: body);
  }

  /// The main builder method that decides which input widget to render
  /// for a given filter definition.
  Widget _buildFilterInput(
    BuildContext context,
    FilterModel filter,
    ValueNotifier<ItemModificationData> itemData,
  ) =>
      switch (filter) {
        MinMaxIntFilter _ =>
          _MinMaxFilterInput(filter: filter, itemData: itemData),
        DataSourceMultiSelectFilter f when f.isNested || f.isSearchEnabled =>
          _NavigableInputSection(
            filter: filter,
            itemData: itemData,
            onNavigate: onNavigateToSubFilter,
          ),
        DataSourceMultiSelectFilter _ =>
          _DataSourceFilterInput(filter: filter, itemData: itemData),
        _ => const SizedBox.shrink(),
      };
}

/// A wrapper that provides data and logic for a checkbox-based filter input.
class _DataSourceFilterInput extends HookWidget {
  const _DataSourceFilterInput({required this.filter, required this.itemData});
  final DataSourceMultiSelectFilter filter;
  final ValueNotifier<ItemModificationData> itemData;

  @override
  Widget build(BuildContext context) {
    var scope = CatalogScope.of(context);
    var options = scope.options;
    // ignore: discarded_futures
    var dataSourceFuture = useMemoized(
      () async => scope.filterService.getDataForDatasource(filter.dataSource),
      [filter.dataSource],
    );
    var snapshot = useFuture(dataSourceFuture);

    if (!snapshot.hasData) return const SizedBox.shrink();

    var currentSelection =
        (itemData.value.customFieldValues[filter.key] as List<dynamic>?)
                ?.cast<String>() ??
            [];
    var translatedName =
        options.filterOptions?.translator?.call(filter.name) ?? filter.name;

    return CheckboxInputSection<LinkedFilterData>(
      title: translatedName,
      options: snapshot.data!,
      selectedKeys: currentSelection,
      keySelector: (option) => option.key,
      labelSelector: (option) => option.name,
      isMultiSelect: filter.isMultiSelect,
      gridCrossAxisCount: filter.metadata["gridCrossAxisCount"] as int? ?? 1,
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
        var newCustomValues =
            Map<String, dynamic>.from(itemData.value.customFieldValues);
        newCustomValues[filter.key] = newSelection;
        itemData.value =
            itemData.value.copyWith(customFieldValues: newCustomValues);
      },
    );
  }
}

/// A wrapper that provides data and logic for a range-slider-based
/// filter input.
class _MinMaxFilterInput extends HookWidget {
  const _MinMaxFilterInput({required this.filter, required this.itemData});
  final MinMaxIntFilter filter;
  final ValueNotifier<ItemModificationData> itemData;

  @override
  Widget build(BuildContext context) {
    var options = CatalogScope.of(context).options;
    var translatedName =
        options.filterOptions?.translator?.call(filter.name) ?? filter.name;

    var currentValue =
        (itemData.value.customFieldValues[filter.key] as (int, int?)?) ??
            (filter.defaultValue, filter.isRange ? filter.defaultValue : null);

    return RangeSliderInputSection(
      title: translatedName,
      min: filter.min,
      max: filter.max,
      values: RangeValues(
        currentValue.$1.toDouble(),
        (currentValue.$2 ?? filter.max).toDouble(),
      ),
      onChanged: (values) {
        var newCustomValues =
            Map<String, dynamic>.from(itemData.value.customFieldValues);
        newCustomValues[filter.key] =
            (values.start.round(), values.end.round());
        itemData.value =
            itemData.value.copyWith(customFieldValues: newCustomValues);
      },
    );
  }
}

/// A new widget that renders a clickable row for filters that
/// require navigation.
class _NavigableInputSection extends HookWidget {
  const _NavigableInputSection({
    required this.filter,
    required this.itemData,
    required this.onNavigate,
  });

  final DataSourceMultiSelectFilter filter;
  final ValueNotifier<ItemModificationData> itemData;
  final NavigateToSubFilterCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    var scope = CatalogScope.of(context);
    var options = scope.options;
    var translatedName =
        options.filterOptions?.translator?.call(filter.name) ?? filter.name;
    var currentSelection =
        (itemData.value.customFieldValues[filter.key] as List<dynamic>?)
                ?.cast<String>() ??
            [];

    return InputSection(
      title: translatedName,
      // You can add logic here to show the names of selected items
      input: Text("${currentSelection.length} selected"),
      onTap: () async {
        var newSelection = await onNavigate(
          context,
          filter,
          currentSelection,
        );

        // If the sub-page returned a new selection, update the form state.
        if (newSelection != null) {
          var newCustomValues =
              Map<String, dynamic>.from(itemData.value.customFieldValues);
          newCustomValues[filter.key] = newSelection;
          itemData.value =
              itemData.value.copyWith(customFieldValues: newCustomValues);
        }
      },
    );
  }
}
