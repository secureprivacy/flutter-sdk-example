import 'package:example_mobile_consent/support/sp_app_colors.dart';
import 'package:flutter/material.dart';

class SPButton extends StatefulWidget {
  final String label;
  final Future Function() onTap;
  final Color backgroundColor;
  final Color labelColor;
  final bool allCaps;

  const SPButton({
    super.key,
    required this.label,
    required this.onTap,
    this.backgroundColor = SPAppColors.primary,
    this.labelColor = SPAppColors.onPrimary,
    this.allCaps = true,
  });

  @override
  State<SPButton> createState() => _SPButtonState();
}

class _SPButtonState extends State<SPButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        setState(() => _isLoading = true);
        await widget.onTap();
        if (mounted) setState(() => _isLoading = false);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: EdgeInsets.symmetric(vertical: 6),
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
              visible: !_isLoading,
              child: Text(
                widget.label.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.labelColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: const Center(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
