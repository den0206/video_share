import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_share/src/Pages/HomePage.dart';
import 'package:video_share/src/Provider/UserState.dart';

class BranchPage extends StatelessWidget {
  const BranchPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      final userState = Provider.of<UserState>(context);
      userState.setUser();
    }
    return Consumer<UserState>(
      builder: (context, model, child) {
        if (currentUser != null) {
          return HomePage();
        } else {
          // model.setUser();
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
