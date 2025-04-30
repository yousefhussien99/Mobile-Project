import 'package:flutter/material.dart';

class GenderSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?>? onChanged;

  const GenderSelector({
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
          'Gender',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio<String>(
                  value: 'male',
                  groupValue: selected,
                  onChanged: onChanged,
                ),
                title: const Text('Male'),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio<String>(
                  value: 'female',
                  groupValue: selected,
                  onChanged: onChanged,
                ),
                title: const Text('Female'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
