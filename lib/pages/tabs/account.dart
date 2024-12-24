import 'package:cleanify/firebase_methods/auth_methods.dart';
import 'package:cleanify/pages/accounteditprofile.dart';
import 'package:cleanify/pages/signuplogin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../elements/project_elements.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ProjectColors.projectBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(children: [
            const ProfileSection(),
            const SizedBox(height: 10),
            buildSettingsCard(
              context,
              icon: Icons.edit,
              title: "Edit profile",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountEditProfile()));
              },
            ),
            buildSettingsCard(
              context,
              icon: Icons.logout,
              title: "Log out",
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                Auth().logOut();
              },
            ),
            buildSettingsCard(
              context,
              icon: Icons.delete,
              title: "Delete account",
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                Auth().deletePosts();
                Auth().deleteUserInfo();
                Auth().deleteAccount();
              },
            ),
          ]),
        ));
  }
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(Auth().currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: Text('User does not exist.'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Container(
              height: 360,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: ProjectColors.projectPrimaryWidgetColor),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            NetworkImage(userData['profilePhoto'].toString())),
                    const SizedBox(height: 20),
                    Text(userData['username'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(userData['name'],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15)),
                    const SizedBox(height: 5),
                    Text('Age: ${userData['age']}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15)),
                    const SizedBox(height: 5),
                    const Text('Location: Turkey',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    const SizedBox(height: 5),
                    Text('Posts: ${userData['count']}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15))
                  ]));
        });
  }
}

class MyListTile extends StatelessWidget {
  final Icon myIcon;
  final String subject;
  final VoidCallback? onTap;

  const MyListTile(
      {Key? key, required this.subject, required this.myIcon, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
            child: ListTile(
                title: Text(subject,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400)),
                onTap: onTap,
                leading: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 40,
                    child: myIcon),
                trailing: const Icon(Icons.chevron_right))));
  }
}
