// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String fullName;
  final String username;
  final String profilePhoto;
  final String pollutionPhoto;
  final String date;
  final String description;
  final double longtitude;
  final double altitude;
  final String uid;

  PostModel({
    required this.fullName,
    required this.username,
    required this.profilePhoto,
    required this.pollutionPhoto,
    required this.date,
    required this.description,
    required this.longtitude,
    required this.altitude,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'username': username,
        'profilePhoto': profilePhoto,
        'pollutionPhoto': pollutionPhoto,
        'date': date,
        'description': description,
        'longtitude': longtitude,
        'altitude': altitude,
        'uid': uid,
      };

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
        fullName: snapshot['fullName'],
        username: snapshot['username'],
        profilePhoto: snapshot['profilePhoto'],
        pollutionPhoto: snapshot['pollutionPhoto'],
        date: snapshot['date'],
        description: snapshot['description'],
        longtitude: snapshot['longtitude'],
        altitude: snapshot['altitude'],
        uid: snapshot['uid']);
  }

  dynamic getDataMap() {
    return {
      'fullName': fullName,
      'username': username,
      'profilePhoto': profilePhoto,
      'pollutionPhoto': pollutionPhoto,
      'date': date,
      'description': description,
      'longtitude': longtitude,
      'altitude': altitude,
      'uid': uid,
    };
  }
}
