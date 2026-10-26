import "package:flutter/material.dart";
import "package:flutter_catalog/l10n/app_localizations.dart";
import "package:flutter_catalog/src/views/catalog_modify_view.dart";

/// A section with a title and an optional input widget.
class InputSection extends StatelessWidget {
  /// Creates a section with a title and an optional input widget.
  const InputSection({
    required this.title,
    this.input,
    this.onTap,
    this.mandatory = false,
    super.key,
  });

  /// The title of the section.
  final String title;

  /// Whether the section is mandatory.
  final bool mandatory;

  /// The input widget to display in the section.
  final Widget? input;

  /// Callback function to be called when the section is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var localizations = FlutterCatalogLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline,
                width: 1.0,
                style: BorderStyle.solid,
              ),
            ),
            color: const Color(0xFFC3E4EB),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: itemModificationScreenSidePadding,
            vertical: 12,
          ).copyWith(
            right: 12,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: textTheme.titleSmall,
              ),
              const SizedBox(width: 4),
              if (mandatory) ...[
                Text(
                  "(${localizations.itemCreatePageMandatorySection})",
                  style: textTheme.labelSmall,
                ),
              ],
              if (onTap != null) ...[
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  splashRadius: 16,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  iconSize: 24,
                  onPressed: onTap,
                ),
              ],
            ],
          ),
        ),
        if (input != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: itemModificationScreenSidePadding,
              vertical: 24,
            ),
            child: input,
          ),
        ],
      ],
    );
  }
}
