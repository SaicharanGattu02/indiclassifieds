
import 'package:flutter/material.dart';

import '../theme/ThemeHelper.dart';

class ChipSelector extends StatefulWidget {
  final String title;
  final List<Map<String, String>> options;
  final Function(String) onSelected;
  final String? initialValue;

  const ChipSelector({
    Key? key,
    required this.title,
    required this.options,
    required this.onSelected,
    this.initialValue,
  }) : super(key: key);

  @override
  _ChipSelectorState createState() => _ChipSelectorState();
}

class _ChipSelectorState extends State<ChipSelector> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final textColor = ThemeHelper.textColor(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: widget.options.map((opt) {
            return ChoiceChip(
              label: Text(opt["label"]!, style: const TextStyle(fontSize: 14)),
              selected: _selectedValue == opt["value"],
              selectedColor: primaryColor.withOpacity(0.15),
              labelStyle: TextStyle(
                color: _selectedValue == opt["value"] ? primaryColor : textColor,
                fontWeight: _selectedValue == opt["value"]
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
              onSelected: (_) {
                setState(() {
                  _selectedValue = opt["value"];
                });
                widget.onSelected(opt["value"]!);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: _selectedValue == opt["value"]
                      ? primaryColor
                      : Colors.grey.shade400,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
