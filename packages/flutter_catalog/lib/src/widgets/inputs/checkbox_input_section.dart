import "package:flutter/material.dart";
import "package:flutter_catalog/src/widgets/inputs/input_section.dart";

///
class CheckboxInputSection<T> extends StatelessWidget {
  ///
  const CheckboxInputSection({
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onOptionToggled,
    required this.optionLabelBuilder,
    this.conditionalChildren,
    this.mandatory = false,
    this.gridCrossAxisCount = 1,
    super.key,
  });

  /// The title of the section.
  final String title;

  /// Whether the section is mandatory.
  final bool mandatory;

  /// The options to display in the section.
  final List<T> options;

  /// The currently selected options.
  final List<T> selectedOptions;

  /// Callback function to be called when an option is toggled.
  final ValueChanged<T> onOptionToggled;

  /// Function to build the label for each option.
  final String Function(T) optionLabelBuilder;

  /// Optional map of conditional children widgets based on selected options.
  final Map<T, Widget>? conditionalChildren;

  /// The number of columns in the grid layout.
  final int gridCrossAxisCount;

  Widget _buildList(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        ...options.map(
          (option) => CheckboxListTile(
            title: Text(
              optionLabelBuilder(option),
              style: textTheme.labelSmall,
            ),
            value: selectedOptions.contains(option),
            onChanged: (_) => onOptionToggled(option),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridCrossAxisCount,
        childAspectRatio: 3.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 0,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        var option = options[index];
        return InkWell(
          onTap: () => onOptionToggled(option),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: selectedOptions.contains(option),
                onChanged: (_) => onOptionToggled(option),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  optionLabelBuilder(option),
                  style: textTheme.labelSmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => InputSection(
        title: title,
        mandatory: mandatory,
        input: Column(
          children: [
            if (gridCrossAxisCount > 1)
              _buildGrid(context)
            else
              _buildList(context),
            if (conditionalChildren != null)
              ...selectedOptions
                  .where((opt) => conditionalChildren!.containsKey(opt))
                  .map((opt) => conditionalChildren![opt]!),
          ],
        ),
      );
}
