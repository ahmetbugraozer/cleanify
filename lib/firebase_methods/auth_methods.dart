import 'package:cleanify/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<String> signUp(
      {required String email,
      required String password,
      required String username,
      String res = "Some error occured"}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        AppUser user = AppUser(
            email: email,
            password: password,
            username: username,
            uid: cred.user!.uid,
            profilePhoto:
                'https://soccerpointeclaire.com/wp-content/uploads/2021/06/default-profile-pic-e1513291410505.jpg',
            name: "default",
            age: "default",
            count: 0);
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "Success";
        return res;
      }
    } catch (error) {
      res = error.toString();
      return res;
    }
    return res;
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }

  Future deleteAccount() async {
    _auth.currentUser!.delete();
  }

  Future<void> deletePosts() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference koleksiyonRef = firestore.collection('posts');

      QuerySnapshot querySnapshot = await koleksiyonRef.get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['uid'] == Auth().currentUser!.uid) {
          debugPrint(data['uid']);
          DocumentReference ref = _firestore.collection('posts').doc(doc.id);

          ref.delete();
        }
      }
    } catch (e) {
      debugPrint('Hata: $e');
    }
  }

  Future<void> deleteUserInfo() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference koleksiyonRef = firestore.collection('users');

      QuerySnapshot querySnapshot = await koleksiyonRef.get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['uid'] == Auth().currentUser!.uid) {
          DocumentReference ref = _firestore.collection('users').doc(doc.id);

          ref.delete();
        }
      }
    } catch (e) {
      debugPrint('Hata: $e');
    }
  }
}
