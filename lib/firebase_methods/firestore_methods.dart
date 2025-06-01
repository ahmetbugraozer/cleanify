// ignore_for_file: avoid_print

import 'package:cleanify/firebase_methods/auth_methods.dart';
import 'package:cleanify/models/postModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreMethods {
  final _firestore = FirebaseFirestore.instance;
  User? user = Auth().currentUser;
  String fullName = "";
  String username = "";
  String profilePhoto = "";
  late int count;

  Future<void> fetchAndProcessSpecificFields() async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _firestore.collection('users').doc(Auth().currentUser!.uid).get();
    Map<String, dynamic> data = documentSnapshot.data()!;

    fullName = data['name'];
    username = data['username'];
    profilePhoto = data['profilePhoto'];
    count = data['count'];
  }

  void updateProfilePhoto(String path) {
    _firestore.collection("users").doc(user!.uid).update({
      'profilePhoto': path,
    });
  }

  void updateUserData(String name, String age) {
    _firestore.collection("users").doc(user!.uid).update({
      'name': name,
      'age': age,
    });
  }

  createorUpdatePost(Map<String, dynamic> userDataMap) async {
    DocumentReference ref = _firestore.collection("posts").doc();
    return ref.set(userDataMap);
  }

  void validateAndSubmitPost(String description, String photo,
      double longtitude, double altitude) async {
    await fetchAndProcessSpecificFields();
    count = count + 1;
    await updateCountNumber();
    try {
      PostModel post = PostModel(
          fullName: fullName,
          username: username,
          profilePhoto: profilePhoto,
          pollutionPhoto: photo,
          date: DateTime.now().toString(),
          description: description,
          longtitude: longtitude,
          altitude: altitude,
          uid: Auth().currentUser!.uid);
      await createorUpdatePost(post.getDataMap());
    } catch (err) {
      throw Exception(err);
    }
  }

  updateCountNumber() async {
    try {
      await FirebaseFirestore.instance
          .collection('users') // Kullanıcılar koleksiyonu
          .doc(Auth().currentUser!.uid) // Belirli kullanıcının dokümanı
          .update({
        'count': count, // Yeni fotoğraf URL'si/ Yeni isim
      });
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  deletePost(String id) async {
    await fetchAndProcessSpecificFields();
    count = count - 1;
    updateCountNumber();
    DocumentReference ref = _firestore.collection('posts').doc(id);
    ref.delete();
  }
}
