import 'package:flutter/material.dart';

class AuthSwitch extends StatelessWidget {
  const AuthSwitch({
    super.key,
    required this.prompt,
    required this.label,
    required this.onPressed,
    this.topSpacing = 27,
  });

  final String prompt;
  final String label;
  final VoidCallback onPressed;
  final double topSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: topSpacing),
        const Divider(),
        const SizedBox(height: 14),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 5,
          children: [
            Text(prompt),
            TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                textStyle: const TextStyle(
                  fontFamily: 'Onest',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontVariations: [FontVariation('wght', 650)],
                ),
              ),
              child: Text(label),
            ),
          ],
        ),
      ],
    );
  }
}
