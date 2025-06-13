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
}
