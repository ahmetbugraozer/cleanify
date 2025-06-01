import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:cleanify/elements/project_elements.dart';
import 'package:cleanify/firebase_methods/firestore_methods.dart';
import 'package:cleanify/pages/mapselect.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool mediaRemains = false;
  bool mapSelected = false;
  String description = "";
  late firebase_storage.UploadTask uploadTask;
  File? _selectedImage;
  double longtitude = 0;
  double latitude = 0;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  late String photoPath = defaultPhoto;
  String defaultPhoto =
      'https://soccerpointeclaire.com/wp-content/uploads/2021/06/default-profile-pic-e1513291410505.jpg';
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppbar(preference: "back"),
      backgroundColor: ProjectColors.projectBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create a Post",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: ProjectColors.defaultTextColor,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              maxLength: 300,
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
              maxLines: 7,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Describe the pollution',
                labelText: "Description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildIconButton(
                  icon: Icons.photo,
                  color: mediaRemains ? Colors.green : Colors.red,
                  onPressed: () {
                    _showImageSourceActionSheet(context);
                  },
                ),
                const SizedBox(width: 10),
                _buildIconButton(
                  icon: Icons.location_pin,
                  color: mapSelected ? Colors.green : Colors.red,
                  onPressed: () async {
                    LatLng? result = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const MapSelect()),
                    );
                    if (result != null) {
                      longtitude = result.longitude;
                      latitude = result.latitude;
                      setState(() {
                        mapSelected = true;
                      });
                    } else {
                      setState(() {
                        mapSelected = false;
                      });
                    }
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (description.isNotEmpty && mediaRemains && mapSelected) {
                      FirestoreMethods().validateAndSubmitPost(
                        description,
                        photoPath,
                        longtitude,
                        latitude,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Post"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFeedbackMessage(),
            const SizedBox(height: 20),
            _selectedImage != null
                ? SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const Text(""),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
      {required IconData icon,
      required Color color,
      required VoidCallback onPressed}) {
    return IconButton(
      icon: Icon(icon, size: 30, color: color),
      onPressed: onPressed,
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
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
                  style: ProjectTextStyles.styleListViewGeneral,
                ),
                onTap: () {
                  mediaRemains = true;
                  imgFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text(
                  "Take Photo",
                  style: ProjectTextStyles.styleListViewGeneral,
                ),
                onTap: () {
                  mediaRemains = true;
                  imgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeedbackMessage() {
    if (description.isNotEmpty && mediaRemains && mapSelected) {
      return const SizedBox.shrink();
    }

    String message = "Description, media and location required";
    if (description.isNotEmpty && mediaRemains && !mapSelected) {
      message = "Please select a location";
    } else if (description.isNotEmpty && !mediaRemains && mapSelected) {
      message = "Media is required";
    } else if (description.isEmpty && mediaRemains && mapSelected) {
      message = "Please enter a description";
    } else if (description.isNotEmpty && !mediaRemains && !mapSelected) {
      message = "Media and location needed";
    } else if (description.isEmpty && mediaRemains && !mapSelected) {
      message = "Description and location needed";
    } else if (description.isEmpty && !mediaRemains && mapSelected) {
      message = "Description and media required";
    }

    return Text(
      message,
      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    );
  }

  Future uploadFile() async {
    if (_selectedImage == null) return;
    final fileName = basename(_selectedImage!.path);
    final destination = 'files/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('/post');
      uploadTask = ref.putData(await _selectedImage!.readAsBytes());
      photoPath = await (await uploadTask).ref.getDownloadURL();

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
}
