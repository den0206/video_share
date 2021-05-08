import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_share/src/Extension/CustomWidgets.dart';
import 'package:video_share/src/Extension/Style.dart';
import 'package:video_share/src/Pages/ConfirmPage.dart';

class AddPage extends StatelessWidget {
  const AddPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future pickVideo(ImageSource src) async {
      Navigator.pop(context);

      final video = await ImagePicker().getVideo(source: src);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmPage(
                videoFile: File(video.path),
                path: video.path,
                imageSource: src),
          ));
    }

    Future showVideoDialog(BuildContext context) {
      return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () {
                  pickVideo(ImageSource.gallery);
                },
                child: Text(
                  "Gallery",
                  style: googleFont(size: 20, color: Colors.black),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickVideo(ImageSource.camera);
                },
                child: Text(
                  "Camera",
                  style: googleFont(size: 20, color: Colors.black),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: googleFont(size: 20, color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    }

    return Center(
        child: CustomButton(
      title: "Add Video",
      backColor: Colors.red,
      onPressed: () {
        showVideoDialog(context);
      },
    ));
  }
}
