import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child, this.appbar, this.floatingActionButton});

  final Widget child;
  final AppBar? appbar;
  final FloatingActionButton? floatingActionButton;
  final outlinedIcons = const [
    Icons.home_outlined,
    Icons.notifications_outlined,
    Icons.person_outline,
  ];

  final filledIcons = const [
    Icons.home_filled,
    Icons.notifications,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (value) {
          onTap(value, context);
        },
        destinations: [
          _buildNavBarItem(label: 'Home', index: 0),
          _buildNavBarItem(label: 'Notifications', index: 1),
          _buildNavBarItem(label: 'Profile', index: 2),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  NavigationDestination _buildNavBarItem({required String label, required int index,}) {
    return NavigationDestination(
      icon: Icon(outlinedIcons[index]),
      selectedIcon: Icon(filledIcons[index]),
      label: label,
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final GoRouterState route = GoRouterState.of(context);
    final String location = route.location;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/notifications')) {
      return 1;
    }
    if (location.startsWith('/my_profile')) {
      return 2;
    }
    return 0;
  }

  void onTap(int value, BuildContext context) {
    switch (value) {
      case 0:
        return context.go('/home');
      case 1:
        return context.go('/notifications');
      case 2:
        return context.go('/my_profile');
      default:
        return context.go('/home');
    }
  }
}
