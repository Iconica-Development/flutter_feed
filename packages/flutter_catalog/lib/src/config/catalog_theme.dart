import "package:flutter/material.dart";

/// A class that holds all the theme and style configurations for the
/// catalog user story.
class CatalogTheme {
  /// Constructs a [CatalogTheme].
  const CatalogTheme({
    this.filterBarBackgroundColor,
  });

  /// The background color of the persistent filter bar on the overview screen.
  ///
  /// If not provided, it defaults to
  /// `Theme.of(context).colorScheme.secondaryContainer`.
  final Color? filterBarBackgroundColor;
}
