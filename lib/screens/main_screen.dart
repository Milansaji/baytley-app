import 'package:flutter/material.dart';
import '../core/localization/app_locale.dart';
import '../core/constants/colors.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/properties/screens/properties_screen.dart';
import '../features/blog/screens/blog_screen.dart';
import '../features/admin/screens/admin_dashboard.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onTabChange: (index) => setState(() => _currentIndex = index)),
      const PropertiesScreen(),
      const BlogScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isAdmin = state is AuthAuthenticated && state.user.isAdmin;
        final currentScreens = [
          ..._screens,
          if (isAdmin) const AdminDashboard(),
        ];

        return Scaffold(
          body: IndexedStack(index: _currentIndex, children: currentScreens),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              backgroundColor: AppColors.surface,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.secondary,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home_rounded),
                  label: context.t('Home', 'الرئيسية'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.apartment_outlined),
                  activeIcon: const Icon(Icons.apartment_rounded),
                  label: context.t('Properties', 'العقارات'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.article_outlined),
                  activeIcon: const Icon(Icons.article_rounded),
                  label: context.t('Blog', 'المدونة'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline),
                  activeIcon: const Icon(Icons.person),
                  label: context.t('Profile', 'الملف الشخصي'),
                ),
                if (isAdmin)
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.admin_panel_settings_outlined),
                    activeIcon: const Icon(Icons.admin_panel_settings),
                    label: context.t('Admin', 'مسؤول'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
