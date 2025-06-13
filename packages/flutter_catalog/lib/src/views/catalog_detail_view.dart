import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_catalog/src/services/catalog_service.dart";
import "package:flutter_catalog_interface/flutter_catalog_interface.dart";

/// A view that displays the full details of a single [CatalogItem].
class CatalogDetailView extends StatefulWidget {
  ///
  const CatalogDetailView({
    required this.item,
    required this.catalogService,
    super.key,
  });

  ///
  final CatalogItem item;

  ///
  final CatalogService catalogService;

  @override
  State<CatalogDetailView> createState() => _CatalogDetailViewState();
}

class _CatalogDetailViewState extends State<CatalogDetailView> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.item.isFavorite;
  }

  Future<void> _toggleFavorite() async {
    // Optimistically update the UI
    setState(() {
      _isFavorite = !_isFavorite;
    });

    try {
      await widget.catalogService.toggleFavorite(widget.item);
    } on Exception catch (_) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not update favorite status.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.pink,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageCarousel(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAuthorSection(textTheme),
                  const SizedBox(height: 16),
                  Text(widget.item.title, style: textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    widget.item.price,
                    style: textTheme.titleLarge
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 16),
                  if (widget.item.description != null) ...[
                    Text("Beschrijving", style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(widget.item.description!, style: textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
            _buildMapPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() => SizedBox(
        height: 300,
        child: PageView.builder(
          itemCount: widget.item.mediaUrls.length,
          itemBuilder: (context, index) => CachedNetworkImage(
            imageUrl: widget.item.mediaUrls[index],
            fit: BoxFit.cover,
          ),
        ),
      );

  Widget _buildAuthorSection(TextTheme textTheme) => Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: (widget.item.authorAvatarUrl != null)
                ? CachedNetworkImageProvider(widget.item.authorAvatarUrl!)
                : null,
            child: (widget.item.authorAvatarUrl == null)
                ? const Icon(Icons.person)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.authorName ?? "Unknown User",
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                // You can add a rating widget here
              ],
            ),
          ),
          FilledButton(
            onPressed: () {
              // Handle sending a message
            },
            child: const Text("Stuur bericht"),
          ),
        ],
      );

  Widget _buildMapPlaceholder() => AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.grey[300],
          child: const Center(
            child: Text("Map Placeholder"),
          ),
        ),
      );
}
