import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_catalog/l10n/app_localizations.dart";
import "package:flutter_catalog/src/config/screen_types.dart";
import "package:flutter_catalog/src/utils/scope.dart";
import "package:flutter_catalog/src/widgets/image_view_carousel.dart";
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
    var options = scope.options;
    var service = scope.catalogService;
    var isAuthor = scope.userId == item.authorId;
    var isFavorite = useState(item.isFavorited ?? false);

    // ignore: discarded_futures
    var authorFuture = useMemoized(
      () async => item.authorId != null
          ? options.catalogUserRepository.getUser(item.authorId!)
          : Future.value(null),
      [item.authorId],
    );
    var authorSnapshot = useFuture(authorFuture);

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

    var appBar = AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onExit,
      ),
      actions: [
        if (!isAuthor) ...[
          IconButton(
            icon: Icon(
              isFavorite.value ? Icons.favorite : Icons.favorite_border,
              color: Colors.pink,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ],
    );

    var body = SingleChildScrollView(
      child: isAuthor
          ? _MyItemDetailBody(
              item: item,
              onEditItem: onEditItem,
            )
          : _OtherUserItemDetailBody(
              item: item,
              author: authorSnapshot.data,
            ),
    );

    if (options.builders.baseScreenBuilder != null) {
      return options.builders.baseScreenBuilder!(
        context,
        ScreenType.catalogDetail,
        appBar,
        item.title,
        body,
      );
    }

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}

/// The layout for viewing an item owned by the current user.
class _MyItemDetailBody extends StatelessWidget {
  const _MyItemDetailBody({required this.item, required this.onEditItem});
  final CatalogItem item;
  final void Function(CatalogItem item) onEditItem;

  @override
  Widget build(BuildContext context) {
    var options = CatalogScope.of(context).options;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageCarousel(mediaUrls: item.imageUrls),
        _TitleSection(item: item),
        _EditSection(onEdit: () => onEditItem(item)),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.description.isNotEmpty) ...[
                _DescriptionSection(item: item),
                const SizedBox(height: 24),
              ],
              if (item.customFields.isNotEmpty) ...[
                _TagsSection(customFields: item.customFields),
                const SizedBox(height: 24),
              ],
              if (options.builders.detailPageItemBuilder != null)
                options.builders.detailPageItemBuilder!(context, item)
              else
                _MapSection(),
              const SizedBox(height: 18),
              _PostedDate(date: item.postedAt),
            ],
          ),
        ),
      ],
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection({
    required this.item,
  });

  final CatalogItem item;

  @override
  Widget build(BuildContext context) {
    var options = CatalogScope.of(context).options;
    var localizations = FlutterCatalogLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: options.theme.authorSectionBackgroundColor ??
            Theme.of(context).colorScheme.primary.withOpacity(0.4),
      ),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 2),
          Text(
            item.price != null && item.price! > 0
                ? "€${item.price!.toStringAsFixed(2)}"
                : localizations.priceFree,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// The layout for viewing an item owned by another user.
class _OtherUserItemDetailBody extends StatelessWidget {
  const _OtherUserItemDetailBody({required this.item, this.author});
  final CatalogItem item;
  final CatalogUser? author;

  @override
  Widget build(BuildContext context) {
    var options = CatalogScope.of(context).options;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageCarousel(mediaUrls: item.imageUrls),
        _AuthorSection(author: author),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DescriptionSection(item: item),
              const SizedBox(height: 24),
              if (item.customFields.isNotEmpty) ...[
                _TagsSection(customFields: item.customFields),
                const SizedBox(height: 24),
              ],
              if (options.builders.detailPageItemBuilder != null)
                options.builders.detailPageItemBuilder!(context, item)
              else
                _MapSection(),
              const SizedBox(height: 24),
              _PostedDate(date: item.postedAt),
            ],
          ),
        ),
      ],
    );
  }
}

class _AuthorSection extends StatelessWidget {
  const _AuthorSection({required this.author});
  final CatalogUser? author;

  @override
  Widget build(BuildContext context) {
    var options = CatalogScope.of(context).options;
    var localizations = FlutterCatalogLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var backgroundColor = options.theme.authorSectionBackgroundColor ??
        Theme.of(context).colorScheme.primary.withOpacity(0.4);

    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: (author?.avatarUrl?.isNotEmpty ?? false)
                ? CachedNetworkImageProvider(author!.avatarUrl!)
                : null,
            child: (author?.avatarUrl?.isEmpty ?? true)
                ? const Icon(Icons.person)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              author?.name ?? "Unknown User",
              style:
                  textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          if (author != null) ...[
            options.builders.primaryButtonBuilder(
              context,
              onPressed: () => options.onPressContactUser?.call(author!),
              onDisabledPressed: () {
                if (options.onPressContactUser == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations.contactUserDisabledMessage),
                    ),
                  );
                }
              },
              isDisabled: options.onPressContactUser == null,
              child: Text(localizations.sendMessageButton),
            ),
          ],
        ],
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.item});
  final CatalogItem item;

  @override
  Widget build(BuildContext context) {
    var localizations = FlutterCatalogLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.detailDescriptionTitle,
          style: textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(item.description, style: textTheme.bodyMedium),
      ],
    );
  }
}

class _TagsSection extends StatelessWidget {
  const _TagsSection({required this.customFields});
  final Map<String, dynamic> customFields;

  @override
  Widget build(BuildContext context) {
    var localizations = FlutterCatalogLocalizations.of(context)!;
    var textTheme = Theme.of(context).textTheme;
    var chips = <Widget>[];

    customFields.forEach((key, value) {
      if (value is String) {
        chips.add(Chip(label: Text(value)));
      } else if (value is List) {
        for (var val in value) {
          chips.add(Chip(label: Text(val.toString())));
        }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.characteristicsTitle,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: chips,
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

class _EditSection extends StatelessWidget {
  const _EditSection({required this.onEdit});
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    var localizations = FlutterCatalogLocalizations.of(context)!;
    return InkWell(
      onTap: onEdit,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              const Icon(Icons.edit, size: 24),
              const SizedBox(height: 4),
              Text(localizations.editItemButton),
            ],
          ),
        ),
      ),
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

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        localizations.postedSince(formattedDate),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
