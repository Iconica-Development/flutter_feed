import "package:flutter/material.dart";
import "package:flutter_catalog/src/widgets/inputs/input_section.dart";

/// A generic widget that displays a section with a list of selectable
/// checkboxes, arranged in a list or a grid.
class CheckboxInputSection<T> extends StatelessWidget {
  /// Creates a [CheckboxInputSection].
  const CheckboxInputSection({
    required this.title,
    required this.options,
    required this.selectedKeys,
    required this.keySelector,
    required this.labelSelector,
    required this.onOptionToggled,
    this.isMultiSelect = true,
    this.mandatory = false,
    this.gridCrossAxisCount = 1,
    super.key,
  });

  /// The title of the section.
  final String title;

  /// The list of all available option objects.
  final List<T> options;

  /// A list of the keys of the currently selected options.
  final List<String> selectedKeys;

  /// A function that returns a unique string key for a given option [T].
  final String Function(T option) keySelector;

  /// A function that returns the display string for a given option [T].
  final String Function(T option) labelSelector;

  /// A callback that is fired when a checkbox is toggled.
  /// It returns the key of the toggled option.
  final ValueChanged<String> onOptionToggled;

  /// Whether multiple options can be selected.
  final bool isMultiSelect;

  /// Whether the section is marked as mandatory.
  final bool mandatory;

  /// The number of columns to use if displayed as a grid.
  final int gridCrossAxisCount;
  @override
  Widget build(BuildContext context) => InputSection(
        title: title,
        mandatory: mandatory,
        input: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridCrossAxisCount,
            childAspectRatio: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 0,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            var option = options[index];
            var key = keySelector(option);
            var label = labelSelector(option);
            var isSelected = selectedKeys.contains(key);

            return InkWell(
              onTap: () => onOptionToggled(key),
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => onOptionToggled(key),
                  ),
                  Expanded(child: Text(label)),
                ],
              ),
            );
          },
        ),
      );
}
