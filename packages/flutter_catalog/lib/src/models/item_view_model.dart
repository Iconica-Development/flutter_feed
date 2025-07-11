import "package:flutter_catalog/l10n/app_localizations.dart";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// A data class to manage the state of the item modification form.
class ItemModificationData {
  ///
  const ItemModificationData({
    this.title,
    this.description,
    this.newImages = const [],
    this.existingImageUrls = const [],
    this.customFieldValues = const {},
  });

  /// Creates an [ItemModificationData] from a [CatalogItem].
  factory ItemModificationData.fromItem(CatalogItem item) =>
      ItemModificationData(
        title: item.title,
        description: item.description,
        existingImageUrls: item.imageUrls,
        customFieldValues: item.customFields,
      );

  ///
  final String? title;

  ///
  final String? description;

  ///
  final List<XFile> newImages;

  ///
  final List<String> existingImageUrls;

  /// Custom field values for the item.
  final Map<String, dynamic> customFieldValues;

  ///
  ItemModificationData copyWith({
    String? title,
    String? description,
    List<XFile>? newImages,
    List<String>? existingImageUrls,
    Map<String, dynamic>? customFieldValues,
  }) =>
      ItemModificationData(
        title: title ?? this.title,
        description: description ?? this.description,
        newImages: newImages ?? this.newImages,
        existingImageUrls: existingImageUrls ?? this.existingImageUrls,
        customFieldValues: customFieldValues ?? this.customFieldValues,
      );

  /// Validates the form data. Returns an error message if invalid.
  String? validate(FlutterCatalogLocalizations localizations) {
    if (title == null || title!.isEmpty) {
      return localizations.itemCreatePageTitleRequiredError;
    }
    return null;
  }

  /// Converts the form data to a JSON map suitable for the repository.
  Map<String, dynamic> toJson({required List<String> allImageUrls}) => {
        "title": title,
        "description": description,
        "image_urls": allImageUrls,
        ...customFieldValues,
      };
}
