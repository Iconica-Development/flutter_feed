import "package:dart_feed_utilities/filters.dart";
import "package:flutter/material.dart";

/// A view that allows the user to configure and apply filters.
///
/// This view uses the [FilterService] to display available filters and
/// lets the user modify their values.
class CatalogFilterView extends StatelessWidget {
  /// Creates a [CatalogFilterView].
  const CatalogFilterView({required this.filterService, super.key});

  /// The service that manages filter state.
  final FilterService filterService;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Filters"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildSectionTitle(context, "Conditie", "(verplicht)"),
                    _buildCheckboxOption(context, "Zo goed als nieuw", true),
                    // ... add other static filter options for the demo
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    // In a real app, you would save the filter values
                    // using `filterService.setFilterValue(...)`
                    Navigator.of(context).pop();
                  },
                  child: const Text("Filters toepassen"),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    var textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(title, style: textTheme.headlineSmall),
          const SizedBox(width: 8),
          Text(subtitle, style: textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(BuildContext context, String title, bool value) =>
      CheckboxListTile(
        title: Text(title),
        value: value,
        onChanged: (newValue) {
          // Handle state change
        },
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
      );
}
