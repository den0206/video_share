import 'package:cloud_firestore/cloud_firestore.dart';

class FBUser {
  FBUser({
    this.uid,
    this.name,
    this.email,
    this.imageUrl,
  });

  FBUser.fromDocument(DocumentSnapshot document) {
    uid = document.id;
    name = document.data()[UserKey.name] as String;
    email = document.data()[UserKey.email] as String;

    imageUrl = document.data()[UserKey.imageUrl] as String ?? null;
  }

  String uid;
  String name;
  String email;
  String imageUrl;

  Map<String, dynamic> toMap() {
    return {
      UserKey.uid: uid,
      UserKey.name: name,
      UserKey.email: email,
    };
  }
}

class UserKey {
  static final uid = "uid";
  static final name = "name";
  static final email = "email";
  static final imageUrl = "imageUrl";
}
