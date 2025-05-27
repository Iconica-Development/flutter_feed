import 'app_localizations.dart';

/// The translations for English (`en`).
class FlutterFeedLocalizationsEn extends FlutterFeedLocalizations {
  FlutterFeedLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get timelineEmptyLabel => 'No posts';

  @override
  String get timelinePostDeleteButtonText => 'Delete';

  @override
  String timelinePostLikeCount(int count) {
    return '$count likes';
  }

  @override
  String get timelinePostViewButtonText => 'View post';
}
