import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_share/src/Extension/FirestoreService.dart';
import 'package:video_share/src/Extension/Style.dart';
import 'package:video_share/src/Model/FBUser.dart';
import 'package:video_share/src/Pages/TabPage/ProfilePage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchPageModel>(
      create: (context) => SearchPageModel(),
      builder: (context, snapshot) {
        return Consumer<SearchPageModel>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.pink,
                title: TextField(
                  controller: model.searchControtller,
                  style: googleFont(size: 13),
                  decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    border: InputBorder.none,
                    hintText: "Search User...",
                    hintStyle: googleFont(size: 13),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                    suffixIcon: model.searchText.trim().isEmpty
                        ? null
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.clear),
                                onPressed: model.clearField,
                              ),
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.search),
                                onPressed: model.searchUser,
                              ),
                            ],
                          ),
                  ),
                  onChanged: (value) {
                    setState(
                      () {
                        model.searchText = value;
                      },
                    );
                  },
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      model.searchUser();
                    }
                  },
                  // onChanged: model.onchanged,
                ),
              ),
              body: model.query == null
                  ? Center(
                      child: Text("Search User..."),
                    )
                  : FutureBuilder(
                      future: model.query,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: globalPink,
                            ),
                          );
                        }
                        if (snapshot.data.docs.length == 0) {
                          return Center(
                            child: Text('No Users found! Please try again.'),
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            FBUser user =
                                FBUser.fromDocument(snapshot.data.docs[index]);
                            return UserCell(
                              user: user,
                              ontap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProfilePage(
                                        user: user,
                                        hasBackButton: true,
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            );
          },
        );
      },
    );
  }
}

class SearchPageModel extends ChangeNotifier {
  TextEditingController searchControtller = TextEditingController();
  String searchText = "";
  Future<QuerySnapshot> query;

  void clearField() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => searchControtller.clear());

    searchText = "";
    notifyListeners();
  }

  void searchUser() {
    query = FirestoreService.searchUser(searchText);
    notifyListeners();
  }
}

class UserCell extends StatelessWidget {
  const UserCell({
    Key key,
    @required this.user,
    @required this.ontap,
  }) : super(key: key);

  final FBUser user;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 20,
        backgroundImage: user.imageUrl == null
            ? AssetImage("assets/images/user_placeholder.jpg")
            : CachedNetworkImageProvider(user.imageUrl),
      ),
      title: Row(
        children: [
          Text(user.name),
        ],
      ),
      trailing: SizedBox.shrink(),
      onTap: ontap,
    );
  }
}
