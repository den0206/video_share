import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:video_share/src/Extension/CustomWidgets.dart';
import 'package:video_share/src/Extension/FirebaseRef.dart';
import 'package:video_share/src/Extension/StrogageRef.dart';
import 'package:video_share/src/Extension/Style.dart';
import 'package:video_share/src/Model/Video.dart';
import 'package:video_share/src/Provider/UserState.dart';

class ConfirmPage extends StatelessWidget {
  const ConfirmPage({
    Key key,
    @required this.videoFile,
    @required this.path,
    @required this.imageSource,
  }) : super(key: key);

  final File videoFile;
  final String path;
  final ImageSource imageSource;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<_ConfirmPageModel>(
        create: (context) =>
            _ConfirmPageModel(videoFile: videoFile, path: path),
        builder: (context, snapshot) {
          return Consumer<_ConfirmPageModel>(
            builder: (context, model, child) {
              return OverlayLoadingWidget(
                isLoading: model.isLoading,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: VideoPlayer(model.controller),
                          ),
                          Positioned(
                            left: 5,
                            top: 30,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                videoFile.delete();
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ConfirmTextField(
                                width: MediaQuery.of(context).size.width / 2,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                controller: model.musicController,
                                title: "Song Name",
                                iconData: Icons.music_note),
                            _ConfirmTextField(
                              width: MediaQuery.of(context).size.width / 2,
                              margin: EdgeInsets.only(right: 40),
                              controller: model.captionController,
                              title: "Caption",
                              iconData: Icons.closed_caption,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton(
                            title: "Another Video",
                            backColor: Colors.red,
                            onPressed: () {
                              Navigator.of(context).pop();
                              videoFile.delete();
                            },
                          ),
                          CustomButton(
                            title: "UploadVideo",
                            backColor: Colors.lightBlue,
                            onPressed: () {
                              model.uploadVideo(onSuccess: (video) {
                                print(video.id);
                                Navigator.of(context).pop();
                              }, onFail: (e) {
                                showErrorDialog(context, e);
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ConfirmPageModel extends ChangeNotifier {
  VideoPlayerController controller;
  bool isLoading = false;

  TextEditingController musicController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  File videoFile;
  String path;

  _ConfirmPageModel({@required File videoFile, @required String path}) {
    print("Init");
    this.videoFile = videoFile;
    this.path = path;
    controller = VideoPlayerController.file(videoFile);
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
    notifyListeners();
  }

  @override
  void dispose() {
    print("Dispose");
    super.dispose();
    controller.dispose();
    videoFile.delete();
  }

  void uploadVideo({
    Function(Video video) onSuccess,
    Function(dynamic e) onFail,
  }) async {
    var connection = await Connectivity().checkConnectivity();

    if (connection != ConnectivityResult.wifi &&
        connection != ConnectivityResult.mobile) {
      Exception error = Exception("No InterNet");
      onFail(error);
      return;
    }

    if ((musicController.text.isEmpty || captionController.text.isEmpty)) {
      Exception error = Exception("Please fill");

      onFail(error);
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      // var alldocs = await firebaseRef(FirebaseRef.user)
      //     .doc(currentUser.uid)
      //     .collection(FirebaseRef.video.path)
      //     .get();
      // int length = alldocs.docs.length;

      var uuid = Uuid().v1();

      String videoPath = "${currentUser.uid}/$uuid";

      String videoUrl = await uploadStorage(
          StorageRef.video, videoPath + "/video", videoFile);
      String imageUrl = await uploadStorage(
          StorageRef.video,
          videoPath + "/image",
          await getThumbnailImage(path: path),
          UploadType.image);

      Video video = Video(
        id: uuid,
        videoUrl: videoUrl,
        imageUrl: imageUrl,
        caption: captionController.text,
        songName: musicController.text,
        commentCount: 0,
        shareCount: 0,
        user: currentUser,
      );

      firebaseRef(FirebaseRef.user)
          .doc(currentUser.uid)
          .collection(FirebaseRef.video.path)
          .doc(uuid)
          .set(video.toMap());

      isLoading = false;
      notifyListeners();

      onSuccess(video);
    } catch (e) {
      onFail(e);
    }
  }
}

class _ConfirmTextField extends StatelessWidget {
  const _ConfirmTextField({
    Key key,
    @required this.width,
    @required this.margin,
    @required this.controller,
    @required this.title,
    @required this.iconData,
  }) : super(key: key);

  final double width;
  final EdgeInsets margin;
  final TextEditingController controller;
  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: title,
          labelStyle: googleFont(size: 20),
          prefixIcon: Icon(iconData),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
