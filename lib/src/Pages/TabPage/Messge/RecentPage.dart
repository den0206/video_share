import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_share/src/Extension/CircleButtons.dart';
import 'package:video_share/src/Extension/DataFormatter.dart';
import 'package:video_share/src/Extension/FirebaseRef.dart';
import 'package:video_share/src/Extension/Style.dart';
import 'package:video_share/src/Model/FBUser.dart';
import 'package:video_share/src/Model/Recent.dart';
import 'package:video_share/src/Pages/TabPage/Messge/ChatPage.dart';
import 'package:video_share/src/Provider/UserState.dart';

class RecentaPageModel extends ChangeNotifier {
  List<Recent> recents = [];

  Stream<List<Recent>> getRecents() async* {
    var query = await firebaseRef(FirebaseRef.recent)
        .where(RecentKey.userId, isEqualTo: currentUser.uid)
        .get();

    for (var doc in query.docs) {
      Recent recent;

      if (doc[RecentKey.withUserId] != null) {
        var userSnapshot = await firebaseRef(FirebaseRef.user)
            .doc(doc[RecentKey.withUserId])
            .get();

        recent = Recent.fromDocument(doc);
        recent.withUser = FBUser.fromDocument(userSnapshot);
      } else {
        recent = Recent.fromDocument(doc);
      }
      recents.add(recent);
    }

    yield recents;
  }
}

class RecentsPage extends StatelessWidget {
  const RecentsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<RecentaPageModel>(
          create: (context) => RecentaPageModel(),
          builder: (context, snapshot) {
            return Consumer<RecentaPageModel>(builder: (context, model, child) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _HeaderView(),
                    _SearchField(),
                    StreamBuilder(
                      stream: model.getRecents(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: globalPink,
                            ),
                          );
                        }

                        if (snapshot.data.length == 0) {
                          return Center(child: Text("No Recents"));
                        }

                        return ListView.separated(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 16),
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Colors.black,
                            );
                          },
                          itemBuilder: (context, index) {
                            Recent recent = model.recents[index];
                            return _RecentsCell(
                              recent: recent,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            });
          }),
    );
  }
}

class _RecentsCell extends StatelessWidget {
  const _RecentsCell({
    Key key,
    @required this.recent,
  }) : super(key: key);

  final Recent recent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(chatRoomId: recent.chatroomId),
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleCacheAvatar(
                    imageUrl: recent.withUser.imageUrl,
                    size: 45,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recent.withUser.name,
                            style: googleFont(
                              size: 16,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            recent.lastMessae,
                            style: googleFont(
                              size: 13,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text(
              convertToAgo(recent.date.toDate()),
              style: googleFont(
                size: 12,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
            size: 20,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade100)),
        ),
      ),
    );
  }
}

class _HeaderView extends StatelessWidget {
  const _HeaderView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Conversations",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            TextButton(
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.pink[50],
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.pink,
                      size: 20,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Add New",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                print("Call");
              },
            )
          ],
        ),
      ),
    );
  }
}
