// ignore_for_file: discarded_futures

import "dart:math" as math;

import "package:cached_network_image/cached_network_image.dart";
import "package:carousel/carousel.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_catalog/l10n/app_localizations.dart";
import "package:flutter_catalog/src/utils/scope.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:image_picker/image_picker.dart";

///
class ImageSelection extends HookWidget {
  ///
  const ImageSelection({
    required this.existingImageUrls,
    required this.newImages,
    required this.onNewImagesChanged,
    required this.onExistingImagesChanged,
    super.key,
  });

  /// The list of existing image URLs.
  final List<String> existingImageUrls;

  /// The list of new image files.
  final List<XFile> newImages;

  /// Callback when new images are selected.
  final ValueChanged<List<XFile>> onNewImagesChanged;

  /// Callback when existing images are changed.
  final ValueChanged<List<String>> onExistingImagesChanged;

  @override
  Widget build(BuildContext context) {
    var options = CatalogScope.of(context).options;
    var picker = ImagePicker();
    var allItems = [...existingImageUrls, ...newImages];
    var localizations = FlutterCatalogLocalizations.of(context)!;

    var currentPage = useState(0);

    Future<void> pickImages() async {
      var pickedFiles = await picker.pickMultiImage();
      onNewImagesChanged([...newImages, ...pickedFiles]);
    }

    void deleteImage(int index) {
      if (index < existingImageUrls.length) {
        var updatedUrls = List<String>.from(existingImageUrls)..removeAt(index);
        onExistingImagesChanged(updatedUrls);
      } else {
        var newImageIndex = index - existingImageUrls.length;
        var updatedNewImages = List<XFile>.from(newImages)
          ..removeAt(newImageIndex);
        onNewImagesChanged(updatedNewImages);
      }
    }

    Widget buildImageCard(BuildContext context, int index) {
      if (index < 0 || index >= allItems.length) {
        return const SizedBox.shrink();
      }

      var item = allItems[index];

      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 250,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: item is String
                  ? CachedNetworkImage(
                      imageUrl: item,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : _XFileImage(file: item as XFile),
            ),
          ),
          // The delete button is now on every card
          Positioned(
            top: 0,
            left: 0, // Positioned on the left
            child: Material(
              color: Colors.black54,
              // Adjusted border radius for the new corner
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.white),
                splashRadius: 20,
                onPressed: () => deleteImage(index),
                tooltip: "Delete Image",
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (allItems.isEmpty)
          _buildImagePlaceholder(onTap: pickImages)
        else ...[
          Carousel(
            pageViewHeight: 250,
            alignment: Alignment.center,
            onPageChanged: (index) {
              currentPage.value = index;
            },
            allowInfiniteScrollingBackwards: false,
            selectableCardId: 0,
            transforms: [
              CardTransform(x: 0, y: 0, angle: 0, scale: 1, opacity: 1.0),
              CardTransform(
                x: 110,
                y: -60,
                angle: math.pi / 12,
                scale: 0.7,
                opacity: 0.8,
              ),
              CardTransform(
                x: 200,
                y: -75,
                angle: -math.pi / 12,
                scale: 0.6,
                opacity: 0.6,
              ),
              CardTransform(
                x: 230,
                y: -80,
                angle: math.pi / 12,
                scale: 0.5,
                opacity: 0.4,
              ),
              CardTransform(
                x: 220,
                y: -85,
                angle: -math.pi / 12,
                scale: 0.3,
                opacity: 0.2,
              ),
            ],
            builder: buildImageCard,
          ),
        ],
        const SizedBox(height: 16),
        options.builders.primaryButtonBuilder(
          context,
          onPressed: pickImages,
          onDisabledPressed: () {},
          isDisabled: false,
          child: Text(localizations.itemCreatePageAddImagesButton),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder({required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Colors.grey.shade400,
              width: 2.0,
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.grey.shade600,
              size: 60,
            ),
          ),
        ),
      );
}

/// A helper widget to display an XFile image without flickering.
/// It is now a HookWidget to memoize the future.
class _XFileImage extends HookWidget {
  const _XFileImage({required this.file});
  final XFile file;

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (kIsWeb) {
      image = Image.network(file.path, fit: BoxFit.cover);
    } else {
      var imageFuture = useMemoized(file.readAsBytes, [file.path]);
      var snapshot = useFuture(imageFuture);

      if (snapshot.hasData) {
        image = Image.memory(snapshot.data!, fit: BoxFit.cover);
      } else {
        image = const Center(child: CircularProgressIndicator.adaptive());
      }
    }

    return SizedBox.expand(child: image);
  }
}
