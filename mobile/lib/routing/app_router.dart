import 'package:go_router/go_router.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import 'app_routes.dart';

GoRouter createAppRouter({String initialLocation = AppRoutes.login}) {
  var hasPlayedAuthTrail = false;
  bool claimAuthTrailAnimation() {
    if (hasPlayedAuthTrail) return false;
    hasPlayedAuthTrail = true;
    return true;
  }

  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: '/', redirect: (context, state) => AppRoutes.login),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) =>
            LoginScreen(claimTrailAnimation: claimAuthTrailAnimation),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
