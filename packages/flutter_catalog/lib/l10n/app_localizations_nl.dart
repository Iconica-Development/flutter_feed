// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class FlutterCatalogLocalizationsNl extends FlutterCatalogLocalizations {
  FlutterCatalogLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get overviewTitle => 'Speelgoed bij jou in de buurt';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get searchHint => 'Speelgoed zoeken...';

  @override
  String get filterButton => 'Filters';

  @override
  String get noItemsFound => 'Geen speelgoed gevonden.';

  @override
  String get itemLoadingError => 'Het laden van de items is mislukt.';

  @override
  String get itemCreatePageMandatorySection => 'Mandatory';

  @override
  String get detailDescriptionTitle => 'Beschrijving';

  @override
  String get applyFiltersButton => 'Filters toepassen';

  @override
  String get sendMessageButton => 'Bericht verzenden';

  @override
  String get characteristicsTitle => 'Kenmerken';

  @override
  String get distanceTitle => 'Afstand';

  @override
  String postedSince(Object date) {
    return 'Geplaatst sinds $date';
  }

  @override
  String get editItemButton => 'Bewerk';

  @override
  String get contactUserDisabledMessage =>
      'U kunt geen contact opnemen met de auteur van dit item.';

  @override
  String get itemCreatePageTitle => 'Bewerk Item';

  @override
  String get priceFree => 'Gratis';

  @override
  String get itemEditPageTitle => 'Bewerk item';

  @override
  String get itemCreatePageTitleHint => 'Titel';

  @override
  String get itemCreatePageDescriptionHint => 'Beschrijving';

  @override
  String get itemCreatePageTitleRequiredError => 'Een titel is verplicht.';

  @override
  String get itemCreatePageAddImagesButton => 'Afbeeldingen toevoegen';

  @override
  String get itemCreatePageSaveChangesButton => 'Wijzigingen opslaan';

  @override
  String get itemCreatePageSavingChangesButton => 'Bezig met opslaan...';

  @override
  String get itemCreatePageDeleteItemButton => 'Item verwijderen';

  @override
  String get itemCreatePageDeleteConfirmationTitle => 'Item verwijderen';

  @override
  String get itemCreatePageDeleteConfirmationMessage =>
      'Weet je zeker dat je dit item definitief wilt verwijderen?';

  @override
  String get itemCreatePageDeleteConfirmationConfirm => 'Verwijderen';

  @override
  String get itemCreatePageDeleteConfirmationCancel => 'Annuleren';

  @override
  String get itemCreatePageGenericError => 'Er is een fout opgetreden.';

  @override
  String get itemCreatePageItemDeletedSuccess =>
      'Het item is succesvol verwijderd.';

  @override
  String get itemCreatePageItemDeleteError =>
      'Het item kon niet worden verwijderd.';
}
