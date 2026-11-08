import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/app_routes.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_switch.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_trail.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.claimTrailAnimation});

  final bool Function() claimTrailAnimation;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Zaloguj się',
      subtitle: 'Wróć do swoich miejsc i tras.',
      children: [
        const AuthTextField(
          label: 'E-mail',
          hint: 'anna@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 21),
        const AuthTextField(
          label: 'Hasło',
          hint: 'Wpisz hasło',
          isPassword: true,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 26),
        FilledButton(
          onPressed: () => context.go(AppRoutes.dashboard),
          child: const Text('Zaloguj się'),
        ),
        AuthSwitch(
          prompt: 'Nie masz jeszcze konta?',
          label: 'Utwórz konto',
          onPressed: () => context.push(AppRoutes.register),
        ),
        AuthTrail(claimAnimation: claimTrailAnimation),
      ],
    );
  }
}
