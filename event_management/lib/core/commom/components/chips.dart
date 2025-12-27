import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final Color? selectedColor;

  const AppChip({
    Key? key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.selectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor:
          selectedColor ??
          Theme.of(context).colorScheme.primary.withOpacity(0.12),
    );
  }
}

class TagChip extends StatelessWidget {
  final String label;
  final VoidCallback? onDeleted;

  const TagChip({Key? key, required this.label, this.onDeleted})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label), onDeleted: onDeleted);
  }
}

class ChoiceChipGroup extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ChoiceChipGroup({
    Key? key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(options.length, (i) {
        return ChoiceChip(
          label: Text(options[i]),
          selected: i == selectedIndex,
          onSelected: (_) => onSelected(i),
        );
      }),
    );
  }
}
