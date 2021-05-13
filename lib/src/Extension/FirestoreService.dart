import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_share/src/Extension/FirebaseRef.dart';
import 'package:video_share/src/Model/FBUser.dart';

class FirestoreService {
  static Future<QuerySnapshot> searchUser(String name) {
    Future<QuerySnapshot> users = firebaseRef(FirebaseRef.user)
        .where(UserKey.name, isGreaterThanOrEqualTo: name)
        .get();

    return users;
  }
}
