import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/constants/colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthAuthenticated) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // ── Profile Header ────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.primaryLight : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.border,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        children: [
                          // Avatar
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary.withValues(alpha: 0.7),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Name
                          Text(
                            _displayName(state),
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          // Email
                          Text(
                            state.user.email,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryLight
                                  : AppColors.textSecondaryDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Profile Content ───────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Account Information ───────────────────────────
                        Text(
                          context.t(
                            'Account Information',
                            'معلومات الحساب',
                          ),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Column(
                              children: [
                                _buildProfileInfoTile(
                                  context,
                                  icon: Icons.email_outlined,
                                  label: context.t('Email', 'البريد الإلكتروني'),
                                  value: state.user.email,
                                ),
                                Divider(
                                  height: 24,
                                  color: AppColors.divider,
                                ),
                                _buildProfileInfoTile(
                                  context,
                                  icon: Icons.verified_user,
                                  label: context.t('Account Type', 'نوع الحساب'),
                                  value: context.t('Personal', 'شخصي'),
                                ),
                                Divider(
                                  height: 24,
                                  color: AppColors.divider,
                                ),
                                _buildProfileInfoTile(
                                  context,
                                  icon: Icons.access_time,
                                  label: context.t('Member Since', 'عضو منذ'),
                                  value: '2024',
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Profile Actions ──────────────────────────────
                        Text(
                          context.t('Actions', 'الإجراءات'),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),

                        // Edit Profile Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                            label: Text(
                              context.t('Edit Profile', 'تعديل الملف الشخصي'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Change Password Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.lock_outline),
                            label: Text(
                              context.t('Change Password', 'تغيير كلمة المرور'),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Preferences ──────────────────────────────────
                        Text(
                          context.t('Preferences', 'التفضيلات'),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: Column(
                              children: [
                              
                                Divider(
                                  height: 0,
                                  color: AppColors.divider,
                                ),
                                _buildPreferenceTile(
                                  context,
                                  title: context.t('Privacy', 'الخصوصية'),
                                  subtitle: context.t(
                                    'Control your privacy',
                                    'التحكم في خصوصيتك',
                                  ),
                                  icon: Icons.privacy_tip_outlined,
                                  onTap: () {},
                                ),
                                Divider(
                                  height: 0,
                                  color: AppColors.divider,
                                ),
                              
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Support & Legal ──────────────────────────────
                        Text(
                          context.t('Help & Support', 'المساعدة والدعم'),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: Column(
                              children: [
                                _buildPreferenceTile(
                                  context,
                                  title: context.t('Help Center', 'مركز المساعدة'),
                                  subtitle: context.t(
                                    'Find answers and support',
                                    'ابحث عن الإجابات والدعم',
                                  ),
                                  icon: Icons.help_outline,
                                  onTap: () {},
                                ),
                                Divider(
                                  height: 0,
                                  color: AppColors.divider,
                                ),
                                _buildPreferenceTile(
                                  context,
                                  title: context.t('About', 'عن التطبيق'),
                                  subtitle: context.t(
                                    'Version 1.0.0',
                                    'الإصدار 1.0.0',
                                  ),
                                  icon: Icons.info_outline,
                                  onTap: () {},
                                ),
                                Divider(
                                  height: 0,
                                  color: AppColors.divider,
                                ),
                                _buildPreferenceTile(
                                  context,
                                  title: context.t('Terms & Privacy', 'الشروط والخصوصية'),
                                  subtitle: context.t(
                                    'Read our policies',
                                    'اقرأ سياستنا',
                                  ),
                                  icon: Icons.description_outlined,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Sign Out Button ───────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showSignOutDialog(context);
                            },
                            icon: const Icon(Icons.logout),
                            label: Text(context.t('Sign Out', 'تسجيل الخروج')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
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

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t('Sign Out', 'تسجيل الخروج')),
        content: Text(
          context.t(
            'Are you sure you want to sign out?',
            'هل أنت متأكد أنك تريد تسجيل الخروج؟',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.t('Cancel', 'إلغاء')),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
              Navigator.pop(context);
            },
            child: Text(
              context.t('Sign Out', 'تسجيل الخروج'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
