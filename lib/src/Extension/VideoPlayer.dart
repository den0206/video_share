import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_share/src/Model/Video.dart';

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage({
    Key key,
    @required this.video,
  }) : super(key: key);

  final Video video;

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController videoPlayerController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.video.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);

        setState(() {
          isLoading = false;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoading
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: VideoPlayer(videoPlayerController),
            )
          : Center(
              child: CircularProgressIndicator(backgroundColor: Colors.white),
            ),
    );
  }
}
