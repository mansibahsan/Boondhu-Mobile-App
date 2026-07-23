import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingsSection(
            title: 'Account',
            children: [
              _buildSettingsTile(Icons.person_outline, 'Personal Information'),
              _buildSettingsTile(Icons.lock_outline, 'Password & Security'),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'Preferences',
            children: [
              _buildSettingsTile(Icons.language, 'Language', trailing: const Text('English')),
              _buildSettingsTile(Icons.dark_mode_outlined, 'Dark Mode', trailing: Switch(value: false, onChanged: (v) {})),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'Support',
            children: [
              _buildSettingsTile(Icons.help_outline, 'Help Center'),
              _buildSettingsTile(Icons.info_outline, 'About Us'),
              _buildSettingsTile(Icons.description_outlined, 'Terms & Conditions'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {Widget? trailing}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
