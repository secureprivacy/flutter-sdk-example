import 'package:flutter/cupertino.dart';

class SPTextField extends StatelessWidget {
  final String label, hint;
  final ValueChanged<String> onChange;

  const SPTextField({
    required this.label,
    required this.hint,
    required this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 4),
          CupertinoTextField(
            placeholder: hint,
            onChanged: onChange,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            placeholderStyle: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
