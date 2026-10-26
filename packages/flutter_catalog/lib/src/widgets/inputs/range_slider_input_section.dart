import "package:flutter/material.dart";

/// A self-contained widget that displays a section with a RangeSlider,
/// complete with its own title and background.
class RangeSliderInputSection extends StatelessWidget {
  /// Creates a [RangeSliderInputSection].
  const RangeSliderInputSection({
    required this.title,
    required this.min,
    required this.max,
    required this.values,
    required this.onChanged,
    super.key,
  });

  /// The title of the section.
  final String title;

  /// The minimum and maximum values for the RangeSlider.
  final int min;

  /// The maximum value for the RangeSlider.
  final int max;

  /// The current values of the RangeSlider.
  final RangeValues values;

  /// A callback that is called when the RangeSlider values change.
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainer,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            RangeSlider(
              values: values,
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: max - min,
              labels: RangeLabels(
                values.start.round().toString(),
                values.end.round().toString(),
              ),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
