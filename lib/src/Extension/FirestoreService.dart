import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:video_share/src/Extension/FirebaseRef.dart';
import 'package:video_share/src/Extension/StrogageRef.dart';
import 'package:video_share/src/Model/FBUser.dart';
import 'package:video_share/src/Model/Video.dart';
import 'package:video_share/src/Provider/UserState.dart';

class FirestoreService {
  static Future<QuerySnapshot> searchUser(String name) {
    Future<QuerySnapshot> users = firebaseRef(FirebaseRef.user)
        .where(UserKey.name, isGreaterThanOrEqualTo: name)
        .get();

    return users;
  }

  static Future<void> deleteVideo({
    @required Video video,
    @required void Function() onSuccess,
    @required void Function(Exception e) errorCallback,
  }) async {
    if (currentUser.uid != video.user.uid) {
      Exception error = Exception("削除できません");
      errorCallback(error);
    }
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.wifi &&
        connectivityResult != ConnectivityResult.mobile) {
      Exception error = Exception("No InterNet");
      errorCallback(error);
      return;
    }

    print("Call");
    try {
      await firebaseRef(FirebaseRef.user)
          .doc(video.user.uid)
          .collection(FirebaseRef.video.path)
          .doc(video.id)
          .delete()
          .whenComplete(
        () async {
          await deleteFileFromStorage(fileUrl: video.imageUrl);
          await deleteFileFromStorage(fileUrl: video.videoUrl)
              .whenComplete(onSuccess);
        },
      );
    } catch (e) {
      errorCallback(e);
    }
  }
}
