import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pz_mobile/app.dart';
import 'package:pz_mobile/features/auth/screens/login_screen.dart';
import 'package:pz_mobile/features/auth/screens/register_screen.dart';
import 'package:pz_mobile/features/dashboard/screens/dashboard_screen.dart';
import 'package:pz_mobile/routing/app_router.dart';
import 'package:pz_mobile/routing/app_routes.dart';

void main() {
  testWidgets('Auth navigation supports links and system back', (tester) async {
    final router = createAppRouter();
    addTearDown(router.dispose);
    await tester.pumpWidget(TravelJournalApp(router: router));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );

    await tester.tap(find.widgetWithText(TextButton, 'Utwórz konto'));
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsOneWidget);

    await tester.ensureVisible(find.widgetWithText(TextButton, 'Zaloguj się'));
    await tester.tap(find.widgetWithText(TextButton, 'Zaloguj się'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(router.canPop(), isFalse);

    await tester.tap(find.widgetWithText(TextButton, 'Utwórz konto'));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Zaloguj się'));
    await tester.pumpAndSettle();
    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
    expect(router.routeInformationProvider.value.uri.path, AppRoutes.dashboard);
    expect(router.canPop(), isFalse);
  });

  testWidgets('Registration opened directly can return to login', (
    tester,
  ) async {
    final router = createAppRouter(initialLocation: AppRoutes.register);
    addTearDown(router.dispose);
    await tester.pumpWidget(TravelJournalApp(router: router));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    await tester.ensureVisible(find.widgetWithText(TextButton, 'Zaloguj się'));
    await tester.tap(find.widgetWithText(TextButton, 'Zaloguj się'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(router.routeInformationProvider.value.uri.path, AppRoutes.login);
    expect(tester.takeException(), isNull);
  });
}
