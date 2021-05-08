import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_share/src/Extension/CustomWidgets.dart';
import 'package:video_share/src/Extension/Style.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          VideoPlayerPage(
            videoUrl: "http://egaoinc.xsrv.jp/egao-blog/movie/sample-movie.mp4",
          ),
          Column(
            children: [
              Container(
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Folllowing",
                      style: googleFont(
                        size: 17,
                        color: Colors.white,
                        fw: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "For You",
                      style: googleFont(
                        size: 17,
                        color: Colors.white,
                        fw: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        height: 70,
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "username",
                              style: googleFont(
                                  size: 15,
                                  color: Colors.white,
                                  fw: FontWeight.bold),
                            ),
                            Text(
                              "caption",
                              style: googleFont(
                                  size: 15,
                                  color: Colors.white,
                                  fw: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.music_note,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Song Name",
                                  style: googleFont(
                                    size: 15,
                                    color: Colors.white,
                                    fw: FontWeight.bold,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _BuildProfile(url: ""),
                          _VideoIconButton(
                            text: "Likes",
                            icon: Icon(
                              Icons.favorite,
                              size: 55,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              print("Icon");
                            },
                          ),
                          _VideoIconButton(
                            text: "Comment",
                            icon: Icon(Icons.comment,
                                size: 55, color: Colors.white),
                            onPressed: () {
                              print("Comment");
                            },
                          ),
                          _VideoIconButton(
                            text: "hare",
                            icon: Icon(Icons.reply,
                                size: 55, color: Colors.white),
                            onPressed: () {
                              print("Share");
                            },
                          ),
                          CirculeAnimation(_AnimationProfile(url: ""))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _VideoIconButton extends StatelessWidget {
  const _VideoIconButton({
    Key key,
    @required this.text,
    @required this.icon,
    @required this.onPressed,
  }) : super(key: key);

  final String text;
  final Icon icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: icon,
          onPressed: onPressed,
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          text,
          style: googleFont(
            size: 10,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

class _BuildProfile extends StatelessWidget {
  const _BuildProfile({
    Key key,
    @required this.url,
  }) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 5,
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image(
                  image: NetworkImage(url),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 20,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _AnimationProfile extends StatelessWidget {
  const _AnimationProfile({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(11),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient:
                  LinearGradient(colors: [Colors.grey[800], Colors.grey[700]]),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(url),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage({
    Key key,
    @required this.videoUrl,
  }) : super(key: key);
  final String videoUrl;

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: VideoPlayer(videoPlayerController),
    );
  }
}

// Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(currentUser.name),
//             CustomButton(
//               title: "Logout",
//               backColor: Colors.red,
//               onPressed: () {
//                 final userState =
//                     Provider.of<UserState>(context, listen: false);
//                 userState.logout();
//               },
//             ),
//           ],
//         ),
//       ),
