import 'package:cloud_firestore/cloud_firestore.dart';

enum FirebaseRef { user, video }

extension FirebaseRefExtension on FirebaseRef {
  String get path {
    switch (this) {
      case FirebaseRef.user:
        return "User";
      case FirebaseRef.video:
        return "Video";

      default:
        return "";
    }
  }
}

CollectionReference firebaseRef(FirebaseRef ref) {
  return FirebaseFirestore.instance.collection(ref.path);
}
