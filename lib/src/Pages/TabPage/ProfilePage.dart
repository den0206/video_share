import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:video_share/src/Extension/CircleButtons.dart';
import 'package:video_share/src/Extension/CustomWidgets.dart';
import 'package:video_share/src/Extension/FirebaseRef.dart';
import 'package:video_share/src/Extension/FirestoreService.dart';
import 'package:video_share/src/Extension/Style.dart';
import 'package:video_share/src/Extension/VideoPlayer.dart';
import 'package:video_share/src/Model/FBUser.dart';
import 'package:video_share/src/Model/Video.dart';
import 'package:video_share/src/Pages/TabPage/EditPage.dart';
import 'package:video_share/src/Provider/UserState.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    Key key,
    @required this.user,
    this.hasBackButton = false,
  }) : super(key: key);

  final FBUser user;
  final bool hasBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !hasBackButton ? null : AppBar(),
      body: Center(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleCacheAvatar(
                  imageUrl: user.imageUrl,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  user.name,
                  style: googleFont(
                    size: 25,
                    color: Colors.black,
                    fw: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _RelationText(
                      value: 0,
                    ),
                    _RelationText(
                      value: 111,
                    ),
                    _RelationText(
                      value: 232,
                    ),
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Following",
                      style: googleFont(
                          size: 17, color: Colors.black, fw: FontWeight.w700),
                    ),
                    Text(
                      "Fans",
                      style: googleFont(
                          size: 17, color: Colors.black, fw: FontWeight.w700),
                    ),
                    Text(
                      "Hearts",
                      style: googleFont(
                          size: 17, color: Colors.black, fw: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                if (user == currentUser) _CurrentUserSpace(user: user),
                if (user != currentUser) _AnotherUserSpace(user: user),
                SizedBox(height: 20),
                Divider(),
                Text(
                  "My Videos",
                  style: googleFont(size: 20, color: Colors.black),
                ),
                FutureBuilder(
                  future: firebaseRef(FirebaseRef.user)
                      .doc(user.uid)
                      .collection(FirebaseRef.video.path)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.data.docs.length == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text("No Vieo"),
                      );
                    }

                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      padding: EdgeInsets.all(4),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 2,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        Video video =
                            Video.fromDocument(snapshot.data.docs[index]);
                        video.user = user;

                        return InkResponse(
                          child: CachedNetworkImage(
                            imageUrl: video.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          onTap: () {
                            if (user.uid == currentUser.uid)
                              showCupertinoModalBottomSheet(
                                expand: true,
                                context: context,
                                backgroundColor: Colors.white,
                                builder: (context) =>
                                    _VideoDeletePage(video: video),
                              );

                            if (user.uid != currentUser.uid)
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Scaffold(
                                    body: Stack(
                                      children: [
                                        VideoPlayerPage(video: video),
                                        Positioned(
                                          left: 20,
                                          top: 40,
                                          child: CircleIconButton(
                                            icon: Icon(
                                              Icons.arrow_back,
                                              color: Colors.black,
                                            ),
                                            size: 20,
                                            onPress: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ));
                          },
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfliPageModel extends ChangeNotifier {
  ProfliPageModel(
    this.user,
  );
  final FBUser user;

  Future getVideos() async {
    firebaseRef(FirebaseRef.user)
        .doc(user.uid)
        .collection(FirebaseRef.video.path)
        .get();
  }
}

class _RelationText extends StatelessWidget {
  const _RelationText({
    Key key,
    @required this.value,
  }) : super(key: key);

  final int value;

  @override
  Widget build(BuildContext context) {
    return Text(
      "$value",
      style: googleFont(size: 23, color: Colors.black, fw: FontWeight.w500),
    );
  }
}

class _CurrentUserSpace extends StatelessWidget {
  const _CurrentUserSpace({
    Key key,
    @required this.user,
  }) : super(key: key);

  final FBUser user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomButton(
          title: "Logout",
          backColor: Colors.red,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text(
                    "LOG OUT",
                  ),
                  content: Text(
                    "would you logout?",
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoDialogAction(
                      child: Text("Log out"),
                      isDestructiveAction: true,
                      onPressed: () {
                        final userState =
                            Provider.of<UserState>(context, listen: false);

                        userState.logout();
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              },
            );
          },
        ),
        CustomButton(
          title: "Edit",
          onPressed: () {
            Navigator.pushNamed(context, EditPage.id, arguments: user);
          },
        ),
      ],
    );
  }
}

class _AnotherUserSpace extends StatelessWidget {
  const _AnotherUserSpace({
    Key key,
    @required this.user,
  }) : super(key: key);

  final FBUser user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomButton(
          title: "Follow",
          backColor: Colors.blue,
          onPressed: () {
            print("Follow");
          },
        ),
        CustomButton(
          title: "Message",
          onPressed: () {
            print(user.name);
          },
        ),
      ],
    );
  }
}

class _VideoDeletePage extends StatefulWidget {
  const _VideoDeletePage({
    Key key,
    @required this.video,
  }) : super(key: key);

  final Video video;

  @override
  __VideoDeletePageState createState() => __VideoDeletePageState();
}

class __VideoDeletePageState extends State<_VideoDeletePage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return OverlayLoadingWidget(
      isLoading: isLoading,
      child: Scaffold(
        body: VideoPlayerPage(
          video: widget.video,
        ),
        floatingActionButton: CircleIconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          size: 40,
          backColor: Colors.grey,
          borderColor: Colors.grey,
          onPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text("Delete Video?"),
                  actions: [
                    CupertinoDialogAction(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.of(context).pop()),
                    CupertinoDialogAction(
                      child: Text("Delete"),
                      isDestructiveAction: true,
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });

                        FirestoreService.deleteVideo(
                          video: widget.video,
                          onSuccess: () {
                            print("Delete Success");

                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context);
                          },
                          errorCallback: (e) {
                            setState(() {
                              isLoading = false;
                            });
                            showErrorDialog(context, e);
                          },
                        );
                      },
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
