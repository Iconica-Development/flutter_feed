import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_catalog/l10n/app_localizations.dart";
import "package:flutter_catalog/src/utils/scope.dart";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:intl/intl.dart";

/// A view that displays the full details of a single [CatalogItem].
class CatalogDetailView extends HookWidget {
  /// Creates a [CatalogDetailView].
  const CatalogDetailView({
    required this.item,
    required this.onEditItem,
    super.key,
    this.onExit,
  });

  /// The item to display.
  final CatalogItem item;

  /// A callback to execute when the user wants to navigate back.
  final VoidCallback? onExit;

  /// A callback to execute when the user wants to edit the item.
  final void Function(CatalogItem item) onEditItem;

  @override
  Widget build(BuildContext context) {
    var scope = CatalogScope.of(context);
    var service = scope.catalogService;
    var isAuthor = scope.userId == item.authorId;
    var isFavorite = useState(item.isFavorited ?? false);

    useEffect(
      () {
        if (onExit == null) return null;
        scope.popHandler.register(onExit!);
        return () => scope.popHandler.unregister(onExit!);
      },
      [onExit],
    );

    Future<void> toggleFavorite() async {
      isFavorite.value = !isFavorite.value;
      try {
        await service.toggleFavorite(item.id);
      } on Exception catch (_) {
        if (!context.mounted) return;
        isFavorite.value = !isFavorite.value;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not update favorite status.")),
        );
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onExit,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite.value ? Icons.favorite : Icons.favorite_border,
              color: Colors.pink,
            ),
            onPressed: toggleFavorite,
          ),
          if (isAuthor)
            IconButton(
              icon: const Icon(Icons.edit),
              // Call the new callback when pressed
              onPressed: () => onEditItem(item),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ImageCarousel(mediaUrls: item.imageUrls),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AuthorSection(item: item),
                  const SizedBox(height: 24),
                  _InfoSection(item: item),
                  const SizedBox(height: 24),
                  _TagsSection(),
                  const SizedBox(height: 24),
                  _MapSection(),
                ],
              ),
            ),
            _PostedDate(date: item.postedAt),
          ],
        ),
      ),
    );
  }
}

// --- Private Helper Widgets ---

class _ImageCarousel extends HookWidget {
  const _ImageCarousel({required this.mediaUrls});
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
          // Page indicator dots
          if (mediaUrls.length > 1)
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
      ),
    );
  }
}

class _AuthorSection extends StatelessWidget {
  const _AuthorSection({required this.item});
  final CatalogItem item;

  @override
  Widget build(BuildContext context) {
    var localizations = FlutterCatalogLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        // CircleAvatar(
        //   radius: 24,
        //   backgroundImage: (item.authorProfileImageUrl != null)
        //       ? CachedNetworkImageProvider(item.authorProfileImageUrl!)
        //       : null,
        //   child: (item.authorProfileImageUrl == null)
        //       ? const Icon(Icons.person)
        //       : null,
        // ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.authorId ?? "Unknown User",
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Row(
                children: [
                  Icon(Icons.star, size: 16, color: Colors.amber),
                  Icon(Icons.star, size: 16, color: Colors.amber),
                  Icon(Icons.star, size: 16, color: Colors.amber),
                  Icon(Icons.star_half, size: 16, color: Colors.amber),
                  Icon(Icons.star_border, size: 16, color: Colors.amber),
                ],
              ),
            ],
          ),
        ),
        FilledButton(
          onPressed: () {},
          child: Text(localizations.sendMessageButton),
        ),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.item});
  final CatalogItem item;

  @override
  Widget build(BuildContext context) {
    var localizations = FlutterCatalogLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.title, style: textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(
          item.price?.toStringAsFixed(2) ?? "Free",
          style: textTheme.titleLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        if (item.description.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            localizations.detailDescriptionTitle,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(item.description, style: textTheme.bodyMedium),
        ],
      ],
    );
  }
}

class _TagsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizations = FlutterCatalogLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    var tags = ["Categorie", "Merk", "4-6 jaar", "Conditie"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.characteristicsTitle, style: textTheme.titleLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: tags.map((tag) => Chip(label: Text(tag))).toList(),
        ),
      ],
    );
  }
}

class _MapSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizations = FlutterCatalogLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.distanceTitle, style: textTheme.titleLarge),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text("Map Placeholder"),
            ),
          ),
        ),
      ],
    );
  }
}

class _PostedDate extends StatelessWidget {
  const _PostedDate({this.date});
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    if (date == null) return const SizedBox.shrink();

    var localizations = FlutterCatalogLocalizations.of(context)!;
    var formattedDate = DateFormat.yMd().format(date!);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          localizations.postedSince(formattedDate),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
