import 'package:intl/intl.dart' as intl;

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

  @override
  String timelinePostDetailDate(DateTime date, DateTime time) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);
    final intl.DateFormat timeDateFormat = intl.DateFormat.Hm(localeName);
    final String timeString = timeDateFormat.format(time);

    return '$dateString at $timeString';
  }
}
