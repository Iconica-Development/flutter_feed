import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of FlutterFeedLocalizations
/// returned by `FlutterFeedLocalizations.of(context)`.
///
/// Applications need to include `FlutterFeedLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: FlutterFeedLocalizations.localizationsDelegates,
///   supportedLocales: FlutterFeedLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the FlutterFeedLocalizations.supportedLocales
/// property.
abstract class FlutterFeedLocalizations {
  FlutterFeedLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static FlutterFeedLocalizations? of(BuildContext context) {
    return Localizations.of<FlutterFeedLocalizations>(
        context, FlutterFeedLocalizations);
  }

  static const LocalizationsDelegate<FlutterFeedLocalizations> delegate =
      _FlutterFeedLocalizationsDelegate();

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

  /// Label shown when there are no posts to display in a timeline
  ///
  /// In en, this message translates to:
  /// **'No posts'**
  String get timelineEmptyLabel;

  /// Text of the button shown in the dropdown on a post in the timeline to delete an item
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get timelinePostDeleteButtonText;

  /// Label shown on the timeline indicating how many likes a post has
  ///
  /// In en, this message translates to:
  /// **'{count} likes'**
  String timelinePostLikeCount(int count);

  /// Text of the button shown on posts to navigate to the detail view
  ///
  /// In en, this message translates to:
  /// **'View post'**
  String get timelinePostViewButtonText;

  /// Label shown on the detail of a post indicating the author date
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String timelinePostDetailDate(DateTime date, DateTime time);
}

class _FlutterFeedLocalizationsDelegate
    extends LocalizationsDelegate<FlutterFeedLocalizations> {
  const _FlutterFeedLocalizationsDelegate();

  @override
  Future<FlutterFeedLocalizations> load(Locale locale) {
    return SynchronousFuture<FlutterFeedLocalizations>(
        lookupFlutterFeedLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_FlutterFeedLocalizationsDelegate old) => false;
}

FlutterFeedLocalizations lookupFlutterFeedLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return FlutterFeedLocalizationsEn();
  }

  throw FlutterError(
      'FlutterFeedLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
