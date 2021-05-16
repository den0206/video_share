import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_share/src/Extension/CustomWidgets.dart';
import 'package:video_share/src/Extension/FirebaseRef.dart';
import 'package:video_share/src/Extension/Style.dart';
import 'package:video_share/src/Extension/VideoPlayer.dart';
import 'package:video_share/src/Model/FBUser.dart';
import 'package:video_share/src/Model/Video.dart';

class VideoPageModel extends ChangeNotifier {
  // Stream stream;
  List<Video> videos = [];

  Stream<List<Video>> getVideos() async* {
    var videoStream = FirebaseFirestore.instance
        .collectionGroup(FirebaseRef.video.path)
        .snapshots();
    // List<Video> videos = [];

    await for (var videoSnapshot in videoStream) {
      for (var videoDoc in videoSnapshot.docs) {
        Video video;
        if (videoDoc[VideoKey.userId] != null) {
          var userSnapshot = await firebaseRef(FirebaseRef.user)
              .doc(videoDoc[VideoKey.userId])
              .get();
          video = Video.fromDocument(videoDoc);
          video.user = FBUser.fromDocument(userSnapshot);
        } else {
          video = Video.fromDocument(videoDoc);
        }
        videos.add(video);
      }
      yield videos;
    }
  }
}

class VideoPage extends StatelessWidget {
  const VideoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider<VideoPageModel>(
        create: (context) => VideoPageModel(),
        builder: (context, child) {
          return Consumer<VideoPageModel>(
            builder: (context, model, child) {
              return StreamBuilder(
                stream: model.getVideos(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: globalPink,
                      ),
                    );
                  }

                  if (snapshot.data.length == 0) {
                    return Center(child: Text("No Videos"));
                  }

                  return PageView.builder(
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      Video video = model.videos[index];

                      return _VideoView(
                        video: video,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _VideoView extends StatelessWidget {
  const _VideoView({
    Key key,
    @required this.video,
  }) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoPlayerPage(
          video: video,
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
                          if (video.user != null)
                            Text(
                              video.user.name,
                              style: googleFont(
                                  size: 15,
                                  color: Colors.white,
                                  fw: FontWeight.bold),
                            ),
                          Text(
                            video.caption,
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
                                video.songName,
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
                        // _BuildProfile(url: ""),
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
                          text: "here",
                          icon:
                              Icon(Icons.reply, size: 55, color: Colors.white),
                          onPressed: () {
                            print("Share");
                          },
                        ),
                        CirculeAnimation(
                          _AnimationProfile(
                            user: video.user,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ],
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
    @required this.user,
  }) : super(key: key);

  final FBUser user;
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
              child: user.imageUrl != null
                  ? Image(
                      image: NetworkImage(user.imageUrl),
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.person),
            ),
          )
        ],
      ),
    );
  }
}
