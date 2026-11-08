import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth_background.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.isRegistration = false,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool isRegistration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.sizeOf(context);
    final gutter = screenSize.width <= 355 ? 20.0 : 24.0;
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    final topPadding = keyboardVisible
        ? 24.0
        : isRegistration
        ? (screenSize.height * 0.075).clamp(32.0, 72.0)
        : (screenSize.height * 0.12).clamp(64.0, 128.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              AuthBackground(isRegistration: isRegistration),
              Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(
                      gutter,
                      topPadding,
                      gutter,
                      32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            title,
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: isRegistration ? 18 : 27),
                        ...children,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
