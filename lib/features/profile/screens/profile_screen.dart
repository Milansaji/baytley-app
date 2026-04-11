import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/localization/app_locale.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _displayName(AuthAuthenticated state) {
    if (state.user.name.isNotEmpty) return state.user.name;

    final email = state.user.email;
    if (email.contains('@')) {
      return email.split('@').first;
    }
    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t('Profile', 'الملف الشخصي'))),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthAuthenticated) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(_displayName(state)),
                    subtitle: Text(state.user.email),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                    icon: const Icon(Icons.logout),
                    label: Text(context.t('Sign Out', 'تسجيل الخروج')),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Text(
              context.t('No user signed in', 'لا يوجد مستخدم مسجل الدخول'),
            ),
          );
        },
      ),
    );
  }
}
