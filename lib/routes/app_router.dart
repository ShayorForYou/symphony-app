import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../common/bottom_navigation.dart';
import '../screens/device_specs.dart';
import '../screens/error.dart';
import '../screens/home.dart';
import '../screens/lso_query.dart';
import '../screens/service_center.dart';
import '../screens/social.dart';
import '../screens/support.dart';
import '../screens/web_view.dart';

class GoRoutes {
  static const String home = '/home';

  static const String webview = '/webview';

  static const String social = '/social';

  static const String serviceCenter = '/service-center';

  static const String specification = '/specification';

  static const String support = '/support';

  static const String lsoQuery = '/lso-query';

  static String getHomeRoute() => home;

  static String getWebRoute() => webview;

  static String getSocialsRoute() => social;

  static String getServiceCenterRoute() => serviceCenter;

  static String getDeviceSpecificationRoute() => specification;

  static String getSupportRoute() => support;

  static String getLsoQueryRoute() => lsoQuery;
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  errorBuilder: (context, state) => const ErrorScreen(),
  initialLocation: GoRoutes.getHomeRoute(),
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainWrapper(child: child),
      routes: [
        GoRoute(
          path: GoRoutes.getHomeRoute(),
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: GoRoutes.getServiceCenterRoute(),
          builder: (context, state) => const ServiceCenter(),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: GoRoutes.getLsoQueryRoute(),
          builder: (context, state) => const LsoQuery(),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: GoRoutes.getSupportRoute(),
          builder: (context, state) => const SupportScreen(),
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: GoRoutes.getDeviceSpecificationRoute(),
          builder: (context, state) => const DeviceSpecification(),
        ),
        GoRoute(
          path: GoRoutes.getWebRoute(),
          builder: (context, state) => const Web(),
        ),
        GoRoute(
          path: GoRoutes.getSocialsRoute(),
          builder: (context, state) => const Social(),
        ),
      ],
    ),
  ],
);

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
    ),
  );
}
