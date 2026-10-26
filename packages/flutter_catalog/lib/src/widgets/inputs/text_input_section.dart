import "package:flutter/material.dart";
import "package:flutter_catalog/src/widgets/inputs/input_section.dart";

///
class TextInputSection extends StatelessWidget {
  ///
  const TextInputSection({
    required this.title,
    required this.label,
    this.value,
    this.onChanged,
    this.onTap,
    this.mandatory = false,
    super.key,
  });

  ///
  final String title;

  ///
  final String label;

  ///
  final String? value;

  ///
  final ValueChanged<String>? onChanged;

  ///
  final VoidCallback? onTap;

  ///
  final bool mandatory;

  @override
  Widget build(BuildContext context) => InputSection(
        title: title,
        onTap: onTap,
        mandatory: mandatory,
        input: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            decoration: InputDecoration(labelText: label),
            initialValue: value,
            onChanged: onChanged,
          ),
        ),
      );
}
