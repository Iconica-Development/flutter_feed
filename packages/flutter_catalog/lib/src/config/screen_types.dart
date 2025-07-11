/// Defines the different screens within the Catalog user story.
///
/// Used by builders to provide screen-specific layouts.
enum ScreenType {
  /// The main screen displaying the grid of items.
  catalogOverview,

  /// The screen displaying the details of a single item.
  catalogDetail,

  /// The screen for selecting and applying filters.
  catalogFilter,

  /// The screen for selecting sub-filters.
  catalogSubFilter,

  /// The screen for modifying or updating a catalog item.
  catalogModify,
}
