import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

enum StorageRef { video, image, profile }

extension StorageRefExtension on StorageRef {
  String get path {
    switch (this) {
      case StorageRef.video:
        return "Video";
      case StorageRef.image:
        return "Image";
      case StorageRef.profile:
        return "Profile";
      default:
        return "";
    }
  }
}

Reference storageRef(StorageRef ref) {
  return FirebaseStorage.instance.ref().child(ref.path);
}

enum UploadType { video, image }

Future<String> uploadStorage(StorageRef ref, String path, dynamic file,
    [UploadType type = UploadType.video]) async {
  Reference filePath = storageRef(ref).child(path);
  UploadTask uploadTask;

  if (type == UploadType.video) {
    uploadTask =
        filePath.putFile(file, SettableMetadata(contentType: 'video/mp4'));
  } else {
    uploadTask = filePath.putFile(file);
  }

  // uploadTask.then((res) {
  //   print("calls");
  //   return res.ref.getDownloadURL();
  // });

  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

  String dounloadUrl = await taskSnapshot.ref.getDownloadURL();
  return dounloadUrl.toString();
}

Future<File> getThumbnailImage({@required String path}) async {
  final thumbnail = await VideoCompress.getFileThumbnail(path);
  return thumbnail;
}

Future<File> compressVideo(String path) async {
  final compressVideo = await VideoCompress.compressVideo(
    path,
    quality: VideoQuality.DefaultQuality,
  );

  return compressVideo.file;
}

Future<void> deleteFileFromStorage({@required String fileUrl}) async {
  final _storage = FirebaseStorage.instance;
  var fileRef = _storage.refFromURL(fileUrl);

  await fileRef.delete();
}
