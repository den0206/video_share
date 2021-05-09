import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_share/src/Model/FBUser.dart';

class Video {
  Video({
    @required this.id,
    @required this.videoUrl,
    @required this.imageUrl,
    @required this.songName,
    @required this.caption,
    @required this.shareCount,
    @required this.commentCount,
    this.user,
  });

  Video.fromDocument(DocumentSnapshot document) {
    id = document.id;
    videoUrl = document.data()[VideoKey.videoUrl] as String;
    imageUrl = document.data()[VideoKey.imageUrl] as String;
    songName = document.data()[VideoKey.songName] as String;
    caption = document.data()[VideoKey.caption] as String;
    shareCount = document.data()[VideoKey.shareCount] as int;
    commentCount = document.data()[VideoKey.commentCount] as int;
  }

  Map<String, dynamic> toMap() {
    return {
      VideoKey.id: id,
      VideoKey.videoUrl: videoUrl,
      VideoKey.imageUrl: imageUrl,
      VideoKey.songName: songName,
      VideoKey.caption: caption,
      VideoKey.shareCount: shareCount,
      VideoKey.commentCount: commentCount,
      if (user != null) VideoKey.userId: user.uid
    };
  }

  String id;
  String videoUrl;
  String imageUrl;
  String songName;
  String caption;

  FBUser user;

  int shareCount;
  int commentCount;
}

class VideoKey {
  static final id = "id";
  static final videoUrl = "videoUrl";
  static final imageUrl = "imageUrl";
  static final songName = "songName";
  static final caption = "caption";
  static final userId = "userId";
  static final shareCount = "shareCount";
  static final commentCount = "commentCount";
}
