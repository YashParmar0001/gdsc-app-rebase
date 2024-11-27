import 'package:flutter/cupertino.dart';
import 'package:gdsc_atmiya/common/ui/app_scaffold.dart';
import 'package:gdsc_atmiya/features/auth/screens/auth_screen.dart';
import 'package:gdsc_atmiya/features/home/screens/club_members_screen.dart';
import 'package:gdsc_atmiya/features/home/screens/core_team_screen.dart';
import 'package:gdsc_atmiya/features/home/screens/edit_event_screen.dart';
import 'package:gdsc_atmiya/features/home/screens/event_details_screen.dart';
import 'package:gdsc_atmiya/features/home/screens/publish_event_screen.dart';
import 'package:gdsc_atmiya/features/notifications/screens/announcement_screen.dart';
import 'package:gdsc_atmiya/features/notifications/screens/notifications_screen.dart';
import 'package:gdsc_atmiya/features/profile/screens/edit_profile_screen.dart';
import 'package:gdsc_atmiya/features/profile/screens/my_profile_screen.dart';
import 'package:gdsc_atmiya/features/profile/screens/profile_screen.dart';
import 'package:gdsc_atmiya/model/event_model.dart';
import 'package:gdsc_atmiya/model/user_model.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/screens/log_in_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home drawer/screens/about_us.dart';
import 'features/home/screens/home_screen.dart';
import 'features/notifications/screens/announcement_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/auth',
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/club-members',
      builder: (context, state) => const ClubMemberScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/login',
      builder: (context, state) => const LogInScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/edit_profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/core_team',
      builder: (context, state) => const CoreTeamScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/profile',
      builder: (context, state) =>
          ProfileScreen(user: state.extra! as UserModel),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/publish_event',
      builder: (context, state) => const PublishEventScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/edit_event',
      builder: (context, state) =>
          EditEventScreen(event: state.extra! as Event),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/announcement',
      builder: (context, state) => const AnnouncementScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/aboutUs',
      builder: (context, state) => const AboutUsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/event_details',
      builder: (context, state) =>
          EventDetailsScreen(event: state.extra! as Event),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppScaffold(child: child),
      routes: [
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: '/home',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const HomeScreen(),
              transitionDuration: Duration.zero,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: '/notifications',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const NotificationsScreen(),
              transitionDuration: Duration.zero,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: '/my_profile',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: const MyProfileScreen(),
              transitionDuration: Duration.zero,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return child;
              },
            );
          },
        ),
      ],
    ),
  ],
);
