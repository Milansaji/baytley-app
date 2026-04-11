import 'package:flutter/material.dart';
import '../../../core/localization/app_locale.dart';
import 'home_content_edit_screen.dart';
import 'about_content_edit_screen.dart';
import 'company_info_edit_screen.dart';
import 'contact_info_edit_screen.dart';

class SettingsMainScreen extends StatelessWidget {
  const SettingsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t('Site Settings', 'إعدادات الموقع')),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSettingsTile(
            context,
            title: context.t('Home Page', 'الصفحة الرئيسية'),
            subtitle: context.t(
              'Hero text, video, and featured titles',
              'نصوص الهيرو والفيديو والعناوين المميزة',
            ),
            icon: Icons.home_rounded,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomeContentEditScreen()),
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            context,
            title: context.t('About Us', 'عن الشركة'),
            subtitle: context.t(
              'Mission, vision, stats, and values',
              'المهمة والرؤية والإحصائيات والقيم',
            ),
            icon: Icons.info_rounded,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutContentEditScreen()),
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            context,
            title: context.t('Company Info', 'معلومات الشركة'),
            subtitle: context.t(
              'Name, branding, and logos',
              'الاسم والهوية والشعارات',
            ),
            icon: Icons.business_rounded,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CompanyInfoEditScreen()),
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            context,
            title: context.t('Contact Details', 'بيانات الاتصال'),
            subtitle: context.t(
              'Address, social media, and hours',
              'العنوان ووسائل التواصل وساعات العمل',
            ),
            icon: Icons.contact_phone_rounded,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ContactInfoEditScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
