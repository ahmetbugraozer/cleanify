// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cleanify/firebase_methods/firestore_methods.dart';
import 'package:cleanify/pages/tabbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../elements/project_elements.dart';
import 'package:path/path.dart';

class SignUpEditProfile extends StatefulWidget {
  const SignUpEditProfile({super.key});

  @override
  State<SignUpEditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<SignUpEditProfile> {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController age = TextEditingController();
  bool fullNameRemains = false;
  bool ageRemains = false;
  late firebase_storage.UploadTask uploadTask;
  File? _selectedImage;
  String? fullNameErrorMessage;
  String? ageErrorMessage;
  bool isFullNameTextFieldError = false;
  bool isAgeTextFieldError = false;

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
      print(e.toString());
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
      print('No image selected');
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
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ProjectColors.projectBackgroundColor,
        appBar: const CommonAppbar(preference: "back"),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text("Complete Your Profile",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      SizedBox(
                          height: 150,
                          child: _selectedImage != null
                              ? Image.file(_selectedImage!,
                                  fit: BoxFit.fitHeight)
                              : Image.network(defaultPhoto,
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
                                                  Navigator.of(context).pop();
                                                }),
                                            ListTile(
                                                title: const Text("Take Photo",
                                                    style: ProjectTextStyles
                                                        .styleListViewGeneral),
                                                onTap: () {
                                                  imgFromCamera();
                                                  setState(() {});
                                                  Navigator.of(context).pop();
                                                })
                                          ]));
                                });
                          },
                          child: const Text("Change Profile Picture",
                              style: ProjectTextStyles.styleListViewGeneral)),
                      const SizedBox(height: 20),
                      TextField(
                          controller: fullName,
                          maxLines: 1,
                          onChanged: _validateFullNameTextField,
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: "Enter your full name",
                              labelText: "Full Name",
                              errorText: isFullNameTextFieldError
                                  ? fullNameErrorMessage
                                  : null,
                              border: const OutlineInputBorder())),
                      const SizedBox(height: 20),
                      TextField(
                          controller: age,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          onChanged: _validateAgeTextField,
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: "Enter your age",
                              labelText: "Age",
                              errorText:
                                  isAgeTextFieldError ? ageErrorMessage : null,
                              border: const OutlineInputBorder())),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () {
                            if (!isAgeTextFieldError &&
                                !isFullNameTextFieldError) {
                              FirestoreMethods()
                                  .updateUserData(fullName.text, age.text);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return const MainTabBar();
                              }));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Something went wrong. Please try again.")));
                            }
                          },
                          child: const Text("Continue",
                              style: ProjectTextStyles.styleListViewGeneral))
                    ]))));
  }

  void _validateFullNameTextField(String value) {
    setState(() {
      if (value.isEmpty) {
        fullNameErrorMessage = 'This field cannot be empty';
        isFullNameTextFieldError = true;
      } else {
        isFullNameTextFieldError = false;
      }
    });
  }

  void _validateAgeTextField(String value) {
    setState(() {
      if (value.isEmpty) {
        ageErrorMessage = 'This field cannot be empty';
        isAgeTextFieldError = true;
      } else {
        isAgeTextFieldError = false;
      }
    });
  }
}
