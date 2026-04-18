import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench_and_bolts/core/utils/extensions/go_router_extension.dart';
import 'package:wrench_and_bolts/core/utils/functions.dart';
import 'package:wrench_and_bolts/features/authentication/widget/landing_page.dart';
import 'package:wrench_and_bolts/features/location/widget/location_selection.dart';
import 'package:wrench_and_bolts/features/authentication/widget/auth_detail_section.dart';
import 'package:wrench_and_bolts/features/authentication/widget/auth_notification_alert.dart';
import 'package:wrench_and_bolts/features/authentication/widget/authentication.dart';
import 'package:wrench_and_bolts/features/home/widget/home.dart';
import 'package:wrench_and_bolts/features/notification/widget/notifications.dart';
import 'package:wrench_and_bolts/features/offer/widget/offer.dart';
import 'package:wrench_and_bolts/features/profile/widget/account_setting.dart';
import 'package:wrench_and_bolts/features/profile/widget/pro_profile.dart';
import 'package:wrench_and_bolts/features/profile/widget/profile.dart';
import 'package:wrench_and_bolts/features/profile/widget/saved_address.dart';
import 'package:wrench_and_bolts/features/service/widget/create_service.dart';
import 'package:wrench_and_bolts/features/service/widget/requested_service.dart';
import 'package:wrench_and_bolts/features/service/widget/service_requests.dart';
import 'package:wrench_and_bolts/features/user_info_form/widget/user_info_form.dart';

class RoutePath {
  static const String initial = '/';
  static const String authentication = '/authentication';
  static const String authDetailSection = '/authDetailSection';
  static const String authNotificationAlert = '/authNotificationAlert';
  static const String authConfirmation = '/authConfirmation';
  static const String userInfoForm = '/userInfoForm';
  static const String home = '/home';
  static const String signin = '/signin';
  static const String notifications = '/notifications';
  static const String createService = '/createService';
  static const String serviceRequests = '/serviceRequests';
  static const String proProfile = '/proProfile';
  static const String requestedService = '/requestedService';
  static const String profile = '/profile';
  static const String offer = '/offer';
  static const String accountSetting = '/accountSetting';
  static const String savedAddress = '/savedAddress';
  static const String locationSelection = '/locationSelection';
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
GoRouterState? _currentGoRouterState;
void setCurrentGoRouterState(GoRouterState state, BuildContext context) {
  final currentRoute = GoRouter.of(context).location;
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
          final bool isSignedIn = isLoggedIn();
          return isSignedIn ? Home() : LandingPage();
        },
      ),
      GoRoute(
        path: RoutePath.authentication,
        name: RoutePath.authentication,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final role = extra?['role'] ?? 'customer';
          return Authentication(role: role);
        },
      ),
      GoRoute(
        path: RoutePath.locationSelection,
        name: RoutePath.locationSelection,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return LocationSelection(
            onUseCurrentLocation: extra?['onUseCurrentLocation'] as void
                Function(Map<String, dynamic>)?,
            onManualSelection: extra?['onManualSelection'] as void Function(
                Map<String, dynamic>)?,
          );
        },
      ),
      GoRoute(
        path: RoutePath.authDetailSection,
        name: RoutePath.authDetailSection,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final role = extra?['role'] ?? 'customer';
          return AuthDetailSection(
            role: role,
          );
        },
      ),
      GoRoute(
        path: RoutePath.authNotificationAlert,
        name: RoutePath.authNotificationAlert,
        builder: (context, state) {
          return AuthNotificationAlert();
        },
      ),
      GoRoute(
        path: RoutePath.userInfoForm,
        name: RoutePath.userInfoForm,
        builder: (context, state) {
          return UserInfoForm();
        },
      ),
      GoRoute(
        path: RoutePath.home,
        name: RoutePath.home,
        builder: (context, state) {
          return Home();
        },
      ),
      GoRoute(
        path: RoutePath.notifications,
        name: RoutePath.notifications,
        builder: (context, state) {
          return Notifications();
        },
      ),
      GoRoute(
        path: RoutePath.createService,
        name: RoutePath.createService,
        builder: (context, state) {
          return CreateService();
        },
      ),
      GoRoute(
        path: RoutePath.serviceRequests,
        name: RoutePath.serviceRequests,
        builder: (context, state) {
          return ServiceRequests();
        },
      ),
      GoRoute(
        path: RoutePath.proProfile,
        name: RoutePath.proProfile,
        builder: (context, state) {
          return ProProfile();
        },
      ),
      GoRoute(
        path: RoutePath.requestedService,
        name: RoutePath.requestedService,
        builder: (context, state) {
          return RequestedService();
        },
      ),
      GoRoute(
        path: RoutePath.offer,
        name: RoutePath.offer,
        builder: (context, state) {
          return Offers();
        },
      ),
      GoRoute(
        path: RoutePath.profile,
        name: RoutePath.profile,
        builder: (context, state) {
          return Profile();
        },
      ),
      GoRoute(
        path: RoutePath.accountSetting,
        name: RoutePath.accountSetting,
        builder: (context, state) {
          return AccountSetting();
        },
      ),
      GoRoute(
        path: RoutePath.savedAddress,
        name: RoutePath.savedAddress,
        builder: (context, state) {
          return SavedAddress();
        },
      ),
    ],
  );
}
