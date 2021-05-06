import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_share/src/Extension/CustomWidgets.dart';
import 'package:video_share/src/Provider/UserState.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentUser.name),
            CustomButton(
              title: "Logout",
              backColor: Colors.red,
              onPressed: () {
                final userState =
                    Provider.of<UserState>(context, listen: false);
                userState.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
