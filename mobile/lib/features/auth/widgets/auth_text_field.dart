import 'package:flutter/material.dart';

import 'password_icon.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    this.helper,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.isPassword = false,
    this.passwordName = 'hasło',
    this.compact = false,
    this.onChanged,
  });

  final String label;
  final String hint;
  final String? helper;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final bool isPassword;
  final String passwordName;
  final bool compact;
  final ValueChanged<String>? onChanged;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(
          child: Text(widget.label, style: theme.textTheme.labelMedium),
        ),
        SizedBox(height: widget.compact ? 6 : 8),
        Semantics(
          label: widget.label,
          child: TextField(
            onChanged: widget.onChanged,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.isPassword && !_passwordVisible,
            autocorrect: !widget.isPassword,
            enableSuggestions: !widget.isPassword,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: widget.hint,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 13,
                vertical: widget.compact ? 12 : 14,
              ),
              isDense: true,
              suffixIconColor: theme.colorScheme.onSurfaceVariant,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 52,
                minHeight: 48,
              ),
              suffixIcon: widget.isPassword
                  ? IconButton(
                      tooltip:
                          '${_passwordVisible ? 'Ukryj' : 'Pokaż'} '
                          '${widget.passwordName}',
                      onPressed: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                      icon: PasswordIcon(visible: _passwordVisible),
                    )
                  : null,
            ),
          ),
        ),
        if (widget.helper != null) ...[
          const SizedBox(height: 5),
          Text(
            widget.helper!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}
