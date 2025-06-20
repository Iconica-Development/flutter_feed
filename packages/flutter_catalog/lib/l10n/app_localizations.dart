import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of FlutterCatalogLocalizations
/// returned by `FlutterCatalogLocalizations.of(context)`.
///
/// Applications need to include `FlutterCatalogLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: FlutterCatalogLocalizations.localizationsDelegates,
///   supportedLocales: FlutterCatalogLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the FlutterCatalogLocalizations.supportedLocales
/// property.
abstract class FlutterCatalogLocalizations {
  FlutterCatalogLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static FlutterCatalogLocalizations? of(BuildContext context) {
    return Localizations.of<FlutterCatalogLocalizations>(
        context, FlutterCatalogLocalizations);
  }

  static const LocalizationsDelegate<FlutterCatalogLocalizations> delegate =
      _FlutterCatalogLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @overviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Toys near you'**
  String get overviewTitle;

  /// No description provided for @filtersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Find toys...'**
  String get searchHint;

  /// No description provided for @filterButton.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filterButton;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found.'**
  String get noItemsFound;

  /// No description provided for @itemLoadingError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load items.'**
  String get itemLoadingError;

  /// No description provided for @detailDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get detailDescriptionTitle;

  /// No description provided for @applyFiltersButton.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get applyFiltersButton;

  /// No description provided for @sendMessageButton.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get sendMessageButton;

  /// No description provided for @characteristicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Characteristics'**
  String get characteristicsTitle;

  /// No description provided for @distanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceTitle;

  /// Indicates how long ago the item was posted, formatted as a relative date.
  ///
  /// In en, this message translates to:
  /// **'Posted since {date}'**
  String postedSince(Object date);
}

class _FlutterCatalogLocalizationsDelegate
    extends LocalizationsDelegate<FlutterCatalogLocalizations> {
  const _FlutterCatalogLocalizationsDelegate();

  @override
  Future<FlutterCatalogLocalizations> load(Locale locale) {
    return SynchronousFuture<FlutterCatalogLocalizations>(
        lookupFlutterCatalogLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_FlutterCatalogLocalizationsDelegate old) => false;
}

FlutterCatalogLocalizations lookupFlutterCatalogLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return FlutterCatalogLocalizationsEn();
  }

  throw FlutterError(
      'FlutterCatalogLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
