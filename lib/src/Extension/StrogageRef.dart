import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

enum StorageRef { video, image }

extension StorageRefExtension on StorageRef {
  String get path {
    switch (this) {
      case StorageRef.video:
        return "Video";
      case StorageRef.image:
        return "Image";
      default:
        return "";
    }
  }
}

Reference storageRef(StorageRef ref) {
  return FirebaseStorage.instance.ref().child(ref.path);
}

Future<String> uploadStorage(StorageRef ref, String path, dynamic file) async {
  Reference filePath = storageRef(ref).child(path);
  UploadTask uploadTask = filePath.putFile(file);
  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

  String dounloadUrl = await taskSnapshot.ref.getDownloadURL();
  print(dounloadUrl);
  return dounloadUrl;
}

Future<File> getThumbnailImage({@required String path}) async {
  final thumbnail = await VideoCompress.getFileThumbnail(path);
  return thumbnail;
}
