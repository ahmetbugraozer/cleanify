import 'package:flutter/material.dart';
import 'package:cleanify/elements/project_elements.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.projectBackgroundColor,
      appBar: const CommonAppbar(preference: "back"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ProjectColors.defaultTextColor,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  buildSettingsCard(
                    context,
                    icon: Icons.palette,
                    title: 'Theme',
                    subtitle: 'Select your preferred theme',
                    onTap: () {},
                  ),
                  buildSettingsCard(
                    context,
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage notification settings',
                    onTap: () {},
                  ),
                  buildSettingsCard(
                    context,
                    icon: Icons.account_circle,
                    title: 'Account',
                    subtitle: 'Update account information',
                    onTap: () {},
                  ),
                  buildSettingsCard(
                    context,
                    icon: Icons.lock,
                    title: 'Privacy',
                    subtitle: 'Manage privacy settings',
                    onTap: () {},
                  ),
                  buildSettingsCard(
                    context,
                    icon: Icons.help,
                    title: 'Help & Support',
                    subtitle: 'Get help and support',
                    onTap: () {},
                  ),
                  const SizedBox(height: 64),
                  Text(
                    "More features coming soon!",
                    style: ProjectTextStyles.styleDrawerTitle.copyWith(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
