import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutePath {
  static const String initial = '/';

}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
GoRouterState? _currentGoRouterState;
void setCurrentGoRouterState(GoRouterState state, BuildContext context) {
  final currentRoute = state.matchedLocation;
  if (currentRoute == state.fullPath) {
    _currentGoRouterState = state;
  }
}

GoRouterState? getCurrentGoRouterState() => _currentGoRouterState;

class Routing {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: RoutePath.initial,
        name: RoutePath.initial,
        builder: (context, state) {
          return const PlaceholderPage();
        },
      ),

    ],
  );
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
