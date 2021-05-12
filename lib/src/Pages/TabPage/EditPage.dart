import 'package:flutter/material.dart';
import 'package:video_share/src/Model/FBUser.dart';

class EditPage extends StatelessWidget {
  const EditPage({
    Key key,
  }) : super(key: key);

  static const String id = "Edit";

  @override
  Widget build(BuildContext context) {
    FBUser user = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
      ),
      body: Center(
        child: Text(
          user.uid,
        ),
      ),
    );
  }
}
