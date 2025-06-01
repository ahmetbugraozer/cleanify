import 'dart:io';

import 'package:cleanify/firebase_methods/auth_methods.dart';
import 'package:cleanify/firebase_methods/firestore_methods.dart';
import 'package:cleanify/pages/tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../elements/project_elements.dart';
import 'package:path/path.dart';

class AccountEditProfile extends StatefulWidget {
  const AccountEditProfile({super.key});

  @override
  State<AccountEditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<AccountEditProfile> {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController age = TextEditingController();
  bool fullNameRemains = false;
  bool ageRemains = false;
  late firebase_storage.UploadTask uploadTask;
  File? _selectedImage;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  late String photoPath = defaultPhoto;
  String defaultPhoto =
      'https://soccerpointeclaire.com/wp-content/uploads/2021/06/default-profile-pic-e1513291410505.jpg';
  int count = 0;
  Future uploadFile() async {
    if (_selectedImage == null) return;
    final fileName = basename(_selectedImage!.path);
    final destination = 'files/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('/file');
      uploadTask = ref.putData(await _selectedImage!.readAsBytes());
      photoPath = await (await uploadTask).ref.getDownloadURL();
      FirestoreMethods().updateProfilePhoto(photoPath);

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      Future.delayed(const Duration(microseconds: 1));
      setState(() {});
      uploadFile();
    } else {
      debugPrint('No image selected');
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      Future.delayed(const Duration(microseconds: 1));
      setState(() {});
      uploadFile();
    } else {
      debugPrint('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ProjectColors.projectBackgroundColor,
        appBar: const CommonAppbar(preference: "back"),
        body: StreamBuilder(
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

              return SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text("Edit Your Profile",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            SizedBox(
                                height: 150,
                                child: _selectedImage != null
                                    ? Image.file(_selectedImage!,
                                        fit: BoxFit.fitHeight)
                                    : Image.network(userData["profilePhoto"],
                                        fit: BoxFit.fitHeight)),
                            const SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ListTile(
                                                      title: const Text(
                                                          "From Gallery",
                                                          style: ProjectTextStyles
                                                              .styleListViewGeneral),
                                                      onTap: () {
                                                        imgFromGallery();
                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop();
                                                      }),
                                                  ListTile(
                                                      title: const Text(
                                                          "Take Photo",
                                                          style: ProjectTextStyles
                                                              .styleListViewGeneral),
                                                      onTap: () {
                                                        imgFromCamera();
                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop();
                                                      })
                                                ]));
                                      });
                                },
                                child: const Text("Change Profile Picture",
                                    style: ProjectTextStyles
                                        .styleListViewGeneral)),
                            const SizedBox(height: 20),
                            TextField(
                                controller: fullName,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your full name",
                                    labelText: userData["name"],
                                    border: const OutlineInputBorder())),
                            const SizedBox(height: 20),
                            TextField(
                                controller: age,
                                maxLines: 1,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    isDense: true,
                                    hintText: "Enter your age",
                                    labelText: userData["age"],
                                    border: const OutlineInputBorder())),
                            const SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) {
                                    return const MainTabBar();
                                  }));
                                },
                                child: const Text("Edit",
                                    style:
                                        ProjectTextStyles.styleListViewGeneral))
                          ])));
            }));
  }
}
