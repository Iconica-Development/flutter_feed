import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

///
class ImageCarousel extends HookWidget {
  /// Creates an [ImageCarousel] widget.
  const ImageCarousel({
    required this.mediaUrls,
    super.key,
  });

  ///
  final List<String> mediaUrls;

  @override
  Widget build(BuildContext context) {
    var pageController = usePageController();
    var currentPage = useState(0);

    useEffect(
      () {
        void listener() {
          if (pageController.page?.round() != currentPage.value) {
            currentPage.value = pageController.page!.round();
          }
        }

        pageController.addListener(listener);
        return () => pageController.removeListener(listener);
      },
      [pageController],
    );

    return SizedBox(
      height: 320,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: mediaUrls.length,
            itemBuilder: (context, index) => CachedNetworkImage(
              imageUrl: mediaUrls[index],
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ),
          if (mediaUrls.length > 1) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  mediaUrls.length,
                  (index) => Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPage.value == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
