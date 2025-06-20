import "package:flutter/material.dart";
import "package:flutter_catalog/src/config/screen_types.dart";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// A class that holds all the custom UI builders for the catalog user story.
class CatalogBuilders {
  /// Constructs a [CatalogBuilders].
  const CatalogBuilders({
    this.baseScreenBuilder,
    this.itemCardBuilder,
    this.loadingIndicatorBuilder,
    this.errorPlaceholderBuilder,
    this.noItemsPlaceholderBuilder,
    this.filterSectionBuilder,
  });

  /// A builder for the main screen layout.
  ///
  /// This allows the consuming app to wrap the user story's screens with its
  /// own layout, such as adding a [BottomNavigationBar]. The package provides
  /// the [appBar] and [body] to be placed within the custom layout.
  final BaseScreenBuilder? baseScreenBuilder;

  /// A builder for the item card displayed in the overview grid.
  ///
  /// If not provided, a default [CatalogGridItem] will be used.
  final Widget Function(
    BuildContext context,
    CatalogItem item,
    VoidCallback onTap,
  )? itemCardBuilder;

  /// A builder for the loading indicator shown while fetching items.
  final WidgetBuilder? loadingIndicatorBuilder;

  /// A builder for the placeholder widget shown when an error occurs.
  final Widget Function(BuildContext context, Object? error)?
      errorPlaceholderBuilder;

  /// A builder for the placeholder widget shown when no items are found.
  final WidgetBuilder? noItemsPlaceholderBuilder;

  /// A builder for a single filter section on the filter screen.
  ///
  /// - [title]: The name of the filter (e.g., "Condition").
  /// - [child]: The widget that contains the filter's interactive controls
  ///   (e.g., checkboxes, sliders).
  final Widget Function(BuildContext context, String title, Widget child)?
      filterSectionBuilder;
}

/// The base screen builder signature.
///
/// - [context]: The build context.
/// - [screenType]: The type of screen being built.
/// - [appBar]: The pre-built [AppBar] for the screen.
/// - [title]: The recommended title for the screen.
/// - [body]: The main content widget for the screen.
typedef BaseScreenBuilder = Widget Function(
  BuildContext context,
  ScreenType screenType,
  PreferredSizeWidget appBar,
  String? title,
  Widget body,
);
