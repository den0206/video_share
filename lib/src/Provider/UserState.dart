import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_share/src/Extension/FirebaseRef.dart';
import 'package:video_share/src/Model/FBUser.dart';

class UserState extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  Future setUser({String uid}) async {
    final userId = uid ?? _auth.currentUser.uid;
    if (userId != null) {
      print("set User state");
      final doc = await firebaseRef(FirebaseRef.user).doc(userId).get();

      currentUser = FBUser.fromDocument(doc);

      notifyListeners();
    } else {
      print("No User");
    }
  }

  Future logout() async {
    currentUser = null;
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}

FBUser currentUser;

bool isSignIn = false;
