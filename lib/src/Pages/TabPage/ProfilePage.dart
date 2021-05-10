import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_share/src/Extension/CustomWidgets.dart';
import 'package:video_share/src/Extension/Style.dart';
import 'package:video_share/src/Provider/UserState.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Prifile",
              style: googleFont(size: 20),
            ),
            CustomButton(
              title: "Logout",
              backColor: Colors.red,
              onPressed: () {
                final userState =
                    Provider.of<UserState>(context, listen: false);

                userState.logout();
              },
            )
          ],
        ),
      ),
    );
  }
}
