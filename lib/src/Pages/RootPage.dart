import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_share/src/Extension/Style.dart';
import 'package:video_share/src/Pages/HomePage.dart';
import 'package:video_share/src/Provider/UserState.dart';

class BranchPage extends StatelessWidget {
  const BranchPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, model, child) {
        if (currentUser != null) {
          return TabPage();
        } else {
          if (!isSignIn) {
            model.setUser();
          }
        }

        return Center(
          child: CircularProgressIndicator(
            backgroundColor: globalPink,
          ),
        );
      },
    );
  }
}
