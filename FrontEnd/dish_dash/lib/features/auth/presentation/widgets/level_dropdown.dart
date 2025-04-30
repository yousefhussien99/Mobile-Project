import 'package:flutter/material.dart';

class LevelDropdown extends StatelessWidget {
  final int? selected;
  final ValueChanged<int?>? onChanged;

  const LevelDropdown({
    Key? key,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Level',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: selected,
          items: const [
            DropdownMenuItem(value: 1, child: Text('Level 1')),
            DropdownMenuItem(value: 2, child: Text('Level 2')),
            DropdownMenuItem(value: 3, child: Text('Level 3')),
            DropdownMenuItem(value: 4, child: Text('Level 4')),
          ],
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),

            hintText: 'Select level',
          ),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
      ],
    );
  }
}
