import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/app_routes.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_switch.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/registration_trail.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _profileName = '';
  String _email = '';
  String _password = '';
  String _confirmation = '';
  int _stage = 0;

  void _updateStage() {
    final stage = _profileName.trim().isEmpty
        ? 0
        : _email.trim().isEmpty
        ? 1
        : _password.isEmpty || _confirmation.isEmpty
        ? 2
        : 3;
    if (_stage != stage) setState(() => _stage = stage);
  }

  void _goToLogin(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Utwórz konto',
      subtitle: 'Zacznij zapisywać swoje podróże.',
      isRegistration: true,
      children: [
        AuthTextField(
          label: 'Nazwa profilu',
          hint: 'Jak się nazywasz?',
          helper: 'Możesz ją później zmienić w profilu.',
          compact: true,
          onChanged: (value) {
            _profileName = value;
            _updateStage();
          },
        ),
        const SizedBox(height: 12),
        AuthTextField(
          label: 'E-mail',
          hint: 'anna@example.com',
          keyboardType: TextInputType.emailAddress,
          compact: true,
          onChanged: (value) {
            _email = value;
            _updateStage();
          },
        ),
        const SizedBox(height: 19),
        const Divider(),
        const SizedBox(height: 20),
        AuthTextField(
          label: 'Hasło',
          hint: 'Wpisz hasło',
          isPassword: true,
          helper: 'Co najmniej 6 znaków.',
          compact: true,
          onChanged: (value) {
            _password = value;
            _updateStage();
          },
        ),
        const SizedBox(height: 12),
        AuthTextField(
          label: 'Powtórz hasło',
          hint: 'Wpisz hasło ponownie',
          isPassword: true,
          passwordName: 'powtórzone hasło',
          textInputAction: TextInputAction.done,
          compact: true,
          onChanged: (value) {
            _confirmation = value;
            _updateStage();
          },
        ),
        const SizedBox(height: 18),
        RegistrationTrail(stage: _stage),
        const SizedBox(height: 20),
        const FilledButton(onPressed: null, child: Text('Utwórz konto')),
        AuthSwitch(
          prompt: 'Masz już konto?',
          label: 'Zaloguj się',
          onPressed: () => _goToLogin(context),
          topSpacing: 22,
        ),
        const SizedBox(height: 6),
        Text(
          'Nowe konto ma profil prywatny.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 11, height: 1.5),
        ),
      ],
    );
  }
}
