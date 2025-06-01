import 'package:cleanify/pages/settings.dart';
import 'package:flutter/material.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String preference;

  const CommonAppbar({Key? key, required this.preference}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        shadowColor: Colors.black,
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        backgroundColor: ProjectColors.projectPrimaryWidgetColor,
        leading: ((preference == "back"))
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back))
            : const SizedBox(),
        title: const Center(child: Text("Cleanify")),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ProjectColors {
  static Color? projectBackgroundColor = Colors.grey[100];
  static const Color projectPrimaryWidgetColor =
      Color.fromARGB(255, 61, 217, 136);
  static const Color projectSecondaryWidgetColor =
      Color.fromARGB(255, 113, 113, 113);
  static const Color defaultTextColor = Colors.black;
  static const Color optionalTextColor1 = Color.fromARGB(255, 205, 205, 205);
  static const Color optionalTextColor2 = Color.fromARGB(255, 49, 166, 100);
  static const Color projectDefaultColor = Colors.white;
  static const Color projectTransparentColor = Colors.transparent;
  static const Color imageBorderColor = Color.fromARGB(255, 184, 184, 184);
}

class ProjectTextStyles {
  static const TextStyle styleDrawerTitle = TextStyle(
      color: ProjectColors.projectDefaultColor,
      fontSize: 30,
      fontWeight: FontWeight.w400);

  static const TextStyle styleTopSectionRegionButtonText =
      TextStyle(color: ProjectColors.optionalTextColor1);

  static const TextStyle styleDrawerTextLine = TextStyle(
      color: ProjectColors.defaultTextColor, fontWeight: FontWeight.w500);

  static const TextStyle styleListViewGeneral = TextStyle(
      color: ProjectColors.optionalTextColor2,
      fontSize: 15,
      fontWeight: FontWeight.w700);
}

Widget buildSettingsCard(BuildContext context,
    {required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 2,
    child: ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: (subtitle == null || subtitle.isEmpty) ? null : Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}
