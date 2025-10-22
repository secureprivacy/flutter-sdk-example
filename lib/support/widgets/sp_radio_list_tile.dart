import 'package:flutter/material.dart';
import 'package:example_mobile_consent/support/sp_app_colors.dart';

class SPRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChange;
  final String title;
  final String? subTitle;

  const SPRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChange,
    required this.title,
    this.subTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChange(value),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            value == groupValue
                ? const Icon(
                    Icons.radio_button_checked,
                    color: SPAppColors.primary,
                    size: 28,
                  )
                : const Icon(Icons.radio_button_unchecked, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: TextStyle(fontSize: 14)),
                  if (subTitle != null)
                    Text(subTitle!, style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
