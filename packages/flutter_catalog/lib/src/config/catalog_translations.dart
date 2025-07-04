///
class CatalogTranslations {
  /// Creates an instance of [CatalogTranslations] with all translations
  /// required
  const CatalogTranslations({
    required this.overviewTitle,
    required this.searchHint,
  });

  /// Creates an empty instance of [CatalogTranslations] with null values, the
  /// null values
  const CatalogTranslations.empty({
    this.overviewTitle,
    this.searchHint,
  });

  /// The title for the catalog overview screen. If not provided the localized
  /// translation will be used that is "Browse Catalog" for English.
  final String? overviewTitle;

  /// The hint text for the search field in the catalog overview screen.
  /// If not provided the localized translation will be used that is "Search
  /// items..." for English.
  final String? searchHint;
}
