import 'app_localizations.dart';

/// The translations for English (`en`).
class FlutterCatalogLocalizationsEn extends FlutterCatalogLocalizations {
  FlutterCatalogLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get overviewTitle => 'Toys near you';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get searchHint => 'Find toys...';

  @override
  String get filterButton => 'Filters';

  @override
  String get noItemsFound => 'No items found.';

  @override
  String get itemLoadingError => 'Failed to load items.';

  @override
  String get itemCreatePageMandatorySection => 'Mandatory';

  @override
  String get detailDescriptionTitle => 'Description';

  @override
  String get applyFiltersButton => 'Apply filters';

  @override
  String get sendMessageButton => 'Send message';

  @override
  String get characteristicsTitle => 'Characteristics';

  @override
  String get distanceTitle => 'Distance';

  @override
  String postedSince(Object date) {
    return 'Posted since $date';
  }

  @override
  String get itemCreatePageTitle => 'Create Item';

  @override
  String get itemEditPageTitle => 'Edit Item';

  @override
  String get itemCreatePageTitleHint => 'Title';

  @override
  String get itemCreatePageDescriptionHint => 'Description';

  @override
  String get itemCreatePageTitleRequiredError => 'Title is required.';

  @override
  String get itemCreatePageAddImagesButton => 'Add Images';

  @override
  String get itemCreatePageSaveChangesButton => 'Save Changes';

  @override
  String get itemCreatePageSavingChangesButton => 'Saving...';

  @override
  String get itemCreatePageDeleteItemButton => 'Delete Item';

  @override
  String get itemCreatePageDeleteConfirmationTitle => 'Delete Item';

  @override
  String get itemCreatePageDeleteConfirmationMessage =>
      'Are you sure you want to delete this item forever?';

  @override
  String get itemCreatePageDeleteConfirmationConfirm => 'Delete';

  @override
  String get itemCreatePageDeleteConfirmationCancel => 'Cancel';

  @override
  String get itemCreatePageGenericError => 'An error occurred.';

  @override
  String get itemCreatePageItemDeletedSuccess => 'Item deleted successfully.';

  @override
  String get itemCreatePageItemDeleteError => 'Failed to delete item.';
}
