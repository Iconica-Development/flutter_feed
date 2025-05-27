# Flutter Timeline

Flutter Timeline is a package which shows a list of posts by a user and it's part of a larger flutter_feed implementing various kind of feeds.
This package also has additional features like liking a post and leaving comments.

## Setup
To use this package, add flutter_feed_timeline as a dependency in your pubspec.yaml file:

```
  flutter_feed_timeline:
    git: 
      url: https://github.com/Iconica-Development/flutter_feed.git
      path: packages/flutter_feed_timeline
```

The package is a complete user story and as such expects localizations to be setup (it does provide it's own localizations).
Make sure you're app entry has `localizationsDelegate: [FlutterFeedLocalizations.delegate]` set.

## How to use
To use the userstory add the following code somewhere in your widget tree:

````
FlutterFeedTimelineUserstory(configuration: FeedTimelineUserStoryConfiguration()),
````

## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/Iconica-Development/flutter_feed/pulls) page.
Commercial support is available if you need help with integration in your app or services.
You can contact us at [support@iconica.nl](mailto:support@iconica.nl).

## Contribute

If you would like to contribute to the package (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Iconica-Development/flutter_feed/pulls).

## Author

This `flutter_feed` for Flutter is developed by [Iconica](https://iconica.nl).
You can contact us at <support@iconica.nl>