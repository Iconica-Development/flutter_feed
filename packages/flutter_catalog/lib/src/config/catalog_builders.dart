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
    this.detailPageItemBuilder,
    this.primaryButtonBuilder = _defaultPrimaryButtonBuilder,
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

  /// A builder for the detail page item.
  /// This allows customization of how each item is displayed on the detail
  /// page. This only adds more content to the detail page, it does not
  /// replace the default content.
  final DetailPageItemBuilder? detailPageItemBuilder;

  /// A builder for primary action buttons, like the 'Save' button.
  ///
  /// If not provided, a default [ElevatedButton] will be used.
  final PrimaryButtonBuilder primaryButtonBuilder;

  /// The default builder for the primary button.
  static Widget _defaultPrimaryButtonBuilder(
    BuildContext context, {
    required VoidCallback onPressed,
    // onDisabledPressed is ignored by the default implementation
    // as a standard ElevatedButton is not clickable when disabled.
    required VoidCallback onDisabledPressed,
    required bool isDisabled,
    required Widget child,
  }) =>
      ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        child: child,
      );
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

/// A builder for a primary action button.
///
/// - [onPressed]: The callback for when the button is pressed and enabled.
/// - [onDisabledPressed]: The callback for when the button is pressed but
/// disabled.
/// - [isDisabled]: Whether the button should be in a disabled state.
/// - [child]: The widget to display inside the button.
typedef PrimaryButtonBuilder = Widget Function(
  BuildContext context, {
  required VoidCallback onPressed,
  required VoidCallback onDisabledPressed,
  required bool isDisabled,
  required Widget child,
});

/// A builder for the detail page item.
typedef DetailPageItemBuilder = Widget Function(
  BuildContext context,
  CatalogItem item,
);
